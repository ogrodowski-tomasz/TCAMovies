import Foundation

struct MovieListResponse: Codable {
    let page: Int
    let results: [SingleMovieModel]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct SingleMovieModel: Codable, Identifiable, Equatable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension SingleMovieModel {
    enum ImageType {
        case poster
        case backdrop
    }
    
    func imageURL(for type: ImageType) -> URL? {
        switch type {
        case .poster:
            return URL(imagePath: self.posterPath)
        case .backdrop:
            return URL(imagePath: self.backdropPath)
        }
    }
}

extension SingleMovieModel {
    
    static let stub: SingleMovieModel = .init(
        adult: false,
        backdropPath: "/2siOHQYDG7gCQB6g69g2pTZiSia.jpg",
        genreIDS: [
            10751,
            14
          ],
        id: 447273,
        originalTitle: "Snow White",
        overview: "A princess joins forces with seven dwarfs to liberate her kingdom from her cruel stepmother, the Evil Queen.",
        popularity: 30.454,
        posterPath: "/xWWg47tTfparvjK0WJNX4xL8lW2.jpg",
        releaseDate: "2025-03-19",
        title: "Snow White",
        video: false,
        voteAverage: 4.5,
        voteCount: 112
    )
        
}

extension SingleMovieModel: MovieListItemRepresentable { }
