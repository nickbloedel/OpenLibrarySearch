//
//  BookRowView.swift
//  MyApp
//
//  Created by Nicholas Bloedel on 10/19/26.
//

import SwiftUI

struct BookRowView: View {
    var book: Book
    var body: some View {
        HStack {
            AsyncImage(url: book.coverURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                default:
                    Image(systemName: "book.closed")
                        .padding()
                }
            }
            .frame(width: 64, height: 64)
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.callout)
                    .fontWeight(.bold)
                Text(book.author ?? "Unknown Author")
                    .font(.callout)
                    .lineLimit(1)
                if let year = book.year {
                    Text(String(year))
                        .font(.caption)
                }
                Text(book.isbn ?? "")
                    .font(.caption)
            }
            Spacer()
        }
    }
}

#Preview {
    BookRowView(book: Book.preview)
}
