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
    public static var previewValue = Self.noop
    
    public static let testValue = Self(
        context: unimplemented("\(Self.self).context")
    )
    
    static let noop = Self(
        context: unimplemented("\(Self.self).context")
    )
}

//@MainActor
struct FavoriteRepository {
    var fetchAll: @Sendable  () async throws -> [FavoriteMovie]
    var isFavorite: @Sendable (Int) async throws -> FavoriteMovie?
    var updateStatus: @Sendable (FavoriteMovie) async throws -> Void
}

struct FavoriteRepositoryKey: DependencyKey {
    
    static var liveValue: FavoriteRepository {
        return FavoriteRepository(
            fetchAll: {
                @Dependency(\.databaseService) var database
                let context = try database.context()
                let descriptor = FetchDescriptor<FavoriteMovie>(sortBy: [SortDescriptor(\.title)])
                let result = try context.fetch(descriptor)
                return result
            },
            isFavorite: { movieId in
                @Dependency(\.databaseService) var database
                let context = try database.context()

                let predicate: Predicate<FavoriteMovie> = #Predicate { $0.id == movieId }
                let descriptor = FetchDescriptor<FavoriteMovie>(predicate: predicate)
                return try context.fetch(descriptor).first
            },
            updateStatus: { movie in
                @Dependency(\.databaseService) var database
                let context = try database.context()

//                let predicate: Predicate<FavoriteMovie> = #Predicate { $0.id == movie.id }
                let descriptor = FetchDescriptor<FavoriteMovie>()
                if let alreadyFavorite = try context.fetch(descriptor).first {
                    context.delete(alreadyFavorite)
                } else {
                    context.insert(movie)
                }
                try context.save()
            }
        )
    }
}

extension DependencyValues {
    var favoriteRepository: FavoriteRepository {
        get { self[FavoriteRepositoryKey.self] }
        set { self[FavoriteRepositoryKey.self] = newValue }
    }
}
