import ComposableArchitecture
import Foundation

@Reducer
struct FavoriteListReducer {
    
    @ObservableState
    struct State: Equatable {
        var favorites: [FavoriteMovie] = []
    }
    
    
    enum Action: Equatable {
        case chceckDatabase
        case favoritesFetched([FavoriteMovie])
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
            }
        }
    }
}
