

import Foundation
import CoreData


extension NoteData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteData> {
        return NSFetchRequest<NoteData>(entityName: "NoteData")
    }

    @NSManaged public var color: String?
    @NSManaged public var text: String?
    @NSManaged public var time: Date?
    @NSManaged public var title: String?

}

extension NoteData : Identifiable {

}
