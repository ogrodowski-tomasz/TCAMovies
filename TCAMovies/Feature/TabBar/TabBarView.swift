import ComposableArchitecture
import SwiftUI

struct TabBarView: View {
    let store: StoreOf<TabBarReducer>
    var body: some View {
        TabView {
            Tab("Movies", systemImage: "camera") {
                MovieListView(
                    store: store.scope(
                        state: \.movieList,
                        action: \.movieList
                    )
                )
            }
            
            Tab("Favorites", systemImage: "heart.fill") {
                FavoriteListView(
                    store: store.scope(
                        state: \.favoriteList,
                        action: \.favoriteList
                    )
                )
            }
        }
    }
}

#Preview {
    TabBarView(store: Store(
        initialState: TabBarReducer.State(),
        reducer: {
            TabBarReducer()
        }
    ))
}
