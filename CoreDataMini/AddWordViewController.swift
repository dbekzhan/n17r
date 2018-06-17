//
//  AddWordViewController.swift
//  CoreDataToDo
//
//  Created by Dimash Bekzhan on 4/19/17.
//  Copyright © 2017 Dimash Bekzhan. All rights reserved.
//

import UIKit //import library which allows to use visual objects
import CoreData //import database


// Class which is a model for view where a user may add new words
class AddWordViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var textFieldAddWord: UITextField! //reference to the object of type UITextField, which is used to receive input
    @IBOutlet weak var pickerViewCategory: UIPickerView! //reference to the object of type UIPickerView, which is used to illustrate scroll with categories
    
    let delegate = UIApplication.shared.delegate as! AppDelegate //access to the database
    
    var categories: [Category] = [] //variable, which will store entities of categories from database
    var selectedCategory: Category? //variable which stores selected category
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // next two lines allow to implement features of scroll on basis of this class
        pickerViewCategory.delegate = self
        pickerViewCategory.dataSource = self
    }
    
    //function which is implemented right after view has appeared
    override func viewDidAppear(_ animated: Bool) {
        
        //check if there any categories stored in the database
        if !isEntityNotInCoreData(entity: "Category") {
            getData()
            pickerViewCategory.reloadAllComponents()
        } else {
            createAlert() //show pop-up view which asks to input new category
        }
    }
    
    //Get data from the database
    func getData() {
        let context = delegate.persistentContainer.viewContext
        
        do {
            categories = try context.fetch(Category.fetchRequest()) //variable stores array of category entities
        } catch let err {
            print("\(err)")
        }
    }
    // MARK: - adjustment of scroll 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if categories.isEmpty {
            return 0 //do not show scroll at all if there is no category
        } else {
            return 1 //show scroll if there is at least one category
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].spelling //on each line of the scroll there would be title of one category
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategory = categories[row] //determine selected category
    }
    
    //Correspond if addWord button was tapped
    @IBAction func buttonAddWord(_ sender: UIButton) {
   
        //check if the user typed any text
        if  let input = textFieldAddWord.text {
        
            var existingWord: [Word]? //variable which will store
            let context = delegate.persistentContainer.viewContext //access to the database
            
            //check if word already exists, and if so, just bind with new topic
            existingWord = searchEntityInContext(entity: "Word", in: context, input: input) as? [Word]
            if let wordCollection = existingWord {
                if wordCollection.count > 0 {
                    let word = wordCollection[0]
                    if let category = selectedCategory {
                        //adding a relationship between them
                        word.category = word.category?.adding(category) as NSSet?
                    }
                } else {
                    //if there is no such a word, add it to the database
                    let newWord = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context) as! Word
                    
                    newWord.spelling = input
                    if let category = selectedCategory {
                        //adding a relationship between them
                        newWord.category = newWord.category?.adding(category) as NSSet?
                    }
                }
            }
            
            delegate.saveContext() //save changes in database
        }
        
        //Return back to the view with categories
        self.navigationController?.popViewController(animated: true)
    }
    
    //React if AddCategory button was tapped
    @IBAction func buttonAddCategory(_ sender: UIButton) {
        createAlert() //show pop-up view where the user might add category
    }
    
    //Pop-up view for adding new category instance
    func createAlert() {
        
        let alert = UIAlertController(title: "Add category", message: "Use text field to enter new category", preferredStyle: UIAlertControllerStyle.alert)
        //add textField to the pop-up view
        alert.addTextField { (textField) in
            textField.text = "I'm here!"
        }
        //add action button to the pop-up view
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            
            let context = self.delegate.persistentContainer.viewContext //access to the database
            
            //check if user typed any text
        if (alert?.textFields![0].text!.characters.count)! < 21 {
            if let text = alert?.textFields![0].text {
                print(text.characters.count)
                
                if let existingCategory = self.searchEntityInContext(entity: "Category", in: context, input: text) as? [Category] {
                    if existingCategory.count > 0 {
                        print("Category already exists")
                    } else {
                        //if category does not exist, add it to the database
                        self.addNewInstance(text, forEntity: "Category")
                        //reload scroll with categories
                        self.getData()
                        self.pickerViewCategory.reloadAllComponents()
                    }
                    
                    
                    alert?.dismiss(animated: true, completion: nil) //hide pop-up view
                }
                
            }
        }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //Check if entity exists in database
    func isEntityNotInCoreData(entity: String) -> Bool {
        
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.fetchLimit = 1
        var isEmpty = false
        do{
            let count = try context.count(for: request)
            if(count == 0) {
                isEmpty = true
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return isEmpty
    }
    
    
    //check-function in case of existence of the word
    func searchEntityInContext(entity: String, in context: NSManagedObjectContext, input: String) -> [Any]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.predicate = NSPredicate(format: "spelling = %@", input)
    
        do {
            return try(context.fetch(request))
        }
        catch let err {
            print("\(err.localizedDescription)")
        }
        return nil
    }
    
    //Add new instance of Category
    func addNewInstance(_ spelling : String, forEntity entity: String) {
        
        let context = delegate.persistentContainer.viewContext
        let instance = NSEntityDescription.insertNewObject(forEntityName: entity, into: context) as! Category
        instance.spelling = spelling
        delegate.saveContext()
    }
}
