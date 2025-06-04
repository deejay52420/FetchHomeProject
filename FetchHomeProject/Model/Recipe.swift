import Foundation

struct Recipe: Decodable, Identifiable {
    
    let id, name, cuisine: String
    let photoURLSmall, photoURLLarge: String?
    let sourceURL, youtubeURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case cuisine
        case id = "uuid"
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

struct RecipeResponse: Decodable {
    let recipes: [Recipe]
}

//Used for Previews
struct MockData {
    
    static let sampleRecipe = Recipe(id: "test-1", name: "Test Recipe", cuisine: "American", photoURLSmall: nil, photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", sourceURL: "", youtubeURL: "")
    static let recipes = [sampleRecipe, sampleRecipe, sampleRecipe, sampleRecipe]
}
