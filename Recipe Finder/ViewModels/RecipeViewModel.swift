//
//  RecipeViewModel.swift
//  Recipe Finder
//
//  Created by Guido Asbun on 11/13/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class RecipeViewModel: ObservableObject {

    // MARK: - Hard Coded ingredients for testing
    
    @Published var ingredients: [String] = ["chicken","orange","rice"]
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var recipeCount = Config.defaultRecipeCount
    
    private let openAIService = OpenAIService.shared
    
    func addIngredient() {
        // Add ingredient
    }
    
    func removeIngredient(at index: Int) {
        // Remove ingredient
    }
    
    func canGenerateRecipes() -> Bool {
        // Determines if "Generate Recipes" button should be enabled
        return true
    }
    
    func generateRecipes() async {
        // Generates recipes
        let validIngredients = ingredients.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }

        guard validIngredients.count >= 1 else {
            errorMessage = "Please enter at least one ingredient"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Generate recipes
            var generatedRecipes = try await openAIService.generateRecipes(
                ingredients: validIngredients,
                count: recipeCount
            )
            
            // Generate images for all recipes in parallel
            await withTaskGroup(of: (Int, String?, Data?).self) { group in
                for i in 0..<generatedRecipes.count {
                    group.addTask {
                        do {
                            let imageURL = try await self.openAIService.generateImage(for: generatedRecipes[i].title)
                            let imageData = try await self.openAIService.downloadImage(from: imageURL)
                            return (i, imageURL, imageData)
                        } catch {
                            print("Failed to generate image for \(generatedRecipes[i].title): \(error)")
                            return (i, nil, nil)
                        }
                    }
                }

                // Collect results as they complete
                for await (index, imageURL, imageData) in group {
                    if let url = imageURL, let data = imageData {
                        generatedRecipes[index].imageURL = url
                        generatedRecipes[index].imageData = data
                    }
                }
            }
            
            recipes = generatedRecipes
            isLoading = false
            
            // MARK: - Print the recipes to the console
            print("AI - GENERATED RECIPES: ")
            for recipe in generatedRecipes {
                print("\(recipe)\n")
            }
            
        } catch {
            isLoading = false
            errorMessage = "Unable to create recipes, please try again"
            print("Error generating recipes: \(error)")
        }
        
    }
    
    func clearRecipes() {
        recipes = []
    }
    
    func resetIngredients() {
        ingredients = ["","",""]
    }
    
}
