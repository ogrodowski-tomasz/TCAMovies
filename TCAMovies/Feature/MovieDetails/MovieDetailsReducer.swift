import ComposableArchitecture
import Foundation

@Reducer
struct MovieDetailsReducer {
    
    @ObservableState
    struct State: Equatable {
        let movieId: Int
        var favoriteMovie: FavoriteMovie? = nil
        
        init(movieId: Int) {
            self.movieId = movieId
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
    @Dependency(\.date.now) private var now
    @Dependency(\.favoriteRepository) private var favoriteRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .checkDatabase:
                let id = state.movieId
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
                        let dtoModel = state.movieId
//                        let newFavorite = FavoriteMovie(dtoModel: dtoModel, dateCreated: self.now)
                        let newFavorite = FavoriteMovie(movieId: dtoModel, title: "Stub Title", posterPath: "stub", releaseDate: "stub", voteAverage: 1, dateCreated: self.now)
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
