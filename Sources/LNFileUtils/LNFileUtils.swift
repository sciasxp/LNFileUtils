import Foundation

public enum FileSystemErrors: Error {
    case retrivingDirectoryPath
    case invalidURL
}

public enum FileSystemPlaces {
    case document
    case library
    case cache
}

public enum StorageTypes {
    case fileSystem(place: FileSystemPlaces)
    case userDefaults
}

public class FileUtils {
    
    public static let shared = FileUtils()
    
    private init() {}
    
    private let ONE_MEGA = 1_024 * 1_024
    
    private var memoryCache: [String: Data] = [:]
    
    @discardableResult
    public func store(key: String, data: Data, `on` type: StorageTypes) async throws -> URL? {
        var url: URL?
        
        switch type {
        case .userDefaults:
            storeDataOnUserDefaults(key: key, data: data)
        case .fileSystem(let place):
            url = try await storeDataOnFileSystem(key: key, data: data, place: place)
        }
        
        return url
    }
    
    public func retrieve(key: String, from type: StorageTypes) async throws -> Data? {
        var data: Data?
        
        if let data = memoryCache[key] {
            return data
        }
        
        switch type {
        case .userDefaults:
            data = retriveDataOnUserDefaults(key: key)
        case .fileSystem(let place):
            data = try await retriveDataOnFileSystem(key: key, place: place)
        }
        
        if let data = data, data.count < ONE_MEGA {
            memoryCache[key] = data
        }
        
        return data
    }
    
    public func remove(key: String, from type: StorageTypes) throws {
        switch type {
        case .userDefaults:
            removeDataOnUserDefaults(key: key)
        case .fileSystem(let place):
            try removeDataOnFileSystem(key: key, place: place)
        }
    }
    
    private func storeDataOnUserDefaults(key: String, data: Data) {
        UserDefaults.standard.set(data, forKey: key)
    }
    
    private func retriveDataOnUserDefaults(key: String) -> Data? {
        UserDefaults.standard.data(forKey: key)
    }
    
    private func removeDataOnUserDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    private func storeDataOnFileSystem(key: String, data: Data, place: FileSystemPlaces) async throws -> URL? {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            do {
                guard let url = try self?.url(for: key, place: place) else {
                    continuation.resume(with: .failure(FileSystemErrors.invalidURL))
                    return
                }
                try data.write(to: url)
                continuation.resume(with: .success(url))
                
            } catch {
                continuation.resume(with: .failure(error))
            }
        }
    }
    
    private func url(for key: String, place: FileSystemPlaces) throws -> URL {
        let directory: FileManager.SearchPathDirectory
        
        switch place {
        case .document: directory = .documentDirectory
        case .cache: directory = .cachesDirectory
        case .library: directory = .libraryDirectory
        }
        
        guard let directoryURL = FileManager.default.urls (
            for: directory,
            in: FileManager.SearchPathDomainMask.userDomainMask
        ).first else {
            throw FileSystemErrors.retrivingDirectoryPath
        }
        
        let url = directoryURL.appendingPathComponent(key)
        return url
    }
    
    private func retriveDataOnFileSystem(key: String, place: FileSystemPlaces) async throws -> Data {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            do {
                guard let url = try self?.url(for: key, place: place) else {
                    continuation.resume(with: .failure(FileSystemErrors.invalidURL))
                    return
                }
                
                let data = try Data(contentsOf: url)
                continuation.resume(with: .success(data))
                
            } catch {
                continuation.resume(with: .failure(error))
            }
        }
    }
    
    private func removeDataOnFileSystem(key: String, place: FileSystemPlaces) throws {
        let url = try url(for: key, place: place)
        try FileManager.default.removeItem(at: url)
    }
}
