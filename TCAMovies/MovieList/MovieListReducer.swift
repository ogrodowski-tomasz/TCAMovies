import ComposableArchitecture
import Foundation

enum MovieSectionType {
    case topRated
    case upcoming
    case popular
}

@Reducer
struct MovieListReducer {
    
    @ObservableState
    struct State: Equatable {
        var topRated: [MovieApiModel] = []
        var upcoming: [MovieApiModel] = []
        var popular: [MovieApiModel] = []
        
        init(
            topRated: [MovieApiModel] = [],
            upcoming: [MovieApiModel] = [],
            popular: [MovieApiModel] = []
        ) {
            self.topRated = topRated
            self.upcoming = upcoming
            self.popular = popular
        }
    }
    
    @Dependency(\.movieNetworkManager) private var movieNetworkManager
    
    enum Action: Equatable {
        case onAppear
        case moviesReceived(movies: [MovieApiModel], type: MovieSectionType)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .run { send in
                        let topRated = try await self.movieNetworkManager.loadTopRated().results.prefix(5)
                        await send(.moviesReceived(movies: Array(topRated), type: .topRated))
                    },
                    .run { send in
                        let upcoming = try await self.movieNetworkManager.loadUpcoming().results.prefix(5)
                        await send(.moviesReceived(movies: Array(upcoming), type: .upcoming))
                    },
                    .run { send in
                        try await fetchPopular(send)
                    }
                )
            case let .moviesReceived(movies, type):
                switch type {
                case .popular:
                    state.popular = movies
                case .topRated:
                    state.topRated = movies
                case .upcoming:
                    state.upcoming = movies
                }
                return .none
            }
        }
    }
    
    func fetchPopular(_ send: Send<MovieListReducer.Action>) async throws {
        let popular = try await movieNetworkManager.loadPopular().results.prefix(5)
        await send(.moviesReceived(movies: Array(popular), type: .popular))
    }
}
