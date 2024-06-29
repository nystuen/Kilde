import SwiftUI

class AdminViewModel: ObservableObject {
    // UserDefaults keys for the values you want to reset
    let userDefaultsKeys: [String] = UserDefaultsKeys.allCases.map { $0.key }
    // Function to reset UserDefaults values
    func resetUserDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func runJobsTapped() {
        HTTPService.shared.getWithoutResult(from: ArticleAPI.runJobs)
    }
}

struct AdminView: View {
    @ObservedObject var viewModel = AdminViewModel()
    @State var alertIsPresented = false

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Text("Reset userdefaults")
                        .font(.title2)
                        .foregroundColor(.theme.text)
                    ForEach(viewModel.userDefaultsKeys, id: \.self) { key in
                        KildeButtonView(text: "Reset \(key)", color: .theme.accent) {
                            viewModel.resetUserDefaults(key: key)
                            alertIsPresented = true
                        }
                    }
                    
                    KildeButtonView(text: "Run all jobs", color: .theme.accent) {
                        viewModel.runJobsTapped()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Admin settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $alertIsPresented) {
            Alert(title: Text("Done!"))
        }

    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView(viewModel: AdminViewModel())
    }
}
