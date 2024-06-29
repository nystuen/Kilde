//
//  ScrollViewWithFAB.swift
//  Kilde
//
//  Created by Ådne Nystuen on 17/09/2023.
//

import SwiftUI

struct ScrollViewWithFAB<Content : View>: View {
    
    @State var scrollViewOffset: CGFloat = 0
    @State var startOffset: CGFloat = 0
    
    let content: Content
    
    init(@ViewBuilder contentBuilder: () -> Content){
        self.content = contentBuilder()
    }
    
    var body: some View {
        ScrollViewReader { proxyReader in
            ScrollView {
                content
                    .id("SCROLL_TO_TOP")
                    .overlay (
                        GeometryReader { proxy -> Color in
                            DispatchQueue.main.async {
                                scrollViewOffset = proxy.frame(in: .global).minY
                            }
                            return Color.clear
                        }
                            .frame(width: 0, height: 0)
                        , alignment: .top)
            }
            
            .overlay(
                Button {
                    withAnimation(.spring()) {
                        proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                    }
                    
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.theme.accent)
                            .frame(width: 55)
                        Image(systemName: "chevron.up")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    .opacity(0.75)
                }
                    .padding()
                    .padding(.bottom, getSafeArea().bottom == 0 ? 12 : 0)
                    .opacity(-scrollViewOffset > 450 ? 1 : 0)
                    .animation(.easeInOut)
                , alignment: .bottomTrailing)
        }
    }
}

struct ScrollViewWithFAB_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewWithFAB {
            Text("Conent")
            Text("Conent")
            Text("Conent")
            Text("Conent")
        }
    }
}
