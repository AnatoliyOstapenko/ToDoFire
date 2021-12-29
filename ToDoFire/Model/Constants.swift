//
//  Constants.swift
//  ToDoFire
//
//  Created by MacBook on 19.12.2021.
//

import Foundation
import UIKit

class Constants {
    static let identifier = "Cell"
    static let storyboardIdentifier = "ToDoTasks"
}


class Alert {
    // patern for custom alerts
    static func customAlert(_ textAlert: String, _ viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: "\(textAlert)", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okButton)
        viewController.present(alert, animated: true, completion: nil)
    }

}
