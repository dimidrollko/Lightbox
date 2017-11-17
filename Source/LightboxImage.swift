import UIKit
import Imaginary

open class LightboxImage {
    //Custom callbacks for:
    public typealias ResponseLoadingClosure = ((_ result: UIImage?) -> Void) //Response callback when image loaded
    public typealias CustomImageLoaderClosure = ((_ imageView: UIImageView?, _ imageURL :String?, _ placeholder: UIImage?, _ callback: ResponseLoadingClosure?)-> Void) //Callback for custom image loading

    open fileprivate(set) var image: UIImage?
    open fileprivate(set) var imageURL: URL?
    open fileprivate(set) var videoURL: URL?
    //Custom image loader prefferences
    open fileprivate(set) var imageStr : String?
    open fileprivate(set) var customLoader : CustomImageLoaderClosure?
    open var text: String
    
    // MARK: - Initialization
    
    public init(image: UIImage, text: String = "", videoURL: URL? = nil) {
        self.image = image
        self.text = text
        self.videoURL = videoURL
    }
    
    public init(imageURL: URL, text: String = "", videoURL: URL? = nil) {
        self.imageURL = imageURL
        self.text = text
        self.videoURL = videoURL
    }
    
    public init(URL: String, placeholder: UIImage?, text: String = "", customImageLoader: @escaping CustomImageLoaderClosure) {
        self.imageStr = URL
        self.text = text
        self.image = placeholder
        self.customLoader = customImageLoader
    }

    open func addImageTo(_ imageView: UIImageView, completion: ((_ image: UIImage?) -> Void)? = nil) {
        if let customImgLoader = customLoader {
            customImgLoader(imageView, imageStr, image, { imageResponse in
                completion?(imageResponse)
            })
            return
        }
        if let image = image {
            imageView.image = image
            completion?(image)
        } else if let imageURL = imageURL {
            imageView.setImage(url: imageURL, placeholder: nil, completion: { result in
                switch result {
                case .value(let image):
                    completion?(image)
                case .error:
                    completion?(nil)
                }
            })
        }
    }
}
