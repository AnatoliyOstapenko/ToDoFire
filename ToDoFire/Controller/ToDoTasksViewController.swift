//
//  ToDoTasksViewController.swift
//  ToDoFire
//
//  Created by MacBook on 19.12.2021.
//

import UIKit
import Firebase

class ToDoTasksViewController: UIViewController {
    
    let db = Firestore.firestore() // invoke Firestore
    
    var task: [Task] = [
        
        Task(user: "mail@mail.com", newTask: "Hello there!"),
        Task(user: "george@mail.com", newTask: "Goodbuy everybody"),
        Task(user: "madlene@mail.com", newTask: "Ok")
        
        
    ]
    
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoTableView.dataSource = self
        toDoTableView.delegate = self
        
        // change bar buttons color to white
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white

        
    }
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Create alert and action buttons
        let alert = UIAlertController(title: "New Task", message: "Add a new task", preferredStyle: .alert)
        
        // Add text field to alert
        alert.addTextField()
        
        let saveButton = UIAlertAction(title: "SAVE", style: .default) { (action) in
            // Unwraping text from textfield and check for empty string
            // Check for current user is admitted
            guard let textField = alert.textFields?.first?.text, textField != "", let id = Auth.auth().currentUser?.email else {
                
                return
            }
            // Actions when button pressed
            self.db.collection("newTask").addDocument(data: <#T##[String : Any]#>, completion: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
            
            
            print("It has been saved \(textField) and \(id)")
        }
        let cancelButton = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
         
        // Sign out user
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            // dismiss current screen and go back to previous VC
            self.dismiss(animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
// MARK: - Data Source Method
extension ToDoTasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath)
        
        
        cell.backgroundColor = .clear // clear row background
        cell.textLabel?.textColor = .white // set white color to text row
        
        cell.textLabel?.text = task[indexPath.row].newTask
        
        
        return cell
    }
    
    
}
