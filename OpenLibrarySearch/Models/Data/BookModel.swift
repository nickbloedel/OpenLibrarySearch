import Foundation
import SwiftData

@Model
final class BookModel: Identifiable {
    @Attribute(.unique) var id: String
    var title: String
    var author: String?
    var year: Int?
    var isbn: String?
    var coverArtID: Int?
    var subject: String?
    
    init(id: String, title: String, author: String?, year: Int?, isbn: String?, coverArtID: Int?, subject: String?) {
        self.id = id
        self.title = title
        self.author = author
        self.year = year
        self.isbn = isbn
        self.coverArtID = coverArtID
        self.subject = subject
    }
}
