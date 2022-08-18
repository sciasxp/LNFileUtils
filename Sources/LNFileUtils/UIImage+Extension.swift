import UIKit
import SwiftQOI

public enum ImageRepresentation {
    case png
    case jpg(quality: CGFloat)
    case heic(quality: CGFloat)
    case qoi
}

public enum ImageRepresentationErrors: Error {
    case convert
}

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError()
        }
    }
}

public extension UIImage {
    private var cgImageOrientation: CGImagePropertyOrientation { .init(imageOrientation) }
    
    func heic(compressionQuality: CGFloat = 1) -> Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
              let destination = CGImageDestinationCreateWithData(mutableData, "public.heic" as CFString, 1, nil),
              let cgImage = cgImage
        else { return nil }
        
        let options = [
            kCGImageDestinationLossyCompressionQuality: compressionQuality,
            kCGImagePropertyOrientation: cgImageOrientation.rawValue
        ] as CFDictionary
        
        CGImageDestinationAddImage(destination, cgImage, options)
        
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
    
    @discardableResult
    func storeCache (
        with key: String,
        on storageType: StorageTypes,
        `as` imageRepresentation: ImageRepresentation = .png
    ) async throws -> URL? {
        
        let dataRepresentation = try self.dataRepresentation(for: imageRepresentation)
        
        return try await FileUtils.shared.store(key: key, data: dataRepresentation, on: storageType)
    }
    
    static func image(from key: String, on storageType: StorageTypes) async throws -> UIImage? {
        guard let dataRepresentation = try await FileUtils.shared.retrieve(key: key, from: storageType) else { return nil }
        
        return SwiftQOI().isQOI(data: dataRepresentation) ?
            UIImage(qoi: dataRepresentation) :
            UIImage(data: dataRepresentation)
    }
    
    static func removeCache(with key: String, on storageType: StorageTypes) throws {
        try FileUtils.shared.remove(key: key, from: storageType)
    }
    
    func dataRepresentation(for type: ImageRepresentation) throws -> Data {
        let data: Data?
        
        switch type {
        case .jpg(let quality):
            data = self.jpegData(compressionQuality: quality)
        case .png:
            data = self.pngData()
        case .heic(let quality):
            data = self.heic(compressionQuality: quality)
        case .qoi:
            data = self.qoiData()
        }
        
        guard let data = data else {
            throw ImageRepresentationErrors.convert
        }
        
        return data
    }
}
