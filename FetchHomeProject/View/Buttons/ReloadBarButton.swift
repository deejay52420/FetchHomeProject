
import SwiftUI

struct ReloadBarButton: View {
    var function: () -> Void
    @State var showAlert: Bool = false
    
    var body: some View {
        Button {
            self.function()
            showAlert = true
        } label: {
            VStack {
                Image(systemName: "arrow.clockwise")
                    .tint(.primaryBrand)
                Text("Reload")
                    .font(.caption2)
                    .fontWeight(.light)
                    .tint(.primary.opacity(0.7))
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Racipes Reloaded!"), message: Text("Your list is being updated"))
        }
    }
}
