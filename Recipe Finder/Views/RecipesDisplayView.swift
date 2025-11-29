//
//  RecipesDisplayView.swift
//  Recipe Finder
//
//  Created by Guido Asbun on 11/08/25.
//
import SwiftUI

struct RecipesDisplayView: View {
    @ObservedObject var viewModel: RecipeViewModel

    var body: some View {
        ZStack {
            ScrollView {
                Text("Recipes Display")
                    .font(.largeTitle)
                    .padding()

                // MARK: - This should be on the AddIngredientsView
                // Generate Recipes button
                Button(action: {
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

                // Display generated recipes
                ForEach(viewModel.recipes) { recipe in
                    recipePreview(recipe: recipe)
                }
            }

            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }
        }
    }

    @ViewBuilder
    private func recipePreview(recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageURL = recipe.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                } placeholder: {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 200)
                        ProgressView()
                    }
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
            }

            Text(recipe.title)
                .font(.headline)

            Text(recipe.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    RecipesDisplayView(viewModel: RecipeViewModel())
}
