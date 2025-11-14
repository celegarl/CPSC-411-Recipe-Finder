import Foundation

// Changed to Codable from Decodable because we need both
// Decodable and Encodable
struct Recipe: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let ingredients: [String]
    let steps: [String]
    var imageURL: String?
    var imageData: Data?
    let createdAt: Date
    
    init(id: UUID = UUID(), title: String, description: String, ingredients: [String], steps: [String], imageURL: String? = nil, imageData: Data? = nil, createdAt: Date = Date()) {
            self.id = id
            self.title = title
            self.description = description
            self.ingredients = ingredients
            self.steps = steps
            self.imageURL = imageURL
            self.imageData = imageData
            self.createdAt = createdAt
        }
}

// OpenAI API Response Models
struct OpenAIRecipeResponse: Codable {
    let title: String
    let description: String
    let ingredients: [String]
    let steps: [String]
}

struct ChatCompletionResponse: Codable {
    // Models the OpenAI Chat Completion API Response Wrapper
    let choices: [Choice]

        struct Choice: Codable {
            let message: Message
        }

        struct Message: Codable {
            let content: String
        }
}

struct ImageGenerationResponse: Codable {
    // Models the DALL-E-3 API response
}
