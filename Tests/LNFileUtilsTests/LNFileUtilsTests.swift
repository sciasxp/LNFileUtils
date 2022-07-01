import XCTest
@testable import LNFileUtils

final class LNFileUtilsTests: XCTestCase {
    
    override class func tearDown() {
        UserDefaults.standard.removeObject(forKey: "defaultStorageTeste")
        UserDefaults.standard.removeObject(forKey: "defaultRetrieveTeste")
        UserDefaults.standard.removeObject(forKey: "defaultRemoveTeste")
    }
    
    func test_UserDefaultsStorage() throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try utils.store(key: "defaultStorageTeste", data: data, on: .userDefaults)
        let sut: Data = UserDefaults.standard.object(forKey: "defaultStorageTeste") as! Data
        
        XCTAssertEqual(sut, data)
    }
    
    func test_UserDefaultsRetrieve() throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try utils.store(key: "defaultRetrieveTeste", data: data, on: .userDefaults)
        
        let sut = try utils.retrieve(key: "defaultRetrieveTeste", from: .userDefaults)
        
        XCTAssertEqual(sut, data)
    }
    
    func test_UserDefaultsRemove() throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try utils.store(key: "defaultRemoveTeste", data: data, on: .userDefaults)
        
        try utils.remove(key: "defaultRemoveTeste", from: .userDefaults)
        
        let sut = try utils.retrieve(key: "defaultRemoveTeste", from: .userDefaults)
        
        XCTAssertNil(sut)
    }
    
    func test_fileSystemCacheStorage() throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        let url = try utils.store(key: "fileSystemCacheStorageTeste", data: data, on: .fileSystem(place: .cache))!
        
        let exists = FileManager.default.fileExists(atPath: url.path)
        
        XCTAssertTrue(exists)
    }
    
    func test_fileSystemCacheRetrieve() throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try utils.store(key: "fileSystemCacheRetrieveTeste", data: data, on: .fileSystem(place: .cache))
        
        let sut = try utils.retrieve(key: "fileSystemCacheRetrieveTeste", from: .fileSystem(place: .cache))
        
        XCTAssertEqual(sut, data)
    }
    
    func test_fileSystemCacheRemove() throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try utils.store(key: "fileSystemCacheRemoveTeste", data: data, on: .fileSystem(place: .cache))
        
        try utils.remove(key: "fileSystemCacheRemoveTeste", from: .fileSystem(place: .cache))
        
        do {
            let sut = try utils.retrieve(key: "fileSystemCacheRemoveTeste", from: .fileSystem(place: .cache))
            XCTAssertNil(sut)
        } catch {
            XCTAssertEqual((error as NSError).code, 260)
        }
    }
    
    func test_fileSystemDocumentStorage() throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        let url = try utils.store(key: "fileSystemDocumentStorageTeste", data: data, on: .fileSystem(place: .document))!
        
        let exists = FileManager.default.fileExists(atPath: url.path)
        
        XCTAssertTrue(exists)
    }
    
    func test_fileSystemDocumentRetrieve() throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try utils.store(key: "fileSystemDocumentRetrieveTeste", data: data, on: .fileSystem(place: .document))
        
        let sut = try utils.retrieve(key: "fileSystemDocumentRetrieveTeste", from: .fileSystem(place: .document))
        
        XCTAssertEqual(sut, data)
    }
    
    func test_fileSystemDocumentRemove() throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try utils.store(key: "fileSystemDocumentRemoveTeste", data: data, on: .fileSystem(place: .document))
        
        try utils.remove(key: "fileSystemDocumentRemoveTeste", from: .fileSystem(place: .document))
        
        do {
            let sut = try utils.retrieve(key: "fileSystemDocumentRemoveTeste", from: .fileSystem(place: .document))
            XCTAssertNil(sut)
        } catch {
            XCTAssertEqual((error as NSError).code, 260)
        }
    }
    
    func test_fileSystemLibraryStorage() throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        let url = try utils.store(key: "fileSystemLibraryStorageTeste", data: data, on: .fileSystem(place: .document))!
        
        let exists = FileManager.default.fileExists(atPath: url.path)
        
        XCTAssertTrue(exists)
    }
    
    func test_fileSystemLibraryRetrieve() throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try utils.store(key: "fileSystemLibraryRetrieveTeste", data: data, on: .fileSystem(place: .document))
        
        let sut = try utils.retrieve(key: "fileSystemLibraryRetrieveTeste", from: .fileSystem(place: .document))
        
        XCTAssertEqual(sut, data)
    }
    
    func test_fileSystemLibraryRemove() throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try utils.store(key: "fileSystemLibraryRemoveTeste", data: data, on: .fileSystem(place: .library))
        
        try utils.remove(key: "fileSystemLibraryRemoveTeste", from: .fileSystem(place: .library))
        
        do {
            let sut = try utils.retrieve(key: "fileSystemLibraryRemoveTeste", from: .fileSystem(place: .library))
            XCTAssertNil(sut)
        } catch {
            XCTAssertEqual((error as NSError).code, 260)
        }
    }
    
    func test_ReadPerfomance() throws {
        let utils = FileUtils.shared
        let data = getData(name: "reference", ext: "png")!
        try utils.store(key: "performance", data: data, on: .fileSystem(place: .cache))
        
        self.measure {
            for _ in 0..<1_000 {
                do {
                    let _ = try utils.retrieve(key: "performance", from: .fileSystem(place: .cache))
                } catch {}
            }
        }
    }
    
    func getData(name: String, ext: String) -> Data? {
        if let path = Bundle.module.url(forResource: name, withExtension: ext) {
            return try? Data(contentsOf: path)
        }
        return nil
    }
}
