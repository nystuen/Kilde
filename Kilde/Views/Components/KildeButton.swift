import SwiftUI

struct KildeButtonView: View {
    let text: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(LocalizedStringKey(text))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color.opacity(0.7))
                .cornerRadius(8)
        }
    }
}

struct KildeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        KildeButtonView(text: "Visit Website",  color: .theme.accent) {
            print("test")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
