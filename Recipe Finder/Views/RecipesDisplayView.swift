//
//  RecipesDisplayView.swift
//  Recipe Finder
//
//  Created by Guido Asbun on 11/08/25.
//
import SwiftUI

struct RecipesDisplayView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Binding var selectedTab: Int

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    ForEach(viewModel.recipes) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
                            recipePreview(recipe: recipe)
                        }
                    }
                }

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                }

                if viewModel.recipes.isEmpty {
                    VStack {
                        Spacer()
                        Text("No recipes generated")
                        Spacer()
                        Button(action: {
                            selectedTab = 0
                        }) {
                            Text("Generate Recipes")
                                .font(.headline)
                                .foregroundStyle(.primary)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Recipes")
        }
    }

    @ViewBuilder
    private func recipePreview(recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
            } else if let imageURL = recipe.imageURL, let url = URL(string: imageURL) {
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
    MainTabView(selectedTab: 1)
}
