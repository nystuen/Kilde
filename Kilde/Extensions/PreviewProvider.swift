import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    static var dummyArticle_old = Article_old(
        headline: "\(Int.random(in: 1...50))Tragic boating accident claims two boats in Helgeland",
        date: "Aug 22",
        readTime: "5",
        location: "Helgeland, Norway",
        author: "ChatGPT News",
        authorUrl: "www.vg.no",
        imageUrl: "https://akamai.vgc.no/v2/images/020de4f5-d3f5-414e-8edb-c2aebdf5697c?fit=crop&format=auto&h=667&w=1000&s=7cb89ffea625938820b884240852c4a69ea1a780",
        article: """
        In a devastating turn of events, a boating accident off the coast of Helgeland, Norway has led to the tragic loss of two boats
        The incident occurred on the morning of August 26, 2023, sending shockwaves through the local community and beyond. They were on a recreational boating trip when the accident took place.
        """)
    
    static var dummyArticle = Article(headline: "\(Int.random(in: 1...50))Tragic Boating Accident Claims Lives of Two Youths in Helgeland", article: "In a devastating turn of events, a boating accident off the coast of Helgeland, Norway has led to the tragic loss of two young lives.", date: Date(), author: "ChatGPT News", imageUrl: "https://akamai.vgc.no/v2/images/020de4f5-d3f5-414e-8edb-c2aebdf5697c?fit=crop&format=auto&h=667&w=1000&s=7cb89ffea625938820b884240852c4a69ea1a780", authorUrl: "www.vg.no")

    static var dummyArticles: [Article] = Array.init(repeating: dummyArticle, count: 10)
    
    static var dummyArticleSections: [ArticleSection] = [
        ArticleSection(title: "VG", articles: [], isHidden: false),
        ArticleSection(title: "E24", articles: [], isHidden: false),
        ArticleSection(title: "TEK.NO", articles: [], isHidden: false),
        ArticleSection(title: "Finansavisen", articles: [], isHidden: false),
        ArticleSection(title: "Dagbladet", articles: [], isHidden: false),
    ]
}

