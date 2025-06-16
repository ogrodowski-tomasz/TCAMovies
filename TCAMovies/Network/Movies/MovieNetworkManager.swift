import Dependencies
import Foundation

struct MovieNetworkManager {
    var loadTopRated: @Sendable () async throws -> MovieApiResponseModel
    var loadPopular: @Sendable () async throws -> MovieApiResponseModel
    var loadUpcoming: @Sendable () async throws -> MovieApiResponseModel
}

extension MovieNetworkManager: DependencyKey {
    static var liveValue: Self {
        return MovieNetworkManager(
            loadTopRated: {
                guard let url = MovieEndpoint.topRated.url else {
                    throw NetworkError.badRequest
                }
                let resource = Resource(url: url, modelType: MovieApiResponseModel.self)
                return try await HTTPClient.shared.load(resource)
            }, loadPopular: {
                guard let url = MovieEndpoint.popular.url else {
                    throw NetworkError.badRequest
                }
                let resource = Resource(url: url, modelType: MovieApiResponseModel.self)
                return try await HTTPClient.shared.load(resource)
            }, loadUpcoming: {
                guard let url = MovieEndpoint.nowPlaying.url else {
                    throw NetworkError.badRequest
                }
                let resource = Resource(url: url, modelType: MovieApiResponseModel.self)
                return try await HTTPClient.shared.load(resource)
            }
        )
    }
}

extension MovieNetworkManager: TestDependencyKey {
    static var testValue = Self(
        loadTopRated: unimplemented("\(Self.self).loadTopRated"),
        loadPopular: unimplemented("\(Self.self).loadPopular"),
        loadUpcoming: unimplemented("\(Self.self).loadUpcoming")
    )
}

extension DependencyValues {
    var movieNetworkManager: MovieNetworkManager {
        get {
            self[MovieNetworkManager.self]
        } set {
            self[MovieNetworkManager.self] = newValue
        }
    }
}
