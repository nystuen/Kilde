import SwiftUI

struct ScrollerToTop: View {
    let reader: ScrollViewProxy
    @Binding var scrollOnChange: Bool
    
    var body: some View {
        Text("").opacity(0)
            .frame(height: 0)
            .id("topScrollPoint")
            .onChange(of: scrollOnChange) { _ in
                withAnimation(.spring()) {
                    reader.scrollTo("topScrollPoint", anchor: .bottom)
                }
            }
    }
}

