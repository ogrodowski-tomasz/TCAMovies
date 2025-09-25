import Foundation

enum MovieEndpoint {
    case topRated
    case popular
    case nowPlaying
    case movieDetails(id: Int)
    case cast(movieId: Int)
    case collectionDetails(collectionID: Int)
}

extension MovieEndpoint: AppEndpoint {

    var scheme: String {
        "https"
    }

    var host: String {
        "api.themoviedb.org"
    }

    var baseURL: String {
        "https://api.themoviedb.org/3/"
    }

    var path: String {
        switch self {
        case .topRated:
            return "/3/movie/top_rated"
        case .popular:
            return "/3/movie/popular"
        case .nowPlaying:
            return "/3/movie/now_playing"
        case let .movieDetails(id):
            return "/3/movie/\(id)"
        case let .cast(movieId):
            return "/3/movie/\(movieId)/credits"
        case let .collectionDetails(collectionID):
            return "/3/collection/\(collectionID)"
        }
    }

    var stubDataFilename: String? {
        switch self {
        case .topRated:
            return "MovieTopRatedStubData"
        case .popular:
            return "MoviePopularStubData"
        case .nowPlaying:
            return "MovieNowPlayingStubData"
        case .movieDetails:
            return "MovieDetailsStubData"
        case .cast:
            return "CastStubData"
        case .collectionDetails:
            return "CollectionDetailsStubData"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .topRated:
            return .get([])
        case .popular:
            return .get([])
        case .nowPlaying:
            return .get([])
        case .movieDetails:
            return .get([])
        case .cast:
            return .get([])
        case .collectionDetails:
            return .get([])
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .topRated, .movieDetails, .popular, .nowPlaying:
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1"),
            ]
        case .cast, .collectionDetails:
            return nil
        }
    }

    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        // TODO: Add queryItems handling for page or lang
        // language=en-US&page=1
        if let queryItems {
            components.queryItems = queryItems
        }
        return components.url
    }
}
