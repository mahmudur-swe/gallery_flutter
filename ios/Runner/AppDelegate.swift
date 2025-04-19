import Flutter
import UIKit
import Photos

@main
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller = window?.rootViewController as! FlutterViewController

        let configChannel = FlutterMethodChannel(
            name: "gallery_flutter/config", binaryMessenger: controller.binaryMessenger)

        configChannel.setMethodCallHandler { call, result in
            if call.method == "getTotalMemory" {
                let total = ProcessInfo.processInfo.physicalMemory / (1024 * 1024)
                result(Int(total))
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        let photoChannel = FlutterMethodChannel(
            name: "gallery_flutter/photos", binaryMessenger: controller.binaryMessenger)

        photoChannel.setMethodCallHandler { (call, result) in
            switch call.method {

            case "getPhotos":

                self.getPhotos(result: result)
            case "getThumbnailBytes":
                guard let args = call.arguments as? [String: Any],
                    let assetId = args["uri"] as? String,
                    let resolution = args["resolution"] as? String
                else {
                    result(
                        FlutterError(code: "INVALID_ARGS", message: "Missing assetId", details: nil)
                    )
                    return
                }
                self.getThumbnailFromFilePath(
                    assetId: assetId, resolution: resolution, result: result)

            case "getFullFrameImage":
                guard let args = call.arguments as? [String: Any],
                    let assetId = args["uri"] as? String
                else {
                    result(
                        FlutterError(code: "INVALID_ARGS", message: "Missing assetId", details: nil)
                    )
                    return
                }
                self.getFullFrameImage(assetId: assetId, result: result)

            case "savePhoto":
                if let args = call.arguments as? [String: Any],
                    let imageBytes = args["imageBytes"] as? FlutterStandardTypedData
                {
                    self.saveImageToGallery(data: imageBytes.data, result: result)
                } else {
                    result(
                        FlutterError(
                            code: "INVALID_ARGS", message: "Missing imageBytes", details: nil)
                    )
                    return
                }

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func getPhotos(result: @escaping FlutterResult) {

        var photoListList = [[String: Any]]()

        // Request photo library authorization
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                DispatchQueue.main.async {
                    result(
                        FlutterError(
                            code: "PERMISSION_DENIED", message: "Photo library access denied",
                            details: nil))
                }
                return
            }

            let assets = PHAsset.fetchAssets(with: .image, options: nil)
            let imageManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true  // We are making this synchronous to ensure that the results are returned immediately
            requestOptions.deliveryMode = .highQualityFormat

            // Iterate over each asset in the album
            assets.enumerateObjects { (asset, _, _) in
                // Request image data for the asset
                imageManager.requestImageData(for: asset, options: requestOptions) {
                    (data, _, _, info) in
                    if let data = data {

                        // Create a unique file name for the photo with dynamic file extension
                        let fileName = UUID().uuidString + ".png"
                        let filePath = NSTemporaryDirectory() + fileName

                        // Save the image data to the temporary directory
                        if FileManager.default.createFile(
                            atPath: filePath, contents: data, attributes: nil)
                        {
                            // Add media data with the file path (URI) to the list
                            photoListList.append([
                                "id": asset.localIdentifier,
                                "name": asset.value(forKey: "filename") as? String ?? "Unknown",
                                "uri": filePath,  // Return the file path of the photo
                            ])
                        }
                    }
                }
            }

            result(photoListList)
        }
    }

    func getFullFrameImage(assetId: String, result: @escaping FlutterResult) {
        let fileURL = URL(fileURLWithPath: assetId)

        do {
            // Read the image data from the file
            let data = try Data(contentsOf: fileURL)

            // Return the byte array to Flutter
            result(FlutterStandardTypedData(bytes: data))
        } catch {
            print("Error: Failed to read image data from file \(assetId)")
            result(nil)
        }
    }

    func getThumbnailFromFilePath(
        assetId: String, resolution: String, result: @escaping FlutterResult
    ) {
        let fileURL = URL(fileURLWithPath: assetId)

        let targetSize =
            if (resolution == "low") {
                CGSize(width: 25, height: 25)
            } else if (resolution == "high") {
                CGSize(width: 300, height: 300)
            } else {
                CGSize(width: 100, height: 100)
            }

        do {
            // Read the image data from the file
            let data = try Data(contentsOf: fileURL)

            // Convert the data into a UIImage
            if let image = UIImage(data: data) {
                // Resize the image to 100x100
                let resizedImage = resizeImage(image: image, targetSize: targetSize)

                // Convert the resized image to PNG data
                if let resizedData = resizedImage.pngData() {
                    // Return the byte array (PNG data) to Flutter
                    result(FlutterStandardTypedData(bytes: resizedData))
                } else {
                    print("Error: Could not convert resized image to PNG data.")
                    result(nil)
                }
            } else {
                print("Error: Failed to create UIImage from data.")
                result(nil)
            }
        } catch {
            print("Error: Failed to read image data from file \(assetId)")
            result(nil)
        }
    }

    // Helper function to resize the image
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        // Determine scale factor
        let scaleFactor = min(widthRatio, heightRatio)

        // Calculate new size based on scale factor
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

        // Resize the image
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage ?? image  // Return the resized image or original if resizing fails
    }

    private func saveImageToGallery(data: Data, result: @escaping FlutterResult) {
        guard let image = UIImage(data: data) else {
            result(
                FlutterError(
                    code: "INVALID_IMAGE", message: "Failed to convert data to image.", details: nil
                ))
            return
        }

        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                switch status {
                case .authorized, .limited:
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    result(true)
                case .denied, .restricted:
                    result(
                        FlutterError(
                            code: "PERMISSION_DENIED", message: "Photo library access denied.",
                            details: nil))
                case .notDetermined:
                    // Handle not determined case if necessary
                    result(
                        FlutterError(
                            code: "PERMISSION_NOT_DETERMINED",
                            message: "Photo library permission not determined.", details: nil))
                @unknown default:
                    result(
                        FlutterError(
                            code: "UNKNOWN_STATUS",
                            message: "Unknown photo library authorization status.", details: nil))
                }
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    result(true)
                case .denied, .restricted:
                    result(
                        FlutterError(
                            code: "PERMISSION_DENIED", message: "Photo library access denied.",
                            details: nil))
                case .notDetermined:
                    // Handle not determined case if necessary
                    result(
                        FlutterError(
                            code: "PERMISSION_NOT_DETERMINED",
                            message: "Photo library permission not determined.", details: nil))
                @unknown default:
                    result(
                        FlutterError(
                            code: "UNKNOWN_STATUS",
                            message: "Unknown photo library authorization status.", details: nil))
                }
            }
        }
    }

}