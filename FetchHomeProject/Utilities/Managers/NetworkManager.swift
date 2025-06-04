
import SwiftUI

final class NetworkManager {
    static let shared = NetworkManager()
    private let imageCache: ImageCacher
    private let fetcher: DataFetcher
    
    init(fetcher: DataFetcher = Fetcher(), imageCache: ImageCacher = ImageCache()) {
        self.fetcher = fetcher
        self.imageCache = imageCache
    }
    
    static let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/"
    static let recipesURL = baseURL + "recipes.json"
    static let malformedURL =  baseURL + "recipes-malformed.json"
    static let emptyDataURL =  baseURL + "recipes-empty.json"
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: Self.recipesURL) else {
            throw APIError.invalidURL
        }
        let data = try fetcher.fetchData(from: url)
        let decoder = JSONDecoder()
        guard let recipes = try? decoder.decode(RecipeResponse.self, from: data) else {
            throw APIError.malformedData
        }
        if recipes.recipes.count == 0 {
            throw APIError.noData
        }
        return recipes.recipes
    }
    
    func downloadImage(fromURLString: String?) async throws -> UIImage? {
        if let fromURLString {
            if fromURLString.isEmpty {
                return nil
            }
            let url = URL(string: fromURLString)!
            if let cachedImage = imageCache.image(for: url) {
                return cachedImage
            }
            let data = try fetcher.fetchData(from: url)
            guard let image = UIImage(data: data) else {
                throw NSError(domain: "Invalid Image Data", code: 0, userInfo: nil)
            }
            imageCache.store(image, for: url)
            return image
        } else {
            return nil
        }
    }
}
