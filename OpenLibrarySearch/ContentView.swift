import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Search", systemImage: "book") {
                BookSearchView()
            }
            Tab("Reading List", systemImage: "heart"){
                ReadingListView()
            }
        }
    }
}

#Preview {
    ContentView()
}
