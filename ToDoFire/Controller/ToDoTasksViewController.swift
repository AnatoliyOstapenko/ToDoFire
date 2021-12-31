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
    
    var tasks: [Task] = []
    //var collection: String?
    
    //let collection = Auth.auth().currentUser?.email
    
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoTableView.dataSource = self
        toDoTableView.delegate = self
        
        // change bar buttons color to white
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        print(collection())
        readData()
        
        
    }
    // Read data from Firebase
    func readData() {
        
        //guard let coll = collection else { return }
  
        db.collection(collection()).order(by: "dateField").addSnapshotListener() { (querySnapshot, error) in
            
            self.tasks = [] // Avoid duplicate data in array
            
            guard error == nil, let documents = querySnapshot?.documents else { return }
            
            for doc in documents {
                let data = doc.data()
                // Retrieve id, user and text from data in Firebase fields
                guard let text = data["bodyField"] as? String, let user = data["senderField"] as? String, let id = data["idField"] as? String else { return }
                
                
                // Set data in array to show it on TableView
                let item = Task(id: id, user: user, newTask: text)
                self.tasks.append(item)
                
                DispatchQueue.main.async {
                    self.toDoTableView.reloadData()
                }
                
            }
        }
    }
    // Method to retrieve of user email from Firebase
    func collection() -> String {

        if let collection = Auth.auth().currentUser?.email {
            return collection
        } else {
            Alert.customAlert("Error with retrieving user email", self)
            return "Error with user email"
        }
        
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Create alert and action buttons
        let alert = UIAlertController(title: "New Task", message: "Add a new task", preferredStyle: .alert)
        
        // Add text field to alert
        alert.addTextField()
        
        let saveButton = UIAlertAction(title: "SAVE", style: .default) { (action) in
            // Unwraping text from textfield and check for empty string
            // Check for current user is admitted
           
            guard let updatedText = alert.textFields?.first?.text, let userEmail = Auth.auth().currentUser?.email else {
                
                Alert.customAlert("Don't leave task field empty, set task name", self)
                return }
            
            // Actions when button pressed
            // Save data to Firestore
            // newTask - collection name in Firestore, senderField and bodyField are field names in Firestore
            
            // Create ID due to assign ID to document name - it's important to have ability to delete data later
            let id = self.db.collection(self.collection()).document().documentID
            print("id reference : \(id)")
            
//            self.collection = userEmail // set collection name by user email
//            print("created a new collection \(userEmail)")
            
            // Create new elements in Firebase
            self.db.collection(self.collection()).document(id).setData([
                
                "idField": id,
                "senderField": userEmail,
                "bodyField": updatedText,
                "dateField": Date().timeIntervalSince1970 // ordering tasks
                
            ]) { (error) in
                guard error != nil else { return }
                Alert.customAlert("There was a issue with saving data to Firestore", self)
            }
            
            
            print("It has been saved: \(updatedText) in collection \(userEmail)")
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
            Alert.customAlert("Error signing out \(signOutError)", self)
        }
    }
}
// MARK: - Data Source Method
extension ToDoTasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath)
     
        cell.backgroundColor = .clear // clear row background
        cell.textLabel?.textColor = .white // set white color to text row
        
        cell.textLabel?.text = tasks[indexPath.row].newTask
        return cell
    }
    
    
}
// MARK: - Table View Delegate Method

extension ToDoTasksViewController: UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {

            // Delete data from Firebase
            db.collection(collection()).document(tasks[indexPath.row].id).delete() { error in
                if let error = error {
                    print("Error removing document: \(error)")
                    Alert.customAlert("Error removing task", self)
                } else {
                    print("Document successfully removed!")
                    // pop up custom alert
                    Alert.customAlert("Task successfuly removed", self)
                }
            }
            
            tableView.reloadData()
        }
    }
}
