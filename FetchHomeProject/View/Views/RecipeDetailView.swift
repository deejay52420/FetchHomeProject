
import SwiftUI

struct RecipeDetailView: View {
    
    let recipe: Recipe
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            RecipeRemoteImage(urlString: recipe.photoURLLarge)
                .frame(width: 300, height: 225)
            VStack {
                Text(recipe.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(recipe.cuisine)
                    .multilineTextAlignment(.center)
                    .font(.body)
                
            }
            Spacer()
            VStack (spacing: 10) {
                
                RButton(title: "YouTube", url: recipe.youtubeURL, bgColor: .youTubeRed)
            
                RButton(title: "Source", url: recipe.sourceURL, bgColor: .primaryBrand)
                        
            }
            .padding(.bottom, 30)
        }
        .frame(width: 300, height: 450)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 40)
        .overlay( Button {
            self.isShowing = false
        } label: {
            XDismissButton()
        }, alignment: .topTrailing)
    }
}

#Preview {
    RecipeDetailView(recipe: MockData.sampleRecipe, isShowing: .constant(true))
}
