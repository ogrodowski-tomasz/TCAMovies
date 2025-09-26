import SwiftData
import Dependencies
import Foundation

//@MainActor
struct FavoriteRepository {
    var fetchAll: @Sendable  () async throws -> [FavoriteMovie]
    var fetchById: @Sendable (Int) async throws -> FavoriteMovie?
    var add: @Sendable (FavoriteMovie) async throws -> Void
    var delete: @Sendable (FavoriteMovie) async throws -> Void
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
            }, fetchById: { movieId in
                @Dependency(\.databaseService) var database
                let context = try database.context()
                let descriptor = FetchDescriptor<FavoriteMovie>(predicate: #Predicate{ $0.movieId == movieId })
                let result = try context.fetch(descriptor).first
                return result

            },
            add: { movieToAdd in
                @Dependency(\.databaseService) var database
                let context = try database.context()
                context.insert(movieToAdd)
                try context.save()
            },
            delete: { movieToDelete in
                @Dependency(\.databaseService) var database
                let context = try database.context()
                context.delete(movieToDelete)
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
