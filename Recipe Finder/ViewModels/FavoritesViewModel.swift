import Foundation
import SwiftUI

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published private(set) var favorites: [Recipe] = []

    private let favoritesKey = "favorite_recipes"

    // MARK: - Init
    init() {
        loadFavorites()
    }

    func isFavorite(_ recipe: Recipe) -> Bool {
        favorites.contains { $0.id == recipe.id }
    }

    func toggleFavorite(_ recipe: Recipe) {
        if let index = favorites.firstIndex(where: { $0.id == recipe.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(recipe)
        }
        saveFavorites()
    }

    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else { return }

        do {
            let decoded = try JSONDecoder().decode([Recipe].self, from: data)
            favorites = decoded
        } catch {
            print("Failed to decode favorites: \(error)")
        }
    }

    private func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: favoritesKey)
        } catch {
            print("Failed to encode favorites: \(error)")
        }
    }
}
