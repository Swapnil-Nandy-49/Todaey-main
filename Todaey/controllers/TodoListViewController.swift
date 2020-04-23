//
//  ViewController.swift
//  Todaey
//
//  Created by Swapnil Nandy on 23/4/20.
//  Copyright © 2020 Swapnil Nandy. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var ArrayList = [Item]()
   // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ok lets see \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        // Do any additional setup after loading the view.
        
      //  print(dataFilePath)

      //  loadItems()
        
//        let newItem = Item()
//        newItem.title = "Swapnil"
//        //newItem.done = true
//        ArrayList.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Swapni"
//        ArrayList.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Swapn"
//        ArrayList.append(newItem3)
//
//        let newItem4 = Item()
//        newItem4.title = "Swap"
//        ArrayList.append(newItem4)
//
//
//        if let items = UserDefaults.standard.array(forKey: "ArrayList") as? [Item]{
//            ArrayList = items
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = ArrayList[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
//
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(ArrayList[indexPath.row])
        
        //context.delete(ArrayList[indexPath.row])
       // ArrayList.remove(at: indexPath.row)
        
        ArrayList[indexPath.row].done = !ArrayList[indexPath.row].done
        
//        if ArrayList[indexPath.row].done == false{
//            ArrayList[indexPath.row].done = true
//        }else {
//            ArrayList[indexPath.row].done = false
//        }
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        saveItems()
        
            
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title:"Add new Todaey Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
    
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.ArrayList.append(newItem)
            
            //self.ArrayList.append(textField.text!)
            //self.defaults.set(self.ArrayList, forKey: "TodoListArray")
            
            self.saveItems()
            
            self.tableView.reloadData()
        }
        alert.addTextField { (alerttextField) in
            alerttextField.placeholder = "Create new Item"
            textField = alerttextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try context.save()
        }catch{
            print("Error saving Item \(error)")
        }
        
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(ArrayList)
//            try data.write(to: dataFilePath!)
//        }catch {
//            print("Error encoding data \(error)")
//        }
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
       
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
//        let compundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , predicate!])
//
//         request.predicate = compundPredicate
        do {
            ArrayList = try context.fetch(request)
        }catch{
            print("Error Loading Item \(error)")
        }
        
        tableView.reloadData()
        
//        if let data = try? Data(contentsOf: dataFilePath!){
//
//           let decoder = PropertyListDecoder()
//           do {
//            ArrayList = try decoder.decode([Item].self, from: data)
//               try data.write(to: dataFilePath!)
//           }catch {
//               print("Error encoding data \(error)")
//           }
//       }
 }
    
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
         request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        
//        do {
//            ArrayList = try context.fetch (request)
//        } catch {
//            print("Error fetching data from contetx \(error)")
//        }
        loadItems(with: request, predicate: predicate)
       // loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}



