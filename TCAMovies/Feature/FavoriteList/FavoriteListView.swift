import ComposableArchitecture
import SwiftUI

struct FavoriteListView: View {
    let store: StoreOf<FavoriteListReducer>
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    FavoriteListView(store: Store(
        initialState: FavoriteListReducer.State(),
        reducer: {
            FavoriteListReducer()
        }
    ))
}
