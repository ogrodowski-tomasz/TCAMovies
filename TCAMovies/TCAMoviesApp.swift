import ComposableArchitecture
import SwiftUI
import SwiftData

@main
struct TCAMoviesApp: App {
    
    private var dataRepository: DataRepository {
        let container = try! ModelContainer(for: FavoriteMovie.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        return DataRepository(context: container.mainContext)
    }
    
    var body: some Scene {
        WindowGroup {
            MovieListView(store: Store(initialState: MovieListReducer.State(), reducer: {
                MovieListReducer()
            },withDependencies: {
                $0.dataRepository = dataRepository
            }))
        }
    }
}
