//
//  TodoListViewController.swift
//  Todo Realm
//
//  Created by Konstantin on 17.05.2022.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TodoListViewController: SwipeTableViewController {
    
    private var realm = try! Realm()
    
    private var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add todo list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new element", style: .default) { [weak self] action in
            guard let self = self else { return }
            
            guard let text = alert.textFields?.first?.text else { return }
            guard let selectedCategory = self.selectedCategory else { return }
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = text
                    newItem.dateCreated = Date()
                    selectedCategory.items.append(newItem)
                }
            } catch {
                print("Error saving new items, \(error)")
            }
            self.tableView.reloadData()
        }
        alert.addTextField { $0.placeholder = "Create new item" }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        guard let item = todoItems?[indexPath.row] else { return }
        deleteItem(item: item)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if let model = todoItems?[indexPath.row] {
            content.text = model.title
            
            cell.accessoryType = model.done ? .checkmark : .none
        }

        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        guard let item = todoItems?[indexPath.row] else { return }
        
        doneTogle(item: item)

        tableView.deselectRow(at: indexPath, animated: true)
    }

}



// MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else { return }
        
        todoItems = todoItems?
            .filter("title CONTAINS[cd] %@", text)
            .sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
           
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchBar.text?.count == 0 else { return }
        loadItems()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}

// MARK: - Model Manupulation Method

extension TodoListViewController {
    
    private func deleteItem(item: Item) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Error delete, \(error)")
        }
    }
    
    private func doneTogle(item: Item) {
        do {
            try realm.write {
                item.done.toggle()
            }
        } catch {
            print("Error saving done status, \(error)")
        }
        tableView.reloadData()
    }
    
    private func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}
