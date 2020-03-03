//
//  LoginWithPhoneController.swift
//  Firebase-Auth
//
//  Created by Cameron Rivera on 3/3/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginWithPhoneController: UIViewController {
    
    @IBOutlet weak var phoneNumTextField: UITextField!
    private var agreedToText = false
    
    let alertText = """
    Using phone notifications means you agree to receiving a text message from this service, which may or may not incur some charge depending on your service. Do you accept these terms?
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func commitChangesButtonPressed(_ sender: UIButton){
        guard let phoneNumber = phoneNumTextField.text, !phoneNumber.isEmpty, phoneNumber.count > 7, areYouANumber(phoneNumber) else {
            showAlert("Error", "Phone number is not correctly formatted.")
            return
        }
        if !agreedToText {
            let alertController = UIAlertController(title: "Notification", message: alertText, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) {
                [weak self] action in
                
                self?.agreedToText = true
                
                UserDefaultsHandler.setObject(phoneNumber)
                
                self?.verify()
            }
            
            let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            present(alertController, animated: true)
        } else {
            verify()
        }
    }
    
    private func areYouANumber(_ phoneNum: String) -> Bool{
        var containsPlus = false
        for element in phoneNum{
            if element == "+"{
                containsPlus = true
            }
            
            if !element.isWholeNumber && !element.isWhitespace && element != "+"{
                return false
            }
        }
        
        if !containsPlus{
            return false
        }
        return true
    }
    
    private func promptUserForVerificationCode(){
        let verificationCodeAlert = UIAlertController(title: "Enter Code", message: "Enter the code from the text message.", preferredStyle: .alert)
            verificationCodeAlert.addTextField()
        guard let textField = verificationCodeAlert.textFields?[0], let textFieldText = textField.text, !textFieldText.isEmpty else {
            return
        }
        
        let submitAlertAction = UIAlertAction(title: "Submit", style: .default, handler: { [weak self](alertAction) in
            FirebaseData.verificationCode = textFieldText
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaultsHandler.getVerification(), verificationCode: FirebaseData.verificationCode)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    self?.showAlert("Error", "Could not verify credentials: \(error)")
                }else if let result = authResult{
                    if let profileVC = self?.storyboard?.instantiateViewController(identifier: "ProfileViewController", creator: { coder in
                        return ProfileViewController(coder, result.user)
                    }){
                        self?.navigationController?.pushViewController(profileVC, animated: true)
                    }
                }
            }
        })
        verificationCodeAlert.addAction(submitAlertAction)
        present(verificationCodeAlert, animated: true, completion: nil)
    }
    
    private func verify(){
        PhoneAuthProvider.provider().verifyPhoneNumber(UserDefaultsHandler.getPhoneNum(), uiDelegate: nil) { [weak self] (verificationID, error) in
            if let error = error {
                self?.showAlert("Error", "Could not verify phone number: \(error)")
                return
            }else if let verification = verificationID {
                UserDefaultsHandler.setVerification(verification)
            }
        }
        promptUserForVerificationCode()
    }
}
