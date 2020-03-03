//
//  ViewController.swift
//  Firebase-Auth
//
//  Created by Cameron Rivera on 3/1/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Properties

    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setUp(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: Actions
    @IBAction func signInButtonPressed(_ sender: UIButton){
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty else {
                showAlert("Authentication Error", "One or more fields is missing.")
                return
        }
        FirebaseHandler.shared.logInExistingUser(email, password) {[weak self] result in
            switch result {
            case .failure(let error):
                self?.showAlert("Authentication Error", "Encountered Error while attempting to authenticate: \(error)")
            case .success(let user):
                if let profileVC = self?.storyboard?.instantiateViewController(identifier: "ProfileViewController", creator: { creator in
                    ProfileViewController(creator, user)
                }){
                    self?.navigationController?.pushViewController(profileVC, animated: true)
                }
            }
        }
    }
    
    @IBAction func createdNewAccountButtonPressed(_ sender: UIButton){
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty else {
                showAlert("Authentication Error", "One or more fields is missing.")
                return
        }
        
        FirebaseHandler.shared.createNewAccount(email, password) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showAlert("Authentication Error", "Encountered an error while attempting to create a new account: \(error)")
            case .success(let user):
                if let profileVC = self?.storyboard?.instantiateViewController(identifier: "ProfileViewController", creator: { creator in
                    ProfileViewController(creator, user)
                }){
                    self?.navigationController?.pushViewController(profileVC, animated: true)
                }
            }
        }
    }

    @IBAction func loginInWithPhoneNumberPressed(_ sender: UIButton){
        guard let phoneVC = storyboard?.instantiateViewController(identifier: "LoginWithPhoneController") as? LoginWithPhoneController else{
            fatalError("Could not create instance of LoginWithPhoneController.")
        }
        navigationController?.pushViewController(phoneVC, animated: true)
    }

}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

