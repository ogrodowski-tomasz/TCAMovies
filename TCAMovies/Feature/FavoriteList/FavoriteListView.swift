import ComposableArchitecture
import SwiftUI

struct FavoriteListView: View {
    @Bindable var store: StoreOf<FavoriteListReducer>
    var body: some View {
        NavigationStack {
            List {
                if store.favorites.isEmpty {
                    Text("NO favorites")
                } else {
                    ForEach(store.favorites) { movie in
                        MovieRowView(movie: movie) { selectedMovie in
                            store.send(.navigateToDetails(movie))
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        
                    }
                }
            }
            .navigationTitle("Favorites")
            .listStyle(.plain)
            .onAppear {
                store.send(.chceckDatabase)
            }
            .navigationDestination(item: $store.scope(state: \.movieDetails, action: \.movieDetails)) { store in
                MovieDetailsScreen(store: store)
            }
        }
    }
}

#Preview {
    FavoriteListView(store: Store(
        initialState: FavoriteListReducer.State(),
        reducer: {
            FavoriteListReducer()
        }
    ))
}
