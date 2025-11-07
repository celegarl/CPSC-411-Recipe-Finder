import Foundation

struct Recipe: Identifiable, Decodable {
    let id: Int
    let title: String
    let image: String
    let instructions: String?
}
