import Foundation
import SwiftData

@Model
final class FavoriteMovie {

    @Attribute(.unique) var movieId: Int
    var title: String = "Unknown"
    var posterPath: String? = nil
    var releaseDate: String? = nil
    var voteAverage: Double? = nil
    var dateCreated: Date

    init(movieId: Int, title: String = "Unknown", posterPath: String? = nil, releaseDate: String? = nil, voteAverage: Double? = nil, dateCreated: Date) {
        self.movieId = movieId
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.dateCreated = dateCreated
    }
    
    init(dtoModel: SingleMovieModel, dateCreated: Date) {
        self.movieId = dtoModel.id
        self.title = dtoModel.title
        self.posterPath = dtoModel.posterPath
        self.releaseDate = dtoModel.releaseDate
        self.voteAverage = dtoModel.voteAverage
        self.dateCreated = dateCreated
    }
}
