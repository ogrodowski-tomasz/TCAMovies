import ComposableArchitecture
import SwiftUI

@main
struct TCAMoviesApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListView(store: Store(initialState: MovieListReducer.State(), reducer: {
                MovieListReducer()
            }))
        }
    }
}
