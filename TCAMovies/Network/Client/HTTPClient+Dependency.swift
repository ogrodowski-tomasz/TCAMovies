import ComposableArchitecture
import Foundation

// MARK: - DEPENDENCY VALUES

extension DependencyValues {
    var httpClient: HTTPClient {
        get { self[HTTPClient.self] }
        set { self[HTTPClient.self] = newValue }
    }
}

// MARK: - LIVE VALUE

extension HTTPClient: DependencyKey {
    static var liveValue: HTTPClient {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json", "Authorization": "Bearer \(AppKey.apiKey)"]
        let session = URLSession(configuration: configuration)
        return HTTPClient(
            loadData: { endpoint in
                guard let url = endpoint.url else {
                    throw NetworkError.badRequest
                }
                var request = URLRequest(url: url)
                request.httpMethod = endpoint.method.name
                
                
                switch endpoint.method {
                case .get(let queryItems):
                    if queryItems.isEmpty {
                        break
                    }
                    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                    components?.queryItems = queryItems
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
                
                return data
            }
        )
    }
}

struct StaticDataClient {
    static func load(_ endpoint: AppEndpoint) throws -> Data {
        guard
            let file = endpoint.stubDataFilename,
            !file.isEmpty,
            let path = Bundle.main.path(forResource: file, ofType: "json"),
            let data = FileManager.default.contents(atPath: path)
        else {
            throw NetworkError.invalidURL
        }
        return data
    }
}

// MARK: - TEST VALUE

extension HTTPClient: TestDependencyKey {
    static var testValue: HTTPClient {
        HTTPClient(loadData: { endpoint in
            try StaticDataClient.load(endpoint)
        })
    }
    
    static var previewValue: HTTPClient {
        HTTPClient(
            loadData: { endpoint in
                try StaticDataClient.load(endpoint)
            }
        )
    }
}
