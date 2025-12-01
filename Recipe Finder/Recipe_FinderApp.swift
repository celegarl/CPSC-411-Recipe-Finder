import CoreData
import SwiftUI

@main
struct Recipe_FinderApp: App {

    var body: some Scene {
        WindowGroup {
            MainTabView(selectedTab: 2)
        }
    }
}
