import SwiftUI

struct AddIngredientsView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Binding var selectedTab: Int
    @State private var newIngredient: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Add ingredient", text: $newIngredient)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        viewModel.addIngredient(newIngredient)
                        newIngredient = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
                .padding()

                List {
                    ForEach(viewModel.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                    }
                    .onDelete(perform: viewModel.removeIngredient)

                    if !viewModel.ingredients.isEmpty {
                        Button(action: {
                            viewModel.resetIngredients()
                        }) {
                            Text("Delete All")
                                .foregroundColor(.red)
                        }
                    }
                }

                NavigationLink(
                    destination: RecipesDisplayView(viewModel: viewModel, selectedTab: $selectedTab)
                ) {
                    Button(action: {
                        selectedTab = 1
                        Task {
                            await viewModel.generateRecipes()
                        }
                    }) {
                        Text("Generate Recipes")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    .disabled(!viewModel.canGenerateRecipes() || viewModel.isLoading)
                    .opacity(viewModel.canGenerateRecipes() && !viewModel.isLoading ? 1.0 : 0.5)
                }
                Spacer()
            }
            .navigationTitle("Enter Ingredients")
        }
    }
}

#Preview {
    MainTabView(selectedTab: 0)
}
