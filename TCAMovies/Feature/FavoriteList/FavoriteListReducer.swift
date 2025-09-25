import ComposableArchitecture
import Foundation

@Reducer
struct FavoriteListReducer {
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    
    enum Action: Equatable {
        
    }
    
    enum CancelId: Hashable {
        
    }
    
    @Dependency(\.httpClient) private var httpClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                #warning("TODO: Implement movie details fetching and adding to favorites")
            }
        }
    }
}
