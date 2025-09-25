import ComposableArchitecture
import Foundation

@Reducer
struct MovieDetailsReducer {
    
    @ObservableState
    struct State: Equatable {
        let movie: SingleMovieModel
        var isFavorite: Bool = false
        var favoriteMovie: FavoriteMovie? = nil
        
        init(movie: SingleMovieModel) {
            self.movie = movie
        }
    }
    
    enum Action: Equatable {
        case fetchFavoriteModel
        case favoritesButtonTapped
        case databaseChanged([FavoriteMovie])
    }
    
    enum CancelId: Hashable {
        
    }
    
    @Dependency(\.httpClient) private var httpClient
    @Dependency(\.favoriteRepository) private var favoriteRepository
    
    #warning("TODO: Implement")
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchFavoriteModel:
                return .none
            case .favoritesButtonTapped:
//                let fav = FavoriteMovie()
//                favoriteRepository.updateStatus(fav)
                return .none
            case .databaseChanged(let favorites):
                
                return .none
            }
        }
    }
}
