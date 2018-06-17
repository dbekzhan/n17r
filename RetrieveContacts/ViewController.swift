//
//  ViewController.swift
//  Contacts_LBTA
//
//  Created by Dimash Bekzhan on 1/25/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit
import Contacts
// Conform to a protocol for delegation -data sent from custom cell
protocol didSelectElementDelegate {
    func didSelectItem(element: ContactCell)
}

//- async tableview reload
// -why favoritable pictures are shifting after beinf reopened


class ViewController: UITableViewController {
    
    let cellId = "cellId"
    var showIndexPath = false
//    let aNames = ["Asuma", "Akatsuki"]
//    let bNames = ["Boruto", "Boruto's dad", "Byakugan"]
//    let cNames = ["Choji", "Carl"]
    
    // Two dimensional array for sections and rows in table view
    // Contact - class defined in Model, i.e. ExpandableSection file
    
    var names = [ExpandableSection]()
    
    //    lazy var names = [
    //        ExpandableSection(isExpanded: true, names: aNames.map {FavoritableContact(name: $0)}),
    //        ExpandableSection(isExpanded: true, names: bNames.map {FavoritableContact(name: $0)}),
    //        ExpandableSection(isExpanded: true, names: cNames.map {FavoritableContact(name: $0)})
    //    ]
    
    
    //!!! Something with async reload of tableview -- look for information
    private func fetchContacts() {
        
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Error occured", err)
                return
            }
            
            // accessing contacts
            if granted {
                print("granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                
                do {
                    var favoratibleContacts = [FavoritableContact]()
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        
                        
                        favoratibleContacts.append(FavoritableContact(contact: contact))
                    })
                    
                    let groupedContacts = Dictionary(grouping: favoratibleContacts, by: { (contact) -> Character in
                        return contact.contact.givenName.first!
                    })
                
                    
                    groupedContacts.keys.sorted().forEach({ (key) in
                        
                        self.names.append(ExpandableSection(isExpanded: true, contacts: groupedContacts[key]!))
                    })

                } catch let err { print(err)}
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        
        // navigationItem embraces title, left and right button for each viewController pushed into navigationController
        navigationItem.title = "Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show indexPath", style: .plain, target: self, action: #selector(handleShowBarButton))
        //        navigationItem.rightBarButtonItem?.tintColor = .orange
        // navigationBar handles navigationItems of each viewController pushed + some barButtons
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 171/255, blue: 132/255, alpha: 0.5)
        // Register custom class for cells
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Table View Configuration
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Close", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .yellow
            
            button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
            button.tag = section
            return button
        }()
        return button
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36.0
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !names[section].isExpanded {
            return 0
        } else {
            return names[section].contacts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        
        let favoritableName = self.names[indexPath.section].contacts[indexPath.row]
        cell.textLabel?.text = favoritableName.contact.givenName + " " + favoritableName.contact.familyName
        cell.detailTextLabel?.text = favoritableName.contact.phoneNumbers.first?.value.stringValue
        cell.delegate = self
        
        if showIndexPath {
            cell.textLabel?.text = "\(favoritableName.contact.givenName + " " + favoritableName.contact.familyName) Section: \(indexPath.section) Row: \(indexPath.row)"
        }
        
        
        return cell
    }
    
    //MARK:- Target Actions
    
    @objc func handleShowBarButton() {
        var indexPathsToReload = [IndexPath]()
        
        for section in names.indices {
            for row in names[section].contacts.indices {
                if names[section].isExpanded {
                    let indexPath = IndexPath(row: row, section: section)
                    indexPathsToReload.append(indexPath)
                }
            }
            
            showIndexPath = !showIndexPath
            let style = showIndexPath ? UITableViewRowAnimation.right : .left
            
            tableView.reloadRows(at: indexPathsToReload, with: style)
        }
    }
    
    @objc func handleCloseButton(sender: UIButton) {
        let section = sender.tag
        var indexPaths = [IndexPath]()
        for index in names[section].contacts.indices {
            let indexPath = IndexPath(row: index, section: section)
            indexPaths.append(indexPath)
        }
        let toBeClosed = names[section].isExpanded
        names[section].isExpanded = !toBeClosed
        
        sender.setTitle(toBeClosed ? "Open" : "Close", for: .normal)
        if toBeClosed {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
}

// find the reason of shifting selected items
extension ViewController: didSelectElementDelegate {
    func didSelectItem(element: ContactCell) {
        guard let indexPath = tableView.indexPath(for: element) else { return }
        let contact = names[indexPath.section].contacts[indexPath.row]
        contact.isFavorite = !contact.isFavorite
        // Accessory view - subview of a cell located at the right side -used for favorable image
        element.accessoryView?.tintColor = contact.isFavorite ? .blue : .lightGray
    }
}


