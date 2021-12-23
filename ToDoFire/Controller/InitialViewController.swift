//
//  ViewController.swift
//  ToDoFire
//
//  Created by MacBook on 18.12.2021.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 25.0 // add corner radius for login button
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        alarmLabel.alpha = 0 // hide label
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        // Use the code when you have separate storyboards!!!
        // Switch from Main to ToDoTasks storyboard
        let vc = UIStoryboard(name: "ToDoTasks", bundle: nil).instantiateViewController(withIdentifier: Constants.storyboardIdentifier)
        
        vc.modalPresentationStyle = .fullScreen // open full screen
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            
            warningText("Email or password is incorrect")
            
            
            return }
        
        
    }
    func warningText(_ text: String) {
        alarmLabel.text = text
        
        // Animation manager
        UIView.animate(withDuration: 4, delay: 0, options: .autoreverse) { [weak self] in
            self?.alarmLabel.alpha = 1
        } completion: { (true) in
            self.alarmLabel.alpha = 0
        }

    }
    
    
}

// MARK:- TextField

extension InitialViewController: UITextFieldDelegate {
    
    // It happens when return button pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide keyboard
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        return true
    }
    
    
}

