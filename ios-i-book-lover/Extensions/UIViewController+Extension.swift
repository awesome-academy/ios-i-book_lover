//
//  UIViewController+Extension.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/7/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

extension UIViewController {
    public static var className: String {
        return String(describing: self)
    }
        
    func showAlert(title: String? = Alerts.doneTitle,
                   message: String? = Alerts.doneMessage,
                   cancelTitle: String? = Alerts.cancelAction,
                   actionTitle: String? = Alerts.actionAction,
                   adjustTitle: String? = Alerts.adjustAction,
                   cancelHandler: ((UIAlertAction) -> Void)? = nil,
                   adjustHandler: ((UIAlertAction) -> Void)? = nil,
                   actionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        if actionHandler != nil {
            alert.addAction(UIAlertAction(title: adjustTitle, style: .default, handler: adjustHandler))
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: actionHandler))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTextField(title: String? = Alerts.setGoalTitle,
                                message: String? = Alerts.setGoalMessage,
                                actionTitle: String? = Alerts.actionAction,
                                cancelTitle: String? = Alerts.cancelAction,
                                inputPlaceholder: String? = "",
                                inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                                cancelHandler: ((UIAlertAction) -> Void)? = nil,
                                actionHandler: ((_ text: String?) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (_: UIAlertAction) in
            guard let textField = alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        present(alert, animated: true, completion: nil)
    }
}

