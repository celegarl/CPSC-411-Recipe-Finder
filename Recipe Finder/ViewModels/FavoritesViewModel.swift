import Foundation
import SwiftUI

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Recipe] = []
}
