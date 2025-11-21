//
//  OpenAIService.swift
//  Recipe Finder
//
//  Created by Guido Asbun on 11/08/25.
//

import Foundation

class OpenAIService {
    static let shared = OpenAIService()
    private let apiKey = Config.openAIAPIKey
    
    private init() {}
    
    func generateRecipes(ingredients: [String], count: Int = 3) async throws -> [Recipe] {
            let prompt = """
            Create \(count) unique recipes using only these ingredients: \(ingredients.filter { !$0.isEmpty }.joined(separator: ", ")).
            Assume I have basic cooking ingredients like salt, pepper, flour and oil.
            Give me a brief description of the recipe.
            The recipes should be simple and easy to follow.
            Ingredients are formatted by measurement and name.
            Instructions are formatted by instructionNumber and instruction.
            provide detailed instructions.
            for the step, dont provide step numbers.
            include a detailed description.
            Return the result as a JSON array like this:
            [
                {
                    "title": "Recipe Name",
                    "description": "detailed description",
                    "ingredients": ["ingredient1", "ingredient2"],
                    "steps": ["Step 1", "Step 2"]
                },
                ...
            ]
            """

            let url = URL(string: "https://api.openai.com/v1/chat/completions")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = [
                "model": "gpt-3.5-turbo",
                "messages": [
                    ["role": "user", "content": prompt]
                ]
            ]

            request.httpBody = try JSONSerialization.data(withJSONObject: body)

            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)

            guard let content = response.choices.first?.message.content else {
                throw NSError(domain: "OpenAIService", code: 1, userInfo: [NSLocalizedDescriptionKey: "No response from API"])
            }

            // Parse the JSON array from the content
            let jsonData = content.data(using: .utf8)!
            let recipeResponses = try JSONDecoder().decode([OpenAIRecipeResponse].self, from: jsonData)

            // Convert to Recipe objects
        
//            print ("Ingredients", ingredients)
//            print ("Recipes", recipeResponses)
            return recipeResponses.map { response in
                Recipe(
                    title: response.title,
                    description: response.description,
                    ingredients: response.ingredients,
                    steps: response.steps
                )
            }
        }
    
    func generateImage(for recipeName: String) async throws -> String {
            let prompt = "A delicious, appetizing photo of \(recipeName), professional food photography"

            let url = URL(string: "https://api.openai.com/v1/images/generations")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = [
                "model": "dall-e-3",
                "prompt": prompt,
                "size": "1024x1024",
                "n": 1
            ]

            request.httpBody = try JSONSerialization.data(withJSONObject: body)

            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(ImageGenerationResponse.self, from: data)

            guard let imageURL = response.data.first?.url else {
                throw NSError(domain: "OpenAIService", code: 2, userInfo: [NSLocalizedDescriptionKey: "No image URL in response"])
            }

            return imageURL
        }

        func downloadImage(from urlString: String) async throws -> Data {
            guard let url = URL(string: urlString) else {
                throw NSError(domain: "OpenAIService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            }

            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        }
}
