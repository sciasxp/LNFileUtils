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

public struct FileUtils {
    
    static let shared = FileUtils()
    
    private init() {}
    
    public func store(key: String, data: Data, `on` type: StorageTypes) throws {
        switch type {
        case .userDefaults:
            storeDataOnUserDefaults(key: key, data: data)
        case .fileSystem(let place):
            try storeDataOnFileSystem(key: key, data: data, place: place)
        }
    }
    
    public func retrive(key: String, from type: StorageTypes) throws -> Data? {
        switch type {
        case .userDefaults:
            return retriveDataOnUserDefaults(key: key)
        case .fileSystem(let place):
            return try retriveDataOnFileSystem(key: key, place: place)
        }
    }
    
    private func storeDataOnUserDefaults(key: String, data: Data) {
        UserDefaults.standard.set(data, forKey: key)
    }
    
    private func retriveDataOnUserDefaults(key: String) -> Data? {
        UserDefaults.standard.data(forKey: key)
    }
    
    private func storeDataOnFileSystem(key: String, data: Data, place: FileSystemPlaces) throws {
        let url = try url(for: key, place: place)
        try data.write(to: url)
    }
    
    private func url(for key: String, place: FileSystemPlaces) throws -> URL {
        let directory: FileManager.SearchPathDirectory
        
        switch place {
        case .document: directory = .documentDirectory
        case .cache: directory = .cachesDirectory
        case .library: directory = .libraryDirectory
        }
        
        guard let directoryURL = FileManager.default.urls(
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
}
