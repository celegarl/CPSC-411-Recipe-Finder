import CoreData
import Foundation

extension FavoriteRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteRecipe> {
        return NSFetchRequest<FavoriteRecipe>(entityName: "FavoriteRecipe")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var instructions: String?

}

extension FavoriteRecipe: Identifiable {

}
