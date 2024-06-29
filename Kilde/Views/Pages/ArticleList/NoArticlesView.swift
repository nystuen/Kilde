import SwiftUI

struct NoArticlesView: View {
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                Image(systemName: "newspaper.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                Text("Ingen artikler funnet.")
                    .font(.title)
                    .foregroundColor(.gray)
                
                Text("Vennligst dine Kilder  i Innstillinger.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
    }
}

struct NoArticlesView_Previews: PreviewProvider {
    static var previews: some View {
        NoArticlesView()
    }
}
