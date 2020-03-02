//
//  UIViewController+Extensions.swift
//  Firebase-Auth
//
//  Created by Cameron Rivera on 3/1/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

extension UIViewController{
    func showAlert(_ title: String, _ message: String, completion: ((UIAlertAction) -> (Void))? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
