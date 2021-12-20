//
//  ViewController.swift
//  ToDoFire
//
//  Created by MacBook on 18.12.2021.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 25.0
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        // Use the code when you have separate storyboards!!!
        // Switch from Main to ToDoTasks storyboard
        let vc = UIStoryboard(name: "ToDoTasks", bundle: nil).instantiateViewController(withIdentifier: Constants.storyboardIdentifier)
        
        vc.modalPresentationStyle = .fullScreen // open full screen
        present(vc, animated: true, completion: nil)
        
    }
    
}

