
import SwiftUI

final class ImageLoader: ObservableObject {
    @Published var image: Image? = nil
    
    @MainActor
    func load(fromURL url: String?) async {
        do {
            guard let uiImage = try await NetworkManager.shared.downloadImage(fromURLString: url) else { return }
            self.image = Image(uiImage: uiImage)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

struct RemoteImage: View {
    var image: Image?
    
    var body: some View {
        image?.resizable() ?? Image("food-placeholder").resizable()
    }
}

struct RecipeRemoteImage: View {
    @StateObject private var imageLoader = ImageLoader()
    let urlString: String?
    
    var body: some View {
        RemoteImage(image: imageLoader.image)
            .onAppear{
                Task {
                    await imageLoader.load(fromURL: urlString)
                }
                
            }
    }
}
