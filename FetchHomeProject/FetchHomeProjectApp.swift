
import SwiftUI

@main
struct FetchHomeProjectApp: App {
    var viewModel = RecipeListViewModel()
    
    var body: some Scene {
        WindowGroup {
            RecipeListView()
        }.environmentObject(viewModel)
    }
}
