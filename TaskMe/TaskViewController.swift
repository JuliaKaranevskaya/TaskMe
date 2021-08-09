//
//  TaskViewController.swift
//  TaskMe
//
//  Created by Юлия Караневская on 7.08.21.
//


import UIKit
import RealmSwift

class TaskListViewController: UIViewController {
    
    let realm = try! Realm()

    let searchController: UISearchController = {
        let searchController = UISearchController()
        return searchController
    }()
    
    var taskList: Results<TaskModel>?
    
    var chosenSection: SectionModel? {
        didSet {
            //load tasks
            loadTasks()
        }
    }
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationController?.navigationBar.barTintColor = .cyan
        
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let newTask = TaskModel()
        newTask.name = "hello"
        
    
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
    private func loadTasks() {
        
        taskList = chosenSection?.tasks.sorted(byKeyPath: "name", ascending: true)
        
        tableView.reloadData()
    }
    
    @objc func addTask() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New task is...", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            
            guard let strongSelf = self else { return }
            
            if let currentSection = strongSelf.chosenSection {
                do {
                    try strongSelf.realm.write {
                        let newTask = TaskModel()
                        newTask.name = textField.text ?? "any"
                        newTask.creationDate = Date()
                        currentSection.tasks.append(newTask)
                    }
                } catch {
                    print("Error while savind data: \(error)")
                }
               
            }
            
            strongSelf.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "enter new task"
            textField = alertTextField
        }
        present(alert, animated: true)
        
    }


}

//MARK: - SearchBar Delegate Methods
extension TaskListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        taskList = taskList?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "creationDate", ascending: true)
        
        tableView.reloadData()
        searchBar.text = ""
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        
        if searchBar.text?.count == 0 {
            loadTasks()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

//MARK: - Updating search results
extension TaskListViewController: UISearchResultsUpdating {
   
    func updateSearchResults(for searchController: UISearchController) {
        //it's updating search results in real time
    }
}

//MARK: - TableView Datasource Methods
extension TaskListViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskList?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let task = taskList?[indexPath.row] {
            
            cell.textLabel?.text = task.name
           
            if task.completed == true {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            cell.textLabel?.text = "No tasks"
        }
        
    
        return cell
    }
}

//MARK: - TableView Delegate Methods
extension TaskListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let task = taskList?[indexPath.row] {
            do {
                try realm.write {
                    task.completed = !task.completed
                }
            } catch {
                print("Error while saving task status: \(error)")
            }
        }
        
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
}

