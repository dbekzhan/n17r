//
//  WordsTableViewController.swift
//  CoreDataToDo
//
//  Created by Dimash Bekzhan on 5/1/17.
//  Copyright © 2017 Dimash Bekzhan. All rights reserved.
//

import UIKit
import CoreData

// Class which is a model for view where a list of words related with selected category is shown
class WordsTableViewController: UITableViewController {

    var selectedCategory: String? //variable which receives selected category from view with categories
    var words: [Word]? //variable stores array of entities of words related with selected category
    let delegate = UIApplication.shared.delegate as! AppDelegate //access to the database
    
    //implemented right before view appears
    override func viewWillAppear(_ animated: Bool) {
        getData() //get data from database
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        //returns the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (words?.count)!
    }

    //adjustment of each cell within the list
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) //access to the visual representation

        cell.textLabel?.text = words?[indexPath.row].spelling //label of each cell shows one related word

        return cell
    }
    
    //Responds to editing
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = delegate.persistentContainer.viewContext
        
        if editingStyle == .delete {
            // Delete the row from the data source
            let word = words?[indexPath.row]
            context.delete(word!)
            delegate.saveContext() //save changes
            
            //Updating the list
            getData()
            tableView.reloadData()
            
        }
    }
    //retrieve data from the database
    func getData() {
        
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        request.predicate = NSPredicate(format: "ANY category.spelling = %@", "\(selectedCategory!)") //condition which checks if word has relationships with selected category
        
        do {
            words = try(context.fetch(request)) as? [Word]
        }
        catch let err {
            print("\(err.localizedDescription)")
        }
    }
}
