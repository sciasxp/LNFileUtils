import XCTest
@testable import LNFileUtils

final class LNFileUtilsTests: XCTestCase {
    
    override class func tearDown() {
        UserDefaults.standard.removeObject(forKey: "defaultStorageTeste")
        UserDefaults.standard.removeObject(forKey: "defaultRetrieveTeste")
        UserDefaults.standard.removeObject(forKey: "defaultRemoveTeste")
    }
    
    func test_UserDefaultsStorage() async throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try await utils.store(key: "defaultStorageTeste", data: data, on: .userDefaults)
        let sut: Data = UserDefaults.standard.object(forKey: "defaultStorageTeste") as! Data
        
        XCTAssertEqual(sut, data)
    }
    
    func test_UserDefaultsRetrieve() async throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try await utils.store(key: "defaultRetrieveTeste", data: data, on: .userDefaults)
        
        let sut = try await utils.retrieve(key: "defaultRetrieveTeste", from: .userDefaults)
        
        XCTAssertEqual(sut, data)
    }
    
    func test_UserDefaultsRemove() async throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try await utils.store(key: "defaultRemoveTeste", data: data, on: .userDefaults)
        
        try utils.remove(key: "defaultRemoveTeste", from: .userDefaults)
        
        let sut = try await utils.retrieve(key: "defaultRemoveTeste", from: .userDefaults)
        
        XCTAssertNil(sut)
    }
    
    func test_fileSystemCacheStorage() async throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        let url = try await utils.store(key: "fileSystemCacheStorageTeste", data: data, on: .fileSystem(place: .cache))!
        
        let exists = FileManager.default.fileExists(atPath: url.path)
        
        XCTAssertTrue(exists)
    }
    
    func test_fileSystemCacheRetrieve() async throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try await utils.store(key: "fileSystemCacheRetrieveTeste", data: data, on: .fileSystem(place: .cache))
        
        let sut = try await utils.retrieve(key: "fileSystemCacheRetrieveTeste", from: .fileSystem(place: .cache))
        
        XCTAssertEqual(sut, data)
    }
    
    func test_fileSystemCacheRemove() async throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try await utils.store(key: "fileSystemCacheRemoveTeste", data: data, on: .fileSystem(place: .cache))
        
        try utils.remove(key: "fileSystemCacheRemoveTeste", from: .fileSystem(place: .cache))
        
        do {
            let sut = try await utils.retrieve(key: "fileSystemCacheRemoveTeste", from: .fileSystem(place: .cache))
            XCTAssertNil(sut)
        } catch {
            XCTAssertEqual((error as NSError).code, 260)
        }
    }
    
    func test_fileSystemDocumentStorage() async throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        let url = try await utils.store(key: "fileSystemDocumentStorageTeste", data: data, on: .fileSystem(place: .document))!
        
        let exists = FileManager.default.fileExists(atPath: url.path)
        
        XCTAssertTrue(exists)
    }
    
    func test_fileSystemDocumentRetrieve() async throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try await utils.store(key: "fileSystemDocumentRetrieveTeste", data: data, on: .fileSystem(place: .document))
        
        let sut = try await utils.retrieve(key: "fileSystemDocumentRetrieveTeste", from: .fileSystem(place: .document))
        
        XCTAssertEqual(sut, data)
    }
    
    func test_fileSystemDocumentRemove() async throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try await utils.store(key: "fileSystemDocumentRemoveTeste", data: data, on: .fileSystem(place: .document))
        
        try utils.remove(key: "fileSystemDocumentRemoveTeste", from: .fileSystem(place: .document))
        
        do {
            let sut = try await utils.retrieve(key: "fileSystemDocumentRemoveTeste", from: .fileSystem(place: .document))
            XCTAssertNil(sut)
        } catch {
            XCTAssertEqual((error as NSError).code, 260)
        }
    }
    
    func test_fileSystemLibraryStorage() async throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        let url = try await utils.store(key: "fileSystemLibraryStorageTeste", data: data, on: .fileSystem(place: .document))!
        
        let exists = FileManager.default.fileExists(atPath: url.path)
        
        XCTAssertTrue(exists)
    }
    
    func test_fileSystemLibraryRetrieve() async throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try await utils.store(key: "fileSystemLibraryRetrieveTeste", data: data, on: .fileSystem(place: .document))
        
        let sut = try await utils.retrieve(key: "fileSystemLibraryRetrieveTeste", from: .fileSystem(place: .document))
        
        XCTAssertEqual(sut, data)
    }
    
    func test_fileSystemLibraryRemove() async throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try await utils.store(key: "fileSystemLibraryRemoveTeste", data: data, on: .fileSystem(place: .library))
        
        try utils.remove(key: "fileSystemLibraryRemoveTeste", from: .fileSystem(place: .library))
        
        do {
            let sut = try await utils.retrieve(key: "fileSystemLibraryRemoveTeste", from: .fileSystem(place: .library))
            XCTAssertNil(sut)
        } catch {
            XCTAssertEqual((error as NSError).code, 260)
        }
    }
    
    func test_ImageExtensionStoreCache() async throws {
        let data = getData(name: "reference", ext: "png")!
        let image = UIImage(data: data)!
    
        let url = try await image.storeCache(with: "fileSystemCacheUIImageExtension", on: .fileSystem(place: .cache))!
        
        let exists = FileManager.default.fileExists(atPath: url.path)
        XCTAssertTrue(exists)
    }
    
    func test_ImageExtensionRetrieveCache() async throws {
        let data = getData(name: "reference", ext: "png")!
        let referenceImage = UIImage(data: data)!
        
        try await referenceImage.storeCache (
            with: "fileSystemCacheUIImageExtension",
            on: .fileSystem(place: .cache),
            as: .png
        )
        
        let sut = try await UIImage.image(
            from: "fileSystemCacheUIImageExtension",
            on: .fileSystem(place: .cache)
        )!
        
        XCTAssertEqual(sut.pngData(), referenceImage.pngData())
    }
    
    func getData(name: String, ext: String) -> Data? {
        if let path = Bundle.module.url(forResource: name, withExtension: ext) {
            return try? Data(contentsOf: path)
        }
        return nil
    }
}
