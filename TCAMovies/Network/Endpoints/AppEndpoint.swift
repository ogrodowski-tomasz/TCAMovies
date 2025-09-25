import Foundation

protocol AppEndpoint {
    var url: URL? { get }
    var stubDataFilename: String? { get }
    var method: HTTPMethod { get }
}
