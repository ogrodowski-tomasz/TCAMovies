import Foundation
import SwiftData
import ComposableArchitecture

// MARK: - Protokół
protocol DataRepositoryProtocol {
    func create<T: PersistentModel>(_ object: T) throws
    func fetchAll<T: PersistentModel>(ofType type: T.Type) throws -> [T]
    func fetchFirst<T: PersistentModel>(ofType type: T.Type, predicate: Predicate<T>) throws -> T?
    func delete<T: PersistentModel>(_ object: T) throws
    func deleteAll<T: PersistentModel>(ofType type: T.Type) throws
}

// MARK: - Implementacja
struct DataRepository: DataRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func create<T: PersistentModel>(_ object: T) throws {
        context.insert(object)
        try context.save()
    }

    func fetchAll<T: PersistentModel>(ofType type: T.Type) throws -> [T] {
//        try context.fetch(FetchDescriptor<T>())
        print("DATA REPOSITORY FETCH")
        return []
    }

    func fetchFirst<T: PersistentModel>(ofType type: T.Type, predicate: Predicate<T>) throws -> T? {
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        return try context.fetch(descriptor).first
    }

    func delete<T: PersistentModel>(_ object: T) throws {
        context.delete(object)
        try context.save()
    }

    func deleteAll<T: PersistentModel>(ofType type: T.Type) throws {
        let all = try fetchAll(ofType: type)
        all.forEach { context.delete($0) }
        try context.save()
    }
}

private enum DataRepositoryKey: DependencyKey {
    static var liveValue: any DataRepositoryProtocol {
        fatalError("Must inject DataRepository manually with context.")
    }
}

extension DependencyValues {
    var dataRepository: any DataRepositoryProtocol {
        get { self[DataRepositoryKey.self] }
        set { self[DataRepositoryKey.self] = newValue }
    }
}
