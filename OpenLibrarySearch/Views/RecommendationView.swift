//
//  RecommendationView.swift
//  MyApp
//
//  Created by Nicholas Bloedel on 10/18/26.
//

import SwiftUI
import SwiftData

struct RecommendationView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var savedBooks: [BookModel]
    @State var isLoading: Bool = false
    private let bookService: BookService
    var book: Book
    
    @State var bookRecommendations: [Book] = []
    
    init(bookService: BookService = BookService(), book: Book) {
        self.book = book
        self.bookService = bookService
    }
    
    var body: some View {
        List {
            ForEach(bookRecommendations) { book in
                HStack {
                    BookRowView(book: book)
                    Button {
                        heartButtonPressed(book: book)
                    } label: {
                        Image(systemName: savedBooks.contains(where: { $0.id == book.id }) ? "heart.fill" : "heart")
                    }
                }
            }
        }
        .overlay {
            // Maybe only show if list is empty?
            if isLoading {
                ProgressView()
            }
            // ContentUnavailableView if none found
        }
        .navigationTitle("Recommendations")
        .task {
            // get recommended books
            isLoading = true
            defer { isLoading = false }
            bookRecommendations = await getRecommendations(book: book)
        }
    }

}

// Essentially MVVM funcs
extension RecommendationView {
    func heartButtonPressed(book: Book) {
        if let existing = savedBooks.first(where: { $0.id == book.id }) {
            modelContext.delete(existing)
        } else {
            modelContext.insert(BookModel(id: book.id, title: book.title, author: book.author, year: book.year, isbn: book.isbn, coverArtID: book.coverArtID, subject: book.subject))
        }
    }
    
    func getRecommendations(book: Book) async -> [Book] {
        var booksSet = Set<Book>()
        // Two API calls, we can just do them serially
        if let author = book.author {
            do {
                let authorBooks =  try await bookService.fetchBooksByAuthor(author)
                booksSet.formUnion(authorBooks)
            } catch {
                print("Failed to get books from author: \(author)")
            }
        }
        
        if let subject = book.subject {
            do {
                let subjectBooks = try await bookService.fetchBooksBySubject(subject)
                booksSet.formUnion(subjectBooks)
            } catch {
                print("Failed to get books for subject: \(subject)")
            }
        }
        return Array(booksSet)
    }
}

#Preview {
    RecommendationView(bookService: BookService(), book: .preview)
}
