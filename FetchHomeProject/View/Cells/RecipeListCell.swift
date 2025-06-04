
import SwiftUI

struct RecipeListCell: View {
    
    let recipe: Recipe
    
    var body: some View {
        HStack {
            RecipeRemoteImage(urlString: recipe.photoURLSmall)
                .frame(width: 120, height: 90)
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .font(.title2)
                    .fontWeight(.medium)
                Text(recipe.cuisine)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
            }.padding(.leading)
        }
    }
}

#Preview {
    RecipeListCell(recipe: MockData.sampleRecipe)
}
