//
//  BookSearchView.swift
//  MyApp
//
//  Created by Nicholas Bloedel on 10/19/26.
//

import SwiftUI

struct BookSearchView: View {
    @State var bookList: [Book] = []
    @State var searchText: String = ""
    @State var selectedBook: Book? = nil
    @State var isSearching: Bool = false
    private let bookService: BookService
    
    init(bookService: BookService = BookService()) {
        self.bookService = bookService
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(bookList) { book in
                    NavigationLink(value: book) {
                        BookRowView(book: book)
                    }
                }
            }
            .navigationDestination(for: Book.self) { book in
                RecommendationView(book: book)
            }
            .navigationDestination(item: $selectedBook) { book in
                RecommendationView(book: book)
            }
            .navigationTitle("Search for Books")
            .overlay {
                if bookList.isEmpty && !searchText.isEmpty && !isSearching {
                    ContentUnavailableView.search
                }
                if isSearching {
                    ProgressView()
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Enter the title of a book you enjoyed...")
        }
        .task(id: searchText) {
            guard !searchText.isEmpty else {
                bookList = []
                return
            }
            do {
                // debounce search
                isSearching = true
                try await Task.sleep(for: .milliseconds(400))
                try Task.checkCancellation()
                defer { isSearching = false }
                let books = try await bookService.fetchBooksByTitle(searchText)
                if books.count == 1 {
                    // navigate directly to RecommendationView for the single result
                    if let only = books.first {
                        self.selectedBook = only
                    }
                }
                bookList = books
            } catch is CancellationError {
                // do nothing
            } catch {
                self.bookList = []
                print("Search error: \(error)")
            }
        }
    }
}

#Preview {
    BookSearchView()
}

