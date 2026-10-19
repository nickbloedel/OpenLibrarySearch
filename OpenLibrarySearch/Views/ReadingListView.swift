//
//  ReadingListView.swift
//  MyApp
//
//  Created by Nicholas Bloedel on 10/18/26.
//

import SwiftData
import SwiftUI

struct ReadingListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BookModel.title) var savedBooks: [BookModel]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(savedBooks) { bookModel in
                    BookRowView(book: Book(id: bookModel.id, title: bookModel.title, author: bookModel.author, year: bookModel.year, isbn: bookModel.isbn, coverArtID: bookModel.coverArtID, subject: bookModel.subject))
                }
                .onDelete { indices in
                    for index in indices {
                        let book = savedBooks[index]
                        modelContext.delete(book)
                    }
                }
            }
            .overlay {
                if savedBooks.isEmpty {
                    ContentUnavailableView("No saved books yet.", systemImage: "book")
                }
            }
            .navigationTitle("Reading List")
        }
    }
}

#Preview {
    ReadingListView()
}
