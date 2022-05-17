//
//  TodoListViewController.swift
//  Todo Realm
//
//  Created by Konstantin on 17.05.2022.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    private var todoListArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        todoListArray = ["apple", "peach"]
        
    }
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add todo list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new element", style: .default) { [weak self] action in
            guard let self = self else { return }
            
            guard let text = alert.textFields?.first?.text else { return }
            
            self.todoListArray.append(text)
            
            self.tableView.reloadData()
        }
        alert.addTextField { $0.placeholder = "Create new item" }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        let model = todoListArray[indexPath.row]
        content.text = model

        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        cell.isSelected = false
    }

}

// MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
}
