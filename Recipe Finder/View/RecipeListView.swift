import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    let ingredients: String

    var body: some View {
        List(viewModel.recipes) {
            recipe in
            Text(recipe.title)
        }
        .navigationTitle("Recipes")
        .onAppear {
            viewModel.findRecipes(for: ingredients)
        }
    }
}
