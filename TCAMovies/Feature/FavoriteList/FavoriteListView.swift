import ComposableArchitecture
import SwiftUI

struct FavoriteListView: View {
    let store: StoreOf<FavoriteListReducer>
    var body: some View {
        List {
            if store.favorites.isEmpty {
                Text("NO favorites")
            } else {
                ForEach(store.favorites) { movie in
                    Text(movie.title)
                }
            }
        }
        .onAppear {
            store.send(.chceckDatabase)
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
