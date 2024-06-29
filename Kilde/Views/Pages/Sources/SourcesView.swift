import SwiftUI

struct SourcesView: View {
    @StateObject private var vm = SettingsViewModel()
    
    var body: some View {
        ZStack {
            switch vm.state {
            case .loading:
                ZStack {
                    Color.theme.background
                        .ignoresSafeArea()
                    ProgressView()
                }
            case .failed(let error):
                ErrorView(error: error) {
                    self.vm.loadSelectedSources()
                }
            case .success:
                sourcesView
            }
        }
        .navigationTitle("Selected sources")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.loadSelectedSources()
        }
    }
}

extension SourcesView {
    var sourcesView: some View {
        ScrollView {
            VStack(spacing: 8) {
                if let sources = vm.availableSources {
                    ForEach(sources) { source in
                        settingsToggleButton(title: source.name, icon: "", isOn: Binding(
                            get: { vm.selectedSources.contains(source) },
                            set: { isSelected in
                                vm.updateSource(source: source, enabled: isSelected)
                            }
                        ))
                    }
                }
                Spacer()
            }
            .padding()
        }
        .background(Color.theme.background)
    }
    /*
     
     Sources with editing order
     
     var sourcesView: some View {
         
         List {
             if let sources = vm.availableSources {
                 ForEach(sources) { source in
                     
                     
                     settingsToggleButton(title: source.name, icon: "", divider: false, isOn: Binding(
                         get: { vm.selectedSources.contains(source) },
                         set: { isSelected in
                             vm.updateSource(source: source, enabled: isSelected)
                         }
                     ))
                     
                 }
                 .onMove {
                     self.vm.availableSources?.move(fromOffsets: $0, toOffset: $1)
                     self.vm.selectedSources.move(fromOffsets: $0, toOffset: $1)

                 }
             }
             //Spacer()
         }
         .toolbarRole(.editor)
         .toolbar {
             // 1
             EditButton()
         }
         //.listStyle(.plain)
         .background(Color.theme.background)
         .padding()
     }
     
     */
    
    func settingsToggleButton(title: String, icon: String, divider: Bool = true, isOn: Binding<Bool>) -> some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .scaledToFill()
                Toggle(isOn: isOn) {
                    Text(title)
                }
                .toggleStyle(SwitchToggleStyle(tint: .theme.accent))
            }
            if divider {
                Divider()
            }
        }
        .foregroundColor(.theme.text)
        
    }
}

struct SourcesView_Previews: PreviewProvider {
    static var previews: some View {
        SourcesView()
    }
}
