import ComposableArchitecture
import SwiftData
import SwiftUI

@main
struct TCAMoviesApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabBarView(store: Store(initialState: TabBarReducer.State(), reducer: TabBarReducer.init))
        }
    }
}
