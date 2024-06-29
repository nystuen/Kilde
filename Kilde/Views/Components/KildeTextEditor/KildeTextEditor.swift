import SwiftUI

struct KildeTextEditor: View {
    var title: String = ""
    var disabled: Bool = false
    @Binding var text: String
    var body: some View {
        VStack( alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                Text(LocalizedStringKey(title))
                    .fontWeight(.medium)
                    .opacity(0.6)
            }
            ZStack {
                Color.theme.secondaryText
                    .opacity(0.15)
                    .cornerRadius(10)
                HStack {
                    
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .cornerRadius(10)
                   
                    if !text.isEmpty {
                        Button {
                            text = ""
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .opacity(0.3)
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
        }
        .foregroundColor(.theme.text)
    }
}

struct KildeTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                KildeTextEditor(title: "TestTitle", text: .constant(""))
                    .frame(maxHeight: 500)
                Spacer()
            }
            .padding()
        }
    }
}

