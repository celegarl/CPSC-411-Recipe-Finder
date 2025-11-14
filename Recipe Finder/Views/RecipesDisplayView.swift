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
        }
        
    }
}

#Preview {
    RecipesDisplayView(viewModel: RecipeViewModel())
}
