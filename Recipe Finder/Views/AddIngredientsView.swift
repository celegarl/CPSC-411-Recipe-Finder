import SwiftUI

struct AddIngredientsView: View {
    @StateObject private var viewModel = AddIngredientsViewModel()
    @State private var newIngredient: String = ""

    @Binding var selectedTab: Int
    
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
                }

                NavigationLink(
                    destination: RecipeListView(
                        ingredients: viewModel.ingredients.joined(separator: ","))
                ) {
                    Text("Find Recipes")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Recipe Finder")
        }
    }
}

#Preview {
    AddIngredientsView(selectedTab: .constant(0))
}