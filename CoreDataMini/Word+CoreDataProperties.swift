//
//  Word+CoreDataProperties.swift
//  CoreDataToDo
//
//  Created by Dimash Bekzhan on 4/26/17.
//  Copyright © 2017 Dimash Bekzhan. All rights reserved.
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word");
    }

    @NSManaged public var spelling: String?
    @NSManaged public var category: NSSet?

}

// MARK: Generated accessors for category
extension Word {

    @objc(addCategoryObject:)
    @NSManaged public func addToCategory(_ value: Category)

    @objc(removeCategoryObject:)
    @NSManaged public func removeFromCategory(_ value: Category)

    @objc(addCategory:)
    @NSManaged public func addToCategory(_ values: NSSet)

    @objc(removeCategory:)
    @NSManaged public func removeFromCategory(_ values: NSSet)

}
