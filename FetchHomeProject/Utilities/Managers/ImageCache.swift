
import SwiftUI

protocol ImageCacher {
    func image(for url: URL) -> UIImage?
    func store(_ image: UIImage, for url: URL)
}

class ImageCache: ImageCacher {
    private var cache: [URL: UIImage] = [:]
    
    func store(_ image: UIImage, for url: URL) {
        cache[url] = image
    }
    
    func image(for url: URL) -> UIImage? {
        return cache[url]
    }
}
