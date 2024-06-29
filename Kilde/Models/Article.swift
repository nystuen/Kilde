import Foundation

struct Article_old: Codable, Hashable {
    let headline: String
    let date: String
    let readTime: String
    let location: String
    let author: String
    let authorUrl: String
    let imageUrl: String
    let article: String
}

struct Article: Codable, Hashable {
    let headline: String
    let article: String
    var date: Date // Change the data type to Date
    let author: String
    let imageUrl: String
    let authorUrl: String
    let forceWebView: Bool
    var seen: Bool = false
    
    
    enum CodingKeys: String, CodingKey {
        case headline = "title"
        case article = "description"
        case date = "lastUpdated"
        case author = "source"
        case imageUrl = "imageLink"
        case authorUrl = "link"
    }
    
    var authorPrettified: String {
        author.uppercased()
    }
    
    init(headline: String, article: String, date: Date, author: String, imageUrl: String, authorUrl: String) {
        self.headline = headline
        self.article = article
        self.date = date
        self.author = author
        self.imageUrl = imageUrl
        self.authorUrl = authorUrl
        self.forceWebView = article == "Klikk på linken for å lese mer"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let dateString = try container.decodeIfPresent(String.self, forKey: .date) {
            date = ISO8601DateFormatter().date(from: dateString) ?? Date.distantPast
        } else {
            throw DecodingError.keyNotFound(CodingKeys.date, DecodingError.Context(codingPath: [CodingKeys.date], debugDescription: "Date not found"))
        }
        
        headline = try container.decode(String.self, forKey: .headline)
            .replacingOccurrences(of: "\r\n", with: " ")
            .replacingOccurrences(of: "\r", with: " ")
            .replacingOccurrences(of: "\n", with: " ")
        article = try container.decode(String.self, forKey: .article)
        author = try container.decode(String.self, forKey: .author)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        authorUrl = try container.decode(String.self, forKey: .authorUrl)
        forceWebView = article == "Klikk på linken for å lese mer"
    }
    
    var datePrettified: String {
        if date.isToday() {
            return "I dag, \(date.asTime())"
        } else if date.isYesterday() {
            return "I går, \(date.asTime())"
        }
        return date.asMMMddhhmmString().capitalized
    }
}
