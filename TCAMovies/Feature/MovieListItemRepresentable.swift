import Foundation

protocol MovieListItemRepresentable {
    var id: Int { get }
    var posterPath: String? { get }
    var title: String { get }
    var releaseDate: String { get }
    var voteAverage: Double? { get }
}
