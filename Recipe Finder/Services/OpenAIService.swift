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

    func generateRecipes(ingredients: [String], count: Int) async throws -> [Recipe] {
        let prompt = """
            Create \(count) unique recipes using only these ingredients: \(ingredients.filter { !$0.isEmpty }.joined(separator: ", ")).
            Assume I have basic cooking ingredients like salt, pepper, flour and oil.
            Give me a brief description of the recipe.
            The recipes should be simple and easy to follow.
            Ingredients are formatted by measurement and name.
            Instructions are formatted by instructionNumber and instruction.
            provide detailed instructions.
            For each step, do not provide step numbers.
            Provide estimates for the duration of the recipe following the format "X hr Y min".
            Provide estimates for the calories per serving as a number.
            Provide estimates for the estimated cost per serving as a number.
            Provide the difficulty of the recipe as a string: "easy", "medium", "hard" or "expert".
            include a detailed description.
            Return the result as a JSON array like this:
            [
                {
                    "title": "Recipe Name",
                    "description": "detailed description",
                    "ingredients": ["ingredient1", "ingredient2"],
                    "steps": ["Step 1", "Step 2"],
                    "duration": "1 hr 30 min",
                    "calories_per_serving": 200,
                    "estimated_cost_per_serving": 10.00,
                    "difficulty": "easy"
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
            ],
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let data: Data
        do {
            let (responseData, _) = try await URLSession.shared.data(for: request)
            if let json = try? JSONSerialization.jsonObject(with: responseData, options: [])
                as? [String: Any],
                json["error"] != nil
            {
                throw NSError(
                    domain: "OpenAIService", code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "API key error"])
            }
            data = responseData
            saveToFile(data: data, fileName: "generateRecipesResponse.json")
        } catch {
            print("Failed to fetch recipes, loading from mock. Error: \(error)")
            data = loadFromMock(fileName: "generateRecipesResponse.json")
        }

        print("Got data: \(String(data: data, encoding: .utf8))")
        let response = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
        print(response)

        guard let content = response.choices.first?.message.content else {
            throw NSError(
                domain: "OpenAIService", code: 1,
                userInfo: [NSLocalizedDescriptionKey: "No response from API"])
        }

        // Parse the JSON array from the content
        let jsonData = content.data(using: .utf8)!
        let recipeResponses = try JSONDecoder().decode([OpenAIRecipeResponse].self, from: jsonData)

        // Convert to Recipe objects
        print("Ingredients", ingredients)
        print("Recipes", recipeResponses)
        return recipeResponses.map { response in
            Recipe(
                title: response.title,
                description: response.description,
                ingredients: response.ingredients,
                steps: response.steps,
                duration: response.duration,
                caloriesPerServing: response.caloriesPerServing,
                estimatedCostPerServing: response.estimatedCostPerServing,
                difficulty: response.difficulty
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
            "n": 1,
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let data: Data
        do {
            let (responseData, _) = try await URLSession.shared.data(for: request)
            if let json = try? JSONSerialization.jsonObject(with: responseData, options: [])
                as? [String: Any],
                json["error"] != nil
            {
                throw NSError(
                    domain: "OpenAIService", code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "API key error"])
            }
            data = responseData
            saveToFile(data: data, fileName: recipeName + ".json")
        } catch {
            print("Failed to fetch image, loading from mock. Error: \(error)")
            data = loadFromMock(fileName: recipeName + ".json")
        }

        print("Got data: \(String(data: data, encoding: .utf8))")
        let response = try JSONDecoder().decode(ImageGenerationResponse.self, from: data)

        guard let imageURL = response.data.first?.url else {
            throw NSError(
                domain: "OpenAIService", code: 2,
                userInfo: [NSLocalizedDescriptionKey: "No image URL in response"])
        }

        return imageURL
    }

    func downloadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NSError(
                domain: "OpenAIService", code: 3,
                userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var data: Data
        do {
            (data, _) = try await URLSession.shared.data(from: url)
            if data.count < 2048 {
                throw NSError(
                    domain: "OpenAIService", code: 4,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "Image data is too small, assuming expired image."
                    ])
            }
        } catch {
            print("Failed to fetch image, loading from mock. Error: \(error)")
            let mocks: [String: String] = [
                "https://oaidalleapiprodscus.blob.core.windows.net/private/org-6MIzic4M3mgTHOsdFuYM0KTr/user-V0MQe4DkGj1AHkbsQOVfdoik/img-5THJRgvoTd56TW2JViEmuIsb.png?st=2025-11-29T20%3A23%3A02Z&se=2025-11-29T22%3A23%3A02Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=b2c0e1c0-cf97-4e19-8986-8073905d5723&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-11-29T21%3A23%3A02Z&ske=2025-11-30T21%3A23%3A02Z&sks=b&skv=2024-08-04&sig=Leba/BHrmYC15jFd91z1dQ9obqHw644Q1%2BKVFFYandU%3D":
                    "Orange Chicken And Rice Soup.jpg",
                "https://oaidalleapiprodscus.blob.core.windows.net/private/org-6MIzic4M3mgTHOsdFuYM0KTr/user-V0MQe4DkGj1AHkbsQOVfdoik/img-vxz7F7pdsQMqk2eSpQufzXAr.png?st=2025-11-29T20%3A22%3A59Z&se=2025-11-29T22%3A22%3A59Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=32836cae-d25f-4fe9-827b-1c8c59c442cc&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-11-29T20%3A03%3A07Z&ske=2025-11-30T20%3A03%3A07Z&sks=b&skv=2024-08-04&sig=LID4xCifbbn0B8TsZ/XM913P/lI4up4kYsf0E2vN91c%3D":
                    "Orange Chicken Stir Fry.jpg",
                "https://oaidalleapiprodscus.blob.core.windows.net/private/org-6MIzic4M3mgTHOsdFuYM0KTr/user-V0MQe4DkGj1AHkbsQOVfdoik/img-R50FiEUOdknhPlrB4XN0BQAA.png?st=2025-11-29T20%3A23%3A00Z&se=2025-11-29T22%3A23%3A00Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=31d50bd4-689f-439b-a875-f22bd677744d&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-11-29T15%3A04%3A50Z&ske=2025-11-30T15%3A04%3A50Z&sks=b&skv=2024-08-04&sig=8wijVVzpni8WXBpjoI8A6%2BdgtZzdaxA4OHXJBQ0uf1A%3D":
                    "Orange Glazed Chicken.jpg",
            ]
            data = loadImageFromMock(fileName: mocks[urlString]!)
        }
        print(data)
        return data
    }

    private func loadFromMock(fileName: String) -> Data {
        let resourceName = "\(fileName)".replacingOccurrences(of: ".json", with: "")
        guard let file = Bundle.main.url(forResource: resourceName, withExtension: "json")
        else {
            fatalError("Couldn't find \(fileName) in main bundle.")
        }

        do {
            return try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(fileName) from main bundle:\n\(error)")
        }
    }

    private func loadImageFromMock(fileName: String) -> Data {
        let resourceName = "\(fileName)".replacingOccurrences(of: ".jpg", with: "")
        guard let file = Bundle.main.url(forResource: resourceName, withExtension: "jpg")
        else {
            fatalError("Couldn't find \(fileName) in main bundle.")
        }

        do {
            return try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(fileName) from main bundle:\n\(error)")
        }
    }

    private func saveToFile(data: Data, fileName: String) {
        let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask
        ).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            print("Saved to \(fileURL.path)")
        } catch {
            print("Error saving file: \(error)")
        }
    }
}
