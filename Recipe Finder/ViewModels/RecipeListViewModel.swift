import Foundation

class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []

    func findRecipes(for ingredients: String) {
        // API call to fetch recipes will be implemented here
    }
}
