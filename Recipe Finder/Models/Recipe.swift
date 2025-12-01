import Foundation

// Changed to Codable from Decodable because we need both
// Decodable and Encodable
struct Recipe: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let ingredients: [String]
    let steps: [String]
    let duration: String
    let caloriesPerServing: Int
    let estimatedCostPerServing: Double
    let difficulty: String
    var imageURL: String?
    var imageData: Data?
    let createdAt: Date

    init(
        id: UUID = UUID(), title: String, description: String, ingredients: [String],
        steps: [String], duration: String, caloriesPerServing: Int, estimatedCostPerServing: Double,
        difficulty: String, imageURL: String? = nil, imageData: Data? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.ingredients = ingredients
        self.steps = steps
        self.duration = duration
        self.caloriesPerServing = caloriesPerServing
        self.estimatedCostPerServing = estimatedCostPerServing
        self.difficulty = difficulty
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
    let duration: String
    let caloriesPerServing: Int
    let estimatedCostPerServing: Double
    let difficulty: String
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case ingredients
        case steps
        case duration
        case caloriesPerServing = "calories_per_serving"
        case estimatedCostPerServing = "estimated_cost_per_serving"
        case difficulty
    }
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
    let data: [ImageData]

    struct ImageData: Codable {
        let url: String
    }
}
