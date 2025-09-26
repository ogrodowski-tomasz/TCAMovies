import ComposableArchitecture
import SwiftUI

struct MovieDetailsView: View {
    let store: StoreOf<MovieDetailsReducer>
    var body: some View {
        VStack {
            Text("Details for movieId \(store.movieId)")
            
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
        .onAppear {
            store.send(.checkDatabase)
        }
    }
}

#Preview {
    MovieDetailsView(store: Store(initialState: MovieDetailsReducer.State(movieId: SingleMovieModel.stub.id), reducer: MovieDetailsReducer.init))
}
