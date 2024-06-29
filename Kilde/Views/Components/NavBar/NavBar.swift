import SwiftUI

struct NavBar: View {
    var action: () -> Void
    
    var body: some View {
        HStack {
            ZStack {
                HStack {
                    Text("Kilde")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(.theme.text)
                    Spacer()
                    Button(action: {
                        action()
                    }) {
                        Image(systemName: "lines.measurement.horizontal")
                            .fontWeight(.medium)
                            .foregroundColor(.theme.text)
                    }
                }
                .padding(.horizontal)
            }
            //.padding()
        }
        .background(Color.theme.background)
    }
}


struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar(action: {})
    }
}
