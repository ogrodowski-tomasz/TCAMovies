import Foundation

enum NetworkError: Error {
    case badRequest
    case serverError(String)
    case decodingError(Error)
    case invalidResponse
    case invalidURL
    case httpError(Int)
}

extension NetworkError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Unable to perform request", comment: "badRequestError")
        case .serverError(let errorMessage):
            return NSLocalizedString(errorMessage, comment: "serverError")
        case .decodingError:
            return NSLocalizedString("Unable to decode successfully.", comment: "decodingError")
        case .invalidResponse:
            return NSLocalizedString("Invalid response", comment: "invalidResponse")
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "invalidURL")
        case .httpError(_):
            return NSLocalizedString("Bad request", comment: "badRequest")
        }
    }

}

enum HTTPMethod {
    case get([URLQueryItem])
    case post(Data?)
    case delete

    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        }
    }
}

struct Resource<T: Codable> {
    let url: URL
    var method: HTTPMethod = .get([])
    var modelType: T.Type
}

protocol HTTPClientProtocol {
    func load<T: Codable>(_ resource: Resource<T>, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy?) async throws -> T
}

extension HTTPClientProtocol {
    func load<T: Codable>(_ resource: Resource<T>, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil) async throws -> T {
        try await load(resource, keyDecodingStrategy: keyDecodingStrategy)
    }
}

struct HTTPClient: HTTPClientProtocol {

    private let session: URLSession
    
    static let shared = HTTPClient()

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json", "Authorization": "Bearer \(AppKey.apiKey)"]
        self.session = URLSession(configuration: configuration)
    }

    func load<T: Codable>(_ resource: Resource<T>, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil) async throws -> T {

        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.method.name


        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
            if !queryItems.isEmpty {
                components?.queryItems = queryItems
            }
            guard let url = components?.url else {
                throw NetworkError.badRequest
            }

            request = URLRequest(url: url)

        case .post(let data):
            request.httpBody = data

        case .delete:
            break
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            if let keyDecodingStrategy {
                decoder.keyDecodingStrategy = keyDecodingStrategy
            }
            let result = try decoder.decode(resource.modelType, from: data)
            return result
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

}

