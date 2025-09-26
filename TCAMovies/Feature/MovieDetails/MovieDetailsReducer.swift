import ComposableArchitecture
import Foundation

@Reducer
struct MovieDetailsReducer {
    
    @ObservableState
    struct State: Equatable {
        let movieId: Int
        var favoriteMovie: FavoriteMovie? = nil
        var movieDetails: MovieDetailsApiModel? = nil
        
        init(movieId: Int) {
            self.movieId = movieId
        }
        
        var isFavorite: Bool {
            favoriteMovie != nil
        }
        
        var favoriteButtonTitle: String {
            isFavorite ? "Remove from Favorites" : "Add to Favorites"
        }
        
        var favoriteButtonImageName: String {
            isFavorite ? "heart.fill" : "heart"
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case checkDatabase
        case favoriteFetched(FavoriteMovie?)
        case favoritesButtonTapped
        case detailsFetched(MovieDetailsApiModel)
    }
    
    enum CancelId: Hashable {
        
    }
    
    @Dependency(\.httpClient) private var httpClient
    @Dependency(\.date.now) private var now
    @Dependency(\.favoriteRepository) private var favoriteRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .run { send in
                        await send(.checkDatabase)
                    },
                    .run { [state] send in
                        guard state.movieDetails == nil else {
                            return
                        }
                        let id = state.movieId
                        let result = try await httpClient.load(MovieEndpoint.movieDetails(id: id), keyDecodingStrategy: .convertFromSnakeCase, decodeToType: MovieDetailsApiModel.self)
                        await send(.detailsFetched(result))
                    }
                )
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
                        guard let movieDetails = state.movieDetails else { return }
                        let newFavorite = FavoriteMovie(dtoModel: movieDetails, dateCreated: self.now)
                        try await favoriteRepository.add(newFavorite)
                        await send(.checkDatabase)
                    }
                }
            case .favoriteFetched(let favorite):
                state.favoriteMovie = favorite
                return .none
            case .detailsFetched(let detailsModel):
                state.movieDetails = detailsModel
                return .none
            }
        }
    }
}
