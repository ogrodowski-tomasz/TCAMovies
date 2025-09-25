import ComposableArchitecture
import Foundation

@Reducer
struct MovieListReducer {
    
    @ObservableState
    struct State: Equatable {
        var nowPlaying: [SingleMovieModel]
        var popular: [SingleMovieModel]
        var topRated: [SingleMovieModel]
        
        @Presents var movieDetails: MovieDetailsReducer.State? = nil
        
        init(
            nowPlaying: [SingleMovieModel] = [],
            popular: [SingleMovieModel] = [],
            topRated: [SingleMovieModel] = []
        ) {
            self.nowPlaying = nowPlaying
            self.popular = popular
            self.topRated = topRated
        }
    }
    
    
    enum Action: Equatable {
        case onAppear
        case nowPlayingFetched([SingleMovieModel])
        case popularFetched([SingleMovieModel])
        case topRatedFetched([SingleMovieModel])
        
        case movieDetails(PresentationAction<MovieDetailsReducer.Action>)
        case navigateToDetails(SingleMovieModel)
    }
    
    enum CancelId: Hashable {
        case fetchMovies
    }
    
    @Dependency(\.httpClient) private var httpClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .run { send in
                        let result = try await httpClient.load(MovieEndpoint.nowPlaying, decodeToType: MovieListResponse.self)
                        await send(.nowPlayingFetched(result.results))
                    },
                    .run { send in
                        do {
                            let result = try await httpClient.load(MovieEndpoint.popular, decodeToType: MovieListResponse.self)
                            await send(.popularFetched(result.results))
                        } catch {
                            print("DEBUG: errro \(error)")
                        }
                    },
                    .run { send in
                        let result = try await httpClient.load(MovieEndpoint.topRated, decodeToType: MovieListResponse.self)
                        await send(.topRatedFetched(result.results))
                    }
                )
                .cancellable(id: CancelId.fetchMovies)
                
            case .nowPlayingFetched(let movies):
                state.nowPlaying = Array(movies.prefix(5))
                return .none
            case .popularFetched(let movies):
                state.popular = Array(movies.prefix(5))
                return .none
            case .topRatedFetched(let movies):
                state.topRated = Array(movies.prefix(5))
                return .none
            case .movieDetails(.dismiss):
                return .none
            case .movieDetails:
                return .none
            case .navigateToDetails(let selectedMovie):
                state.movieDetails = .init(movie: selectedMovie)
                return .none
            }
        }
        .ifLet(\.$movieDetails, action: \.movieDetails, destination: MovieDetailsReducer.init)
    }
}
