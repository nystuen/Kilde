import SwiftUI

enum ArticleDisplayMode: String, CaseIterable, Identifiable {
    case big = "Big"
    case normal = "Normal"
    case compact = "Compact"
    
    var id: String { self.rawValue }
    
}

enum ListDisplayMode: String, CaseIterable, Identifiable {
    case sections = "Sections"
    case normal = "Normal"
    var id: String { self.rawValue }
}

struct DisplaySettingsView: View {
    @Binding var articleMode: ArticleDisplayMode
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Text("Article Display mode")
                    .font(.headline)
                
                Picker(selection: $articleMode, label: Text("")) {
                    ForEach(ArticleDisplayMode.allCases) { mode in
                        Text(LocalizedStringKey(mode.rawValue)).tag(mode)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .pickerStyle(.automatic)
                
                Text("Selected sources")
                    .font(.headline)
                SourcesView()
            }
            .foregroundColor(.theme.text)
            .padding()
        }
    }
}

struct ADisplaySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DisplaySettingsView(articleMode: .constant(.compact))
        //ArticleDisplayModePickerView(articleMode: .constant(.compact), listMode: .constant(.sections))
    }
}

/*
 
 
 struct ArticleDisplayModePickerView: View {
     @Binding var articleMode: ArticleDisplayMode
     @Binding var listMode: ListDisplayMode
     
     var body: some View {
         ZStack {
             Color.theme.background
                 .ignoresSafeArea()
             VStack(alignment: .leading, spacing: 16) {
                 Text("Article Display mode")
                     .font(.headline)
                 
                 Picker(selection: $articleMode, label: Text("")) {
                     ForEach(ArticleDisplayMode.allCases) { mode in
                         Text(LocalizedStringKey(mode.rawValue)).tag(mode)
                     }
                 }
                 .pickerStyle(SegmentedPickerStyle())
                 .pickerStyle(.automatic)
                 
                 Text("List Display Mode")
                     .font(.headline)
                 
                 Picker(selection: $listMode, label: Text("")) {
                     ForEach(ListDisplayMode.allCases) { mode in
                         Text(LocalizedStringKey(mode.rawValue)).tag(mode)
                     }
                 }
                 .pickerStyle(SegmentedPickerStyle())
                 
                 Text("Selected sources")
                     .font(.headline)
                 SourcesView()
             }
             .foregroundColor(.theme.text)
             .padding()
         }
     }
 }

 
 */
