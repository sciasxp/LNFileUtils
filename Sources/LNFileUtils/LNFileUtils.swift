import Foundation

public enum FileSystemErrors: Error {
    case retrivingDirectoryPath
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
    public func store(key: String, data: Data, `on` type: StorageTypes) throws -> URL? {
        var url: URL?
        
        switch type {
        case .userDefaults:
            storeDataOnUserDefaults(key: key, data: data)
        case .fileSystem(let place):
            url = try storeDataOnFileSystem(key: key, data: data, place: place)
        }
        
        return url
    }
    
    public func retrieve(key: String, from type: StorageTypes) throws -> Data? {
        var data: Data?
        
        if let data = memoryCache[key] {
            return data
        }
        
        switch type {
        case .userDefaults:
            data = retriveDataOnUserDefaults(key: key)
        case .fileSystem(let place):
            data = try retriveDataOnFileSystem(key: key, place: place)
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
    
    private func storeDataOnFileSystem(key: String, data: Data, place: FileSystemPlaces) throws -> URL? {
        let url = try url(for: key, place: place)
        try data.write(to: url)
        return url
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
    
    private func retriveDataOnFileSystem(key: String, place: FileSystemPlaces) throws -> Data {
        let url = try url(for: key, place: place)
        return try Data(contentsOf: url)
    }
    
    private func removeDataOnFileSystem(key: String, place: FileSystemPlaces) throws {
        let url = try url(for: key, place: place)
        try FileManager.default.removeItem(at: url)
    }
}
