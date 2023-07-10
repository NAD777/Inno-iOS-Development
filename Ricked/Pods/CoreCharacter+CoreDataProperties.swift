//
//  CoreCharacter+CoreDataProperties.swift
//  
//
//  Created by Антон Нехаев on 07.07.2023.
//
//

import Foundation
import CoreData


extension CoreCharacter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreCharacter> {
        return NSFetchRequest<CoreCharacter>(entityName: "CoreCharacter")
    }

    @NSManaged public var gender: String?
    @NSManaged public var image: String?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var species: String?
    @NSManaged public var status: String?
    @NSManaged public var givenId: Int64

}
