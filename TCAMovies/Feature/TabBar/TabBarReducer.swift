import ComposableArchitecture
import Foundation

@Reducer
struct TabBarReducer {
    
    @ObservableState
    struct State: Equatable {
        var movieList = MovieListReducer.State()
        var favoriteList = FavoriteListReducer.State()
    }
    
    enum Action: Equatable {
        case movieList(MovieListReducer.Action)
        case favoriteList(FavoriteListReducer.Action)
    }
    
    enum CancelId: Hashable {
        
    }
    
    @Dependency(\.httpClient) private var httpClient
    
    var body: some ReducerOf<Self> {
        Scope(state: \.movieList, action: \.movieList, child: MovieListReducer.init)
        Scope(state: \.favoriteList, action: \.favoriteList, child: FavoriteListReducer.init)
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
