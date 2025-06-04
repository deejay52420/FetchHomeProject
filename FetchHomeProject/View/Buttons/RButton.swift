
import SwiftUI

struct RButton: View {
    let title: String
    let url : String?
    let bgColor: Color
    
    var body: some View {
        let isDisabled: Bool = url == nil || url!.isEmpty
           
        Button {
                if let url, !url.isEmpty {
                    if let openURL = URL(string: url) {
                        UIApplication.shared.open(openURL)
                    }
                }
            } label: {
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 260, height: 50)
                    .background(bgColor)
                    .cornerRadius(10)
            }
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.5 : 1)
    }
}

#Preview {
    RButton(title: "Test Title", url: "", bgColor: Color.red)
}
