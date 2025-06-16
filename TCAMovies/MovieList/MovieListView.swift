import ComposableArchitecture
import SwiftUI

struct MovieListView: View {
    var store: StoreOf<MovieListReducer>
    
    var body: some View {
        List {
            Section("Popular") {
                ForEach(store.popular) { movie in
                    Text(movie.title)
                }
            }
            Section("Upcoming") {
                ForEach(store.upcoming) { movie in
                    Text(movie.title)
                }
            }
            Section("Top rated") {
                ForEach(store.topRated) { movie in
                    Text(movie.title)
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    MovieListView(store: Store(initialState: MovieListReducer.State(), reducer: {
        MovieListReducer()
    }))
}
