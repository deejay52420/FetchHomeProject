
import SwiftUI

struct ErrorRecipeView: View {
    
    @EnvironmentObject var viewModel: RecipeListViewModel
    
    let title: String
    
    var body: some View {
        
        ZStack {
            NavigationStack
            {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Image("error")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding()
                }
                .offset(y: -250)
                .navigationTitle("⚠️ Error")
                .toolbar {
                    ReloadBarButton(function: { viewModel.isAPIError = nil; viewModel.getRecipes()})
                }
            }
        }
    }
}

#Preview {
    ErrorRecipeView(title: "No Recipes Found")
}
