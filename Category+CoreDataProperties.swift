//
//  Category+CoreDataProperties.swift
//  CoreDataToDo
//
//  Created by Dimash Bekzhan on 4/26/17.
//  Copyright © 2017 Dimash Bekzhan. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var spelling: String?
    @NSManaged public var word: NSSet?

}

// MARK: Generated accessors for word
extension Category {

    @objc(addWordObject:)
    @NSManaged public func addToWord(_ value: Word)

    @objc(removeWordObject:)
    @NSManaged public func removeFromWord(_ value: Word)

    @objc(addWord:)
    @NSManaged public func addToWord(_ values: NSSet)

    @objc(removeWord:)
    @NSManaged public func removeFromWord(_ values: NSSet)

}
