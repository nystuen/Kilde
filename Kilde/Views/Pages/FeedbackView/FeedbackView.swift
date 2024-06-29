import SwiftUI

struct FeedbackView: View {
    @ObservedObject var vm: FeedbackViewModel = FeedbackViewModel()
    var articleId: String? = nil
    @Environment(\.dismiss) var dismiss
    @FocusState private var textEditorIsFocused: Bool
    
    var body: some View {
        VStack {
            KildeTextEditor(title: textEditorTitle, text: $vm.feedbackModel.feedbackText)
                .frame(maxHeight: 300)
                .focused($textEditorIsFocused)
            Spacer()
            KildeButtonView(text: "Submit", color: .theme.accent) {
                vm.submitFeedback()
            }
        }
        .padding()
        .background(Color.theme.background)
        .foregroundColor(.theme.text)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.feedbackModel.articleId = articleId
            textEditorIsFocused = true
        }
        .alert(isPresented: $vm.feedbackSumitted) {
            Alert(
                title: Text("Takk!"),
                message: Text(alertMessage),
                dismissButton: .default(Text("Gå tilbake"), action: {
                    dismiss()
                })
            )
        }
    }
}

extension FeedbackView {
    var textEditorTitle: String {
        articleId == nil ? "Beskjed" : "Tilbakemelding"
    }
    
    var navigationTitle: String {
        articleId == nil ? "Beskjed" : "Tilbakemelding"
    }
    
    var alertMessage: String {
        articleId == nil ? "Din beskjed motatt, takk!" : "Tilbakemeldingen din er sendt inn, takk for at du bidrar!"
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
