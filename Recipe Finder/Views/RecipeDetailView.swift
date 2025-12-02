//
//  RecipeDetailView.swift
//  Recipe Finder
//
//  Created by Celeste on 12/1/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @EnvironmentObject var favoritesVM: FavoritesViewModel   // ❤️ add this!!

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: - IMAGE
                if let data = recipe.imageData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 240)
                        .clipped()
                        .cornerRadius(16)
                        .padding(.horizontal)
                }

                // MARK: - TITLE & DESCRIPTION
                VStack(alignment: .leading, spacing: 12) {
                    Text(recipe.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(recipe.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // MARK: - META INFO (duration, calories, cost, difficulty)
                    VStack(alignment: .leading, spacing: 6) {
                        Label(recipe.duration, systemImage: "clock")

                        Label("\(recipe.caloriesPerServing) cal / serving",
                              systemImage: "flame")

                        Label(String(format: "$%.2f / serving",
                                     recipe.estimatedCostPerServing),
                              systemImage: "dollarsign.circle")

                        Label(recipe.difficulty.capitalized,
                              systemImage: "chart.bar")
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal)

                // MARK: - INGREDIENTS
                if !recipe.ingredients.isEmpty {
                    Divider().padding(.vertical, 8)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients")
                            .font(.headline)

                        ForEach(recipe.ingredients, id: \.self) { item in
                            HStack(alignment: .top) {
                                Text("•")
                                Text(item)
                            }
                            .font(.body)
                        }
                    }
                    .padding(.horizontal)
                }

                // MARK: - STEPS
                if !recipe.steps.isEmpty {
                    Divider().padding(.vertical, 8)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Steps")
                            .font(.headline)

                        ForEach(recipe.steps.indices, id: \.self) { index in
                            HStack(alignment: .top, spacing: 8) {
                                Text("\(index + 1).")
                                    .bold()
                                Text(recipe.steps[index])
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .font(.body)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.bottom, 30)
        }
        .navigationTitle("Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                favoritesVM.toggleFavorite(recipe)
            } label: {
                Image(systemName: favoritesVM.isFavorite(recipe) ? "heart.fill" : "heart")
                    .foregroundStyle(.red)
            }
        }
    }
}
