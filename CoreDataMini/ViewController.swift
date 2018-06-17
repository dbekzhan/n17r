//
//  ViewController.swift
//  CoreDataToDo
//
//  Created by Dimash Bekzhan on 4/19/17.
//  Copyright © 2017 Dimash Bekzhan. All rights reserved.
//

import UIKit //import library which allows to use visual objects
import CoreData //import database


// Class which is a model for initial view representing list of categories
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView! //reference to the object of type UIIableView, which is used to illustrate lists
    var categories: [Category] = [] //variable, which will store entities of categories from database
    
    let delegate = UIApplication.shared.delegate as! AppDelegate //getting access to the database
    
    //Set up
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // next two lines allow to implement features of lists on basis of this class
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //Programme will implement this function before view is to appear on the screen
    override func viewWillAppear(_ animated: Bool) {
        
        //Get data from Core Data
        getData()
        
        //Reload the list
        tableView.reloadData()
    }
    
    // MARK: - adjustment of how the list will be shown
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    //adjustment of each cell within the list
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //get access to the visual representation of the cell in Main.storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        //retrieve one category per each cell
        let category = categories[indexPath.row]
        //label of the cell will show spelling property of retrieved category
        cell.textLabel?.text = category.spelling
        
        return cell
    }
    
    //Recognize tapped cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Transition to another view which represents list of words related with selected category
        performSegue(withIdentifier: "wordsViewController", sender: categories[indexPath.row].spelling)
        
    }
    
    //Condition for deletion of selected category
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = delegate.persistentContainer.viewContext //getting access to the database
        
        if editingStyle == .delete {
            
            let category = categories[indexPath.row] //determine selected category
            
            context.delete(category) //delete categories from Data
            delegate.saveContext() //update database
            
            //Updating the list
            getData()
            tableView.reloadData()
        }
    }
    
    
    //Getting data from the database
    func getData() {
        
        let context = delegate.persistentContainer.viewContext
        
        do {
            categories = try context.fetch(Category.fetchRequest()) //variable stores received array of category entities
        }
        catch let err {
            print("\(err)")
        }
    }
    
    //This function is implemented before transition to another view is made
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if it needs to go to the view with related words
        if segue.identifier == "wordsViewController" {
            let wordsViewController = segue.destination as? WordsTableViewController //determine class of destination view
            wordsViewController?.selectedCategory = sender as? String // send selected category to determined class
        }
    }
}

