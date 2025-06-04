import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var viewModel: RecipeListViewModel
    @State private var selectedCuisine: String? = nil
    
    var body: some View {
        ZStack {
            NavigationStack {
                
                List(viewModel.recipes.filter { selectedCuisine == nil || $0.cuisine == selectedCuisine }) { recipe in
                    RecipeListCell(recipe: recipe)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            viewModel.selectedRecipe = recipe
                            viewModel.isShowingDetail = true
                        }
                }
                .frame(maxWidth: .infinity)
                .listStyle(.plain)
                .navigationTitle("🥘 Recipes")
                .toolbar {
                    
                    filterButton()
                    ReloadBarButton(function: {viewModel.getRecipes(); selectedCuisine = nil})
                }
                .disabled(viewModel.isShowingDetail)
            }.task{
                viewModel.getRecipes()
            }
            .blur(radius: viewModel.isShowingDetail ? 20 : 0)
            
            if viewModel.isLoading {
                LoadingView()
            }
            
            if viewModel.isShowingDetail {
                RecipeDetailView(recipe: viewModel.selectedRecipe!, isShowing: $viewModel.isShowingDetail)
            }
            
            if (viewModel.isAPIError != nil) {
                ErrorRecipeView(title: viewModel.isAPIError?.localizedDescription ?? "Unknown Error" )
            }
        }
    }
    
    @ViewBuilder
    private func filterButton() -> some View {
        Menu  {
            Button("All", action: { selectedCuisine = nil })
            ForEach(Array(Set(viewModel.recipes.map { $0.cuisine })).sorted(), id: \.self) { cuisine in
                Button(cuisine) {
                    selectedCuisine = cuisine
                }
            }
        } label: {
            VStack {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .tint(.primaryBrand)
                Text("Filter Cuisine")
                    .font(.caption2)
                    .fontWeight(.light)
                    .tint(.primary.opacity(0.7))
            }
        }
    }
}

#Preview {
    RecipeListView()
        .environmentObject(RecipeListViewModel())
}
