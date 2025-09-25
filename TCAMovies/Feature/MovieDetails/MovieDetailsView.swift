import ComposableArchitecture
import SwiftUI

struct MovieDetailsView: View {
    let store: StoreOf<MovieDetailsReducer>
    var body: some View {
        VStack {
            Text("Details for movieId \(store.movie.id)")
            
            Button {
                store.send(.favoritesButtonTapped)
            } label: {
                HStack {
                    Image(systemName: store.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(.red)
                    Text(store.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                }
            }
        }
    }
}

#Preview {
    MovieDetailsView(store: Store(initialState: MovieDetailsReducer.State(movie: SingleMovieModel.stub), reducer: MovieDetailsReducer.init))
}
