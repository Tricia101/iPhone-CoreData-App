//
//  People+CoreDataProperties.swift
//  People Core Data
//
//  Created by lys on 18/04/2022.
//  Copyright © 2022 Jessica Daly. All rights reserved.
//
//

import Foundation
import CoreData


extension People {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var dob: String?
    @NSManaged public var height: String?
    @NSManaged public var image: String?
    @NSManaged public var isFavorited: Bool
    @NSManaged public var name: String?
    @NSManaged public var nationality: String?
    @NSManaged public var url: String?

}

extension People : Identifiable {

}
