import Foundation
import SwiftData

@Model
final class FavoriteMovie {

    @Attribute(.unique) var movieId: Int
    var title: String = "Unknown"
    var posterPath: String? = nil
    var releaseDate: String? = nil
    var voteAverage: Double? = nil

    init(movieId: Int, title: String = "Unknown", posterPath: String? = nil, releaseDate: String? = nil, voteAverage: Double? = nil) {
        self.movieId = movieId
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
    }
    
    init(dtoModel: SingleMovieModel) {
        self.movieId = dtoModel.id
        self.title = dtoModel.title
        self.posterPath = dtoModel.posterPath
        self.releaseDate = dtoModel.releaseDate
        self.voteAverage = dtoModel.voteAverage
    }
}
