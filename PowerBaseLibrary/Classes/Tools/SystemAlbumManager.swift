//
//  SystemAlbumManager.swift
//  PowerBaseLibrary
//
//  Created by 邹程 on 2019/9/3.
//

import Foundation
import Photos

@objc public protocol SystemAlbumManagerDelegate: NSObjectProtocol {
    @objc optional func systemAlbumLatestPhoto(phAsset: PHAsset)
    @objc optional func systemAlbumPhotos(phAssets: Array<PHAsset>)
    @objc optional func showNoPhotos()
    @objc optional func showError()
    @objc optional func unauthorized()
}

public class SystemAlbumManager: NSObject {
    /// 相册集
    public var albumResult: PHFetchResult<AnyObject>?
    public var fetchResult: PHFetchResult<AnyObject>?

    public var cachingImageManager: PHCachingImageManager?

    public var previousPreheatRect = CGRect.zero

    public lazy var photoArray = [PHAsset]()

    public var targetSize = CGSize(width: 1, height: 1)

    public weak var systemAlbumDelegate: SystemAlbumManagerDelegate?

    deinit {
        if PHOTO_LIBRARY_STATUS == .authorized {
            self.cachingImageManager?.stopCachingImagesForAllAssets()
        }
    }

    override public init() {
        super.init()

        if PHOTO_LIBRARY_STATUS == .authorized {
            cachingImageManager = PHCachingImageManager()
        }
    }

    // MARK: - computeDifferenceBetweenRect

    public func computeDifferenceBetweenRect(_ oldRect: CGRect, newRect: CGRect, removedHandler: (_ removedRect: CGRect) -> Void, addedHandler: (_ addedRect: CGRect) -> Void) {
        if newRect.intersects(oldRect) {
            let oldMaxY = oldRect.maxY
            let oldMinY = oldRect.minY
            let newMaxY = newRect.maxY
            let newMinY = newRect.minY

            if newMaxY > oldMaxY {
                let rectToAdd = CGRect(x: newRect.origin.x, y: oldMaxY, width: newRect.size.width, height: newMaxY - oldMaxY)
                addedHandler(rectToAdd)
            }

            if oldMinY > newMinY {
                let rectToAdd = CGRect(x: newRect.origin.x, y: newMinY, width: newRect.size.width, height: oldMinY - newMinY)
                addedHandler(rectToAdd)
            }

            if newMaxY < oldMaxY {
                let rectToRemove = CGRect(x: newRect.origin.x, y: newMaxY, width: newRect.size.width, height: oldMaxY - newMaxY)
                removedHandler(rectToRemove)
            }

            if oldMinY < newMinY {
                let rectToRemove = CGRect(x: newRect.origin.x, y: oldMinY, width: newRect.size.width, height: newMinY - oldMinY)
                removedHandler(rectToRemove)
            }
        } else {
            addedHandler(newRect)
            removedHandler(oldRect)
        }
    }

    public func assetsAtIndexPaths(_ indexPaths: [IndexPath]) -> [PHAsset]? {
        if PHOTO_LIBRARY_STATUS == .authorized {
            if fetchResult != nil {
                var assets = [PHAsset]()
                for indexPath in indexPaths {
                    let asset = fetchResult![indexPath.item] as? PHAsset
                    if asset != nil {
                        assets.append(asset!)
                    }
                }

                return assets
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    // MARK: - updateCachedAssets

    public func updateCachedAssets(viewController: UIViewController, collectionView: UICollectionView, columnNum: CGFloat, photoGridWidth: CGFloat) {
        if PHOTO_LIBRARY_STATUS != .authorized {
            return
        }

        let isViewVisible = viewController.isViewLoaded && viewController.view.window != nil
        if !isViewVisible {
            return
        }

        // The preheat window is twice the height of the visible rect.
        var preheatRect = collectionView.bounds
        preheatRect = preheatRect.insetBy(dx: 0.0, dy: -0.5 * preheatRect.height)

        /*
         Check if the collection view is showing an area that is significantly
         different to the last preheated area.
         */
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        if delta > collectionView.bounds.height / columnNum {
            // Compute the assets to start caching and to stop caching.
            var addedIndexPaths = [IndexPath]()
            var removedIndexPaths = [IndexPath]()

            computeDifferenceBetweenRect(previousPreheatRect, newRect: preheatRect, removedHandler: { [weak self] removedRect in
//                if let strongSelf = self {
                    let indexPaths = collectionView.aapl_indexPathsForElementsInRect(removedRect)
                    if indexPaths != nil {
                        removedIndexPaths = indexPaths!
                    }
//                }
            }, addedHandler: { [weak self] addedRect in
//                if let strongSelf = self {
                    let indexPaths = collectionView.aapl_indexPathsForElementsInRect(addedRect)
                    if indexPaths != nil {
                        addedIndexPaths = indexPaths!
                    }
//                }
            })

            let assetsToStartCaching = assetsAtIndexPaths(addedIndexPaths)
            let assetsToStopCaching = assetsAtIndexPaths(removedIndexPaths)

            if assetsToStartCaching != nil {
                let imageRequestOptions = PHImageRequestOptions()
                imageRequestOptions.resizeMode = .fast
                cachingImageManager?.startCachingImages(for: assetsToStartCaching!, targetSize: CGSize(width: photoGridWidth, height: photoGridWidth), contentMode: .aspectFill, options: imageRequestOptions)
            }

            if assetsToStopCaching != nil {
                let imageRequestOptions = PHImageRequestOptions()
                imageRequestOptions.resizeMode = .fast
                cachingImageManager?.stopCachingImages(for: assetsToStopCaching!, targetSize: CGSize(width: photoGridWidth, height: photoGridWidth), contentMode: .aspectFill, options: imageRequestOptions)
            }

            previousPreheatRect = preheatRect
        }
    }

    // MARK: - loadLatestPhoto

    public func loadLatestPhoto() {
        if PHOTO_LIBRARY_STATUS != .authorized {
            return
        }

        photoArray.removeAll()
        albumResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil) as? PHFetchResult<AnyObject>
        if albumResult != nil {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)

            if albumResult!.count > 0 {
                albumResult!.enumerateObjects({ obj, _, _ in
                    let assetCollection = obj as? PHAssetCollection
                    if assetCollection?.assetCollectionSubtype == .smartAlbumUserLibrary {
                        self.fetchResult = PHAsset.fetchAssets(in: assetCollection!, options: fetchOptions) as? PHFetchResult<AnyObject>
                        if self.fetchResult != nil {
                            let asset = self.fetchResult!.lastObject as? PHAsset
                            if asset != nil {
                                let imageRequestOptions = PHImageRequestOptions()
                                imageRequestOptions.resizeMode = .fast
                                imageRequestOptions.isNetworkAccessAllowed = true
                                imageRequestOptions.isSynchronous = true

                                self.cachingImageManager?.requestImage(for: asset!, targetSize: CGSize(width: self.targetSize.width, height: self.targetSize.height), contentMode: .aspectFill, options: imageRequestOptions) { _, info in
                                    if info != nil {
                                        let iCloud = info!["PHImageResultIsInCloudKey"]
                                        if iCloud == nil {
                                            self.photoArray.append(asset!)
                                        }
                                    }
                                }
                            }
                        }
                    }
                })

                if photoArray.count > 0 {
                    systemAlbumDelegate?.systemAlbumLatestPhoto?(phAsset: photoArray[0])
                }
            } else {
                systemAlbumDelegate?.showNoPhotos?()
            }
        } else {
            systemAlbumDelegate?.showNoPhotos?()
        }
    }

    // MARK: - loadPhotos

    public func loadPhotos(ascending: Bool = true) {
        if PHOTO_LIBRARY_STATUS != .authorized {
            systemAlbumDelegate?.unauthorized?()
            return
        }

        albumResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil) as? PHFetchResult<AnyObject>
        if albumResult != nil {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: ascending)]
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)

            if albumResult!.count > 0 {
                albumResult!.enumerateObjects({ obj, _, _ in
                    let assetCollection = obj as? PHAssetCollection
                    if assetCollection?.assetCollectionSubtype == .smartAlbumUserLibrary {
                        self.fetchResult = PHAsset.fetchAssets(in: assetCollection!, options: fetchOptions) as? PHFetchResult<AnyObject>
                        if self.fetchResult != nil {
                            self.fetchResult!.enumerateObjects({ [weak self] obj, _, _ in
                                let asset = obj as? PHAsset
                                if asset != nil {
                                    if let strongSelf = self {
                                        // let option = PHImageRequestOptions()
                                        // option.networkAccessAllowed = false
                                        // option.synchronous = true
                                        // strongSelf.cachingImageManager.requestImageDataForAsset(asset!, options: option, resultHandler: { (imageData, dataUTI, orientation, info) in
                                        // if imageData != nil {
                                        // strongSelf.photoArray.append(asset!)
                                        // }
                                        // })

                                        let imageRequestOptions = PHImageRequestOptions()
                                        imageRequestOptions.resizeMode = .fast
                                        imageRequestOptions.isNetworkAccessAllowed = true
                                        imageRequestOptions.isSynchronous = true
                                        // imageRequestOptions.progressHandler = { (progress, error, stop, info) in
                                        // }

                                        strongSelf.cachingImageManager?.requestImage(for: asset!, targetSize: CGSize(width: strongSelf.targetSize.width, height: strongSelf.targetSize.height), contentMode: .aspectFill, options: imageRequestOptions) { _, info in
                                            if info != nil {
                                                let iCloud = info!["PHImageResultIsInCloudKey"]
                                                if iCloud == nil {
                                                    strongSelf.photoArray.append(asset!)
                                                }
                                            }
                                        }
                                    }
                                }
                            })
                        }
                    }
                })

                systemAlbumDelegate?.systemAlbumPhotos?(phAssets: photoArray)
            } else {
                systemAlbumDelegate?.showNoPhotos?()
            }
        } else {
            systemAlbumDelegate?.showNoPhotos?()
        }
    }

    public func fixOrientation(_ srcImg: UIImage) -> UIImage {
        if srcImg.imageOrientation == UIImage.Orientation.up {
            return srcImg
        }

        var transform = CGAffineTransform.identity

        switch srcImg.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: srcImg.size.width, y: srcImg.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: srcImg.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: srcImg.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored: break
        }

        switch srcImg.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: srcImg.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: srcImg.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right: break
        }

        // 上下文
        let ctx: CGContext = CGContext(data: nil, width: Int(srcImg.size.width), height: Int(srcImg.size.height), bitsPerComponent: srcImg.cgImage!.bitsPerComponent, bytesPerRow: 0, space: srcImg.cgImage!.colorSpace!, bitmapInfo: srcImg.cgImage!.bitmapInfo.rawValue)!

        ctx.concatenate(transform)

        switch srcImg.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(srcImg.cgImage!, in: CGRect(x: 0, y: 0, width: srcImg.size.height, height: srcImg.size.width))
        default:
            ctx.draw(srcImg.cgImage!, in: CGRect(x: 0, y: 0, width: srcImg.size.width, height: srcImg.size.height))
        }

        let cgImg: CGImage = ctx.makeImage()!
        let img: UIImage = UIImage(cgImage: cgImg)

        ctx.closePath()
        return img
    }

    // MARK: - fixImageOrientation

    public func fixImageOrientation(_ imageData: Data, orientation: UIImage.Orientation) -> Data? {
        if PHOTO_LIBRARY_STATUS != .authorized {
            return nil
        }

        if orientation == .up {
            return imageData
        }

        let image = UIImage(data: imageData)
        if image != nil {
            var transform = CGAffineTransform.identity

            let width = image!.size.width
            let height = image!.size.height

            switch orientation {
            case .down, .downMirrored:
                transform = transform.translatedBy(x: width, y: height)
                transform = transform.rotated(by: CGFloat(Double.pi))
                break

            case .left, .leftMirrored:
                transform = transform.translatedBy(x: width, y: 0)
                transform = transform.rotated(by: CGFloat(Double.pi / 2))
                break

            case .right, .rightMirrored:
                transform = transform.translatedBy(x: 0, y: height)
                transform = transform.rotated(by: CGFloat(-Double.pi / 2))
                break

            default:
                break
            }

            switch orientation {
            case .upMirrored, .downMirrored:
                transform = transform.translatedBy(x: width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
                break

            case .leftMirrored, .rightMirrored:
                transform = transform.translatedBy(x: height, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
                break

            default:
                break
            }

            let ctx = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: image!.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image!.cgImage!.colorSpace!, bitmapInfo: image!.cgImage!.bitmapInfo.rawValue)

            ctx!.concatenate(transform)

            switch orientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx!.draw(image!.cgImage!, in: CGRect(x: 0, y: 0, width: height, height: width))
                break

            default:
                ctx!.draw(image!.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
                break
            }

            let cgimg = ctx!.makeImage()
            if cgimg != nil {
                let newImage = UIImage(cgImage: cgimg!)
                let newImageData = newImage.jpegData(compressionQuality: 0.8)

                return newImageData
            }
        }

        return nil
    }

    // MARK: - getImageData

    public func getImageData(_ asset: PHAsset, action: @escaping ((Data?) -> Void)) {
        if PHOTO_LIBRARY_STATUS != .authorized {
            return action(nil)
        }

        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.resizeMode = .none
        imageRequestOptions.isSynchronous = true

        let imageManager = PHImageManager.default()
        imageManager.requestImageData(for: asset, options: imageRequestOptions) { [weak self] imageData, _, orientation, _ in
            if let strongSelf = self {
                if imageData != nil {
                    DEBUGLOG("原图大小是: \(imageData!.count)")

                    var newImageData = strongSelf.fixImageOrientation(imageData!, orientation: orientation)

                    DEBUGLOG("修正方向后的原图大小是: \(String(describing: newImageData?.count))")

                    if let data = newImageData, data.count > 1048576 {
                        let image = UIImage(data: newImageData!)

                        if image != nil {
                            DEBUGLOG("原图的分辨率： 宽（\(String(describing: image?.size.width))）高（\(String(describing: image?.size.height))）")

                            var newImage: UIImage?

                            if image!.size.width > 1080 || image!.size.height > 1920 {
                                newImage = imageCompressForWidth(image!, targetWidth: 1080)
                                DEBUGLOG("裁剪后的图片分辨率： 宽（\(String(describing: newImage?.size.width))）高（\(String(describing: newImage?.size.height))）")
                            } else {
                                newImage = image
                            }

                            if newImage != nil {
                                newImageData = newImage?.jpegData(compressionQuality: 0.8)
                                DEBUGLOG("裁剪压缩后的图片大小是: \(String(describing: newImageData?.count))")

                                if newImageData != nil {
                                    action(newImageData!)
                                }
                            }
                        }
                    } else if newImageData != nil {
                        action(newImageData!)
                    }
                } else {
                    action(nil)
                }
            }
        }
    }

    // MARK: - getFixImageData

    public func getFixImageData(_ image: UIImage, action: @escaping ((Data?) -> Void)) {
        if let imageData = image.pngData() {
            DEBUGLOG("原图大小是: \(imageData.count)")

            var newImageData: Data?

            if imageData.count > 1048576 {
                DEBUGLOG("原图的分辨率： 宽（\(String(describing: image.size.width))）高（\(String(describing: image.size.height))）")

                var newImage: UIImage?

                if image.size.width > 1080 || image.size.height > 1920 {
                    newImage = imageCompressForWidth(image, targetWidth: 1080)
                    DEBUGLOG("裁剪后的图片分辨率： 宽（\(String(describing: newImage?.size.width))）高（\(String(describing: newImage?.size.height))）")
                } else {
                    newImage = image
                }

                if newImage != nil {
                    newImageData = newImage?.jpegData(compressionQuality: 0.8)
                    DEBUGLOG("裁剪压缩后的图片大小是: \(String(describing: newImageData?.count))")

                    if newImageData != nil {
                        action(newImageData!)
                    }
                }
            } else {
                action(imageData)
            }
        } else {
            action(nil)
        }
    }
}
