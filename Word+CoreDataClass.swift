//
//  Word+CoreDataClass.swift
//  CoreDataToDo
//
//  Created by Dimash Bekzhan on 4/26/17.
//  Copyright © 2017 Dimash Bekzhan. All rights reserved.
//

import Foundation
import CoreData //import database
import UIKit
@objc(Word) //create object
//class - model for Word object in the database
public class Word: NSManagedObject {

    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    //Executes before every saving made in the database
    public override func willSave() {
        //if word has no categories, delete it
        if !self.isDeleted {
            if self.category?.count == 0 {
                let context = delegate.persistentContainer.viewContext
                context.delete(self)
            }
        }
        super.willSave()
    }
}
