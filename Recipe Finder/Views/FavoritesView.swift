import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel

    var body: some View {
        Text("Favorites View")
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel())
}
