//
//  ViewController.swift
//  TaskMe
//
//  Created by Юлия Караневская on 7.08.21.
//

import UIKit
import RealmSwift

class SectionViewController: UIViewController {
   
    let realm = try! Realm()
    
    var sectionList: Results<SectionModel>?
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSection))
        
        tableView.delegate = self
        tableView.dataSource = self

        loadSections()


    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
    //CRUD - Create realm
     func save(section: SectionModel) {
        do {
            try realm.write {
                realm.add(section)
                
            }
        } catch {
            print("Error arose while saving section \(error)")
        }
        
        tableView.reloadData()
    }
    
    //CRUD - Read realm
    private func loadSections() {
        
        sectionList = realm.objects(SectionModel.self)
        
        tableView.reloadData()
        
    }
    
    @objc func addSection() {
        
        let textField = UITextField()
        
        let alert = UIAlertController(title: "New category is...", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            let newSection = SectionModel()
           
            newSection.name = textField.text!
            
            self.save(section: newSection)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "add new section"
            
        }
        present(alert, animated: true)
        
    }
    

 
}

//MARK: - TableView Datasource Methods
extension SectionViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sectionList?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = sectionList?[indexPath.row].name ?? "No section added"
                
        return cell
    }
}

//MARK: - TableView Delegate Methods
extension SectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let controller = TaskListViewController()
        navigationController?.pushViewController(controller, animated: true)

        if let indexPath = tableView.indexPathForSelectedRow {
            controller.chosenSection = sectionList?[indexPath.row]
        }
    }
    
    //add delete method
}



