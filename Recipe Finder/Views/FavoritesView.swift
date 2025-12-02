import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesVM: FavoritesViewModel   // 👈 use environment object

    var body: some View {
        NavigationStack {
            Group {
                if favoritesVM.favorites.isEmpty {
                    VStack(spacing: 12) {
                        Text("No favorites yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Tap the heart on a recipe to save it here.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    List(favoritesVM.favorites) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(recipe.title)
                                    .font(.headline)
                                Text(recipe.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesViewModel())   // preview helper
}
