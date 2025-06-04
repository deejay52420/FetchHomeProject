
import SwiftUI

final class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var cuisines: [String] = []
    @Published var isLoading = false
    @Published var isShowingDetail = false
    @Published var selectedRecipe: Recipe?
    @Published var isAPIError: APIError?
    
    @MainActor
    func getRecipes() {
        isLoading = true
        Task {
            do {
                recipes = try await NetworkManager.shared.fetchRecipes()
                
            } catch let error as APIError {
                switch error {
                case .noData:
                    isAPIError = error
                case .invalidURL:
                    isAPIError = error
                case .malformedData:
                    isAPIError = error
                case .unknown(_):
                    isAPIError = error
                }
            } catch {
                print("Error: \(error)")
                isAPIError = APIError.unknown(error)
            }
            isLoading = false
        }
    }
}
