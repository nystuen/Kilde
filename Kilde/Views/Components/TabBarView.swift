//
//  TabBarView.swift
//  Timetable
//
//  Created by Archie Liu on 2021-05-15.
//

import SwiftUI

struct TabBarView: View {
    @Binding var index: Int
    @Binding var sections: [ArticleSection]
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    ForEach(sections.indices,  id: \.self) { id in
                        let title = Text(sections[id].title).id(id)
                            .onTapGesture {
                                withAnimation() {
                                    index = id
                                }
                            }
                        if self.index == id {
                            title.foregroundColor(.theme.text)
                        } else {
                            title.foregroundColor(.theme.secondaryText)
                        }
                    }
                    .font(.title3)
                    .padding(.horizontal, 5)
                }
                .padding(.leading, 20)
            }.onChange(of: index) { value in
                withAnimation() {
                    proxy.scrollTo(value, anchor: UnitPoint(x: UnitPoint.leading.x + leftOffset, y: UnitPoint.leading.y))
                }
            }.animation(.easeInOut)
        }
    }
    private let leftOffset: CGFloat = 0.1
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(index: .constant(1), sections: .constant(DeveloperPreview.dummyArticleSections))
    }
}
