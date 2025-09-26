import Foundation

struct MovieDetailsApiModel: Codable, MovieListItemRepresentable, Equatable {
    let adult: Bool
    let backdropPath: String?
    let genres: [GenreApiModel]
    let id: Int
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String
    let runtime: Int?
    let tagline: String?
    let title: String
    let voteAverage: Double?
    let belongsToCollection: MovieCollectionApiModel?
}

struct GenreApiModel: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
}

struct MovieCollectionApiModel: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
}
