import Foundation

class AddIngredientsViewModel: ObservableObject {
    @Published var ingredients: [String] = []

    func addIngredient(_ ingredient: String) {
        guard !ingredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        ingredients.append(ingredient)
    }

    func removeIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
}
