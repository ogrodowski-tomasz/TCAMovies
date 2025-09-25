import ComposableArchitecture
import Foundation

struct HTTPClient {
    private var loadData: @Sendable (_ endpoint: AppEndpoint) async throws -> Data
    
    init(loadData: @Sendable @escaping (_ endpoint: AppEndpoint) async throws -> Data) {
        self.loadData = loadData
    }
}

extension HTTPClient {
    func load<T: Codable>(_ endpoint: AppEndpoint, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil, decodeToType modelType: T.Type) async throws -> T {
        let data = try await loadData(endpoint)
        do {
            let decoder = JSONDecoder()
            if let keyDecodingStrategy {
                decoder.keyDecodingStrategy = keyDecodingStrategy
            }
            let result = try decoder.decode(modelType, from: data)
            print("DEBUG: Successfully decoded response from endpoint [\(endpoint)]")
            return result
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

