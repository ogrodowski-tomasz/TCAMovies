import ComposableArchitecture
import Foundation

@Reducer
struct MovieDetailsReducer {
    
    @ObservableState
    struct State: Equatable {
        let movie: SingleMovieModel
        var favoriteMovie: FavoriteMovie? = nil
        
        init(movie: SingleMovieModel) {
            self.movie = movie
        }
        
        var isFavorite: Bool {
            favoriteMovie != nil
        }
    }
    
    enum Action: Equatable {
        case checkDatabase
        case favoriteFetched(FavoriteMovie?)
        case favoritesButtonTapped
    }
    
    enum CancelId: Hashable {
        
    }
    
    @Dependency(\.httpClient) private var httpClient
    @Dependency(\.favoriteRepository) private var favoriteRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .checkDatabase:
                let id = state.movie.id
                return .run { send in
                    let favoriteModel = try await favoriteRepository.fetchById(id)
                    await send(.favoriteFetched(favoriteModel))
                }
            case .favoritesButtonTapped:
                return .run { [state] send in
                    if let alreadyExistingFavorite = state.favoriteMovie {
                        try await favoriteRepository.delete(alreadyExistingFavorite)
                        await send(.checkDatabase)
                    } else {
                        let dtoModel = state.movie
                        let newFavorite = FavoriteMovie(dtoModel: dtoModel)
                        try await favoriteRepository.add(newFavorite)
                        await send(.checkDatabase)
                    }
                }
            case .favoriteFetched(let favorite):
                state.favoriteMovie = favorite
                return .none
            }
        }
    }
}
