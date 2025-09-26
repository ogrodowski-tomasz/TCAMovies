import ComposableArchitecture
import Foundation

@Reducer
struct FavoriteListReducer {
    
    @ObservableState
    struct State: Equatable {
        var favorites: [FavoriteMovie] = []
        
        @Presents var movieDetails: MovieDetailsReducer.State? = nil
    }
    
    
    enum Action: Equatable {
        case chceckDatabase
        case favoritesFetched([FavoriteMovie])
        
        case movieDetails(PresentationAction<MovieDetailsReducer.Action>)
        case navigateToDetails(FavoriteMovie)

    }
    
    enum CancelId: Hashable {
        
    }
    
    @Dependency(\.httpClient) private var httpClient
    @Dependency(\.favoriteRepository) private var favoriteRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .chceckDatabase:
                return .run { send in
                    let results = try await favoriteRepository.fetchAll()
                    await send(.favoritesFetched(results))
                }
            case .favoritesFetched(let fetchedFavorites):
                state.favorites = fetchedFavorites
                return .none
                
            case .navigateToDetails(let selectedFavorite):
                state.movieDetails = .init(movieId: selectedFavorite.movieId)
                return .none
            case .movieDetails:
                return .none
            }
        }
        .ifLet(\.$movieDetails, action: \.movieDetails, destination: MovieDetailsReducer.init)
    }
}
