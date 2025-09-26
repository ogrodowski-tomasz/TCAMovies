import SwiftData
import Dependencies
import Foundation

extension DependencyValues {
    var databaseService: Database {
        get { self[Database.self] }
        set { self[Database.self] = newValue }
    }
}

fileprivate let appContext: ModelContext = {
    do {
        
        let url = URL.applicationSupportDirectory.appending(path: "Model.sqlite")
        let config = ModelConfiguration(url: url)
        
        let container = try ModelContainer(for: FavoriteMovie.self, configurations: config)
        return ModelContext(container)
    } catch {
        fatalError("Failed to create container.")
    }
}()

struct Database {
    var context: () throws -> ModelContext
}

extension Database: DependencyKey {
    public static let liveValue = Self(
        context: { appContext }
    )
}

extension Database: TestDependencyKey {
    public static var previewValue = Self.inMemoryContainer
    
    public static let testValue = Self.inMemoryContainer
    
    static let inMemoryContainer = Self(
        context: {
            do {
                let config = ModelConfiguration(isStoredInMemoryOnly: true)
                let container = try ModelContainer(for: FavoriteMovie.self, configurations: config)
                return ModelContext(container)
            } catch {
                fatalError("Failed to create test container. \(error.localizedDescription)")
            }
        }
    )
}
