//
//  UIViewController+Extensions.swift
//  Firebase-Auth
//
//  Created by Cameron Rivera on 3/1/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import FirebaseAuth

extension UIViewController{
    func showAlert(_ title: String, _ message: String, completion: ((UIAlertAction) -> (Void))? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    public static func resetWindow(with rootViewController: UIViewController){
        guard let scene = UIApplication.shared.connectedScenes.first,
            let sceneDelegate = scene.delegate as? SceneDelegate, let window = sceneDelegate.window else {
                fatalError("Could not reset window rootViewController.")
        }
        window.rootViewController = rootViewController
    }
    
    public static func showViewController(storyboardName: String, viewControllerId: String){
        let newStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = newStoryboard.instantiateViewController(identifier: viewControllerId)
        resetWindow(with: vc)
    }
}
