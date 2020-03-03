//
//  ProfileViewController.swift
//  Firebase-Auth
//
//  Created by Cameron Rivera on 3/1/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    // Outlets
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    private var currentUser: User
    private var imagePicker = UIImagePickerController()
    private var selectedImage: UIImage
    
    // Initializers
    init?(_ coder: NSCoder, _ user: User){
        currentUser = user
        selectedImage = UIImage(systemName: "moon")!
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp(){
        navigationItem.title = "Profile Details"
        displayNameTextField.text = currentUser.displayName
        phoneTextField.text = currentUser.phoneNumber
        emailTextField.text = currentUser.email
        imagePicker.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        displayNameTextField.delegate = self
    }
    
    @IBAction func commitChangesButtonPressed(_ sender: UIBarButtonItem){
        guard let url = URL(string: "https://fastly.4sqi.net/img/general/500/212169387_C2-Wh9iB-a9yFzkkMFUuT3RsxV7Rna5lQWhqCNs0Bds.jpg") else {
            print("Bad url String")
            return
        }
        let mutableUserData = currentUser.createProfileChangeRequest()
        if let name = displayNameTextField.text, !name.isEmpty{
            mutableUserData.displayName = name
            mutableUserData.photoURL = url
        }
        
        
//        if let phone = phoneTextField.text, !phone.isEmpty{
//            currentUser.updatePhoneNumber(phoneCredential) { [weak self] error in
//                if let error = error{
//                    self?.showAlert("Update Error", "Could not update phone Number: \(error)")
//                } else {
//                    print("Phone number updated")
//                }
//            }
//        }
        if let email = emailTextField.text, !email.isEmpty{
            currentUser.updateEmail(to: email) { [weak self] error in
                if let error = error {
                    self?.showAlert("Update Error", "Could not successfully update email address: \(error)")
                } else {
                    print("Email updated")
                }
            }
        }
        
        mutableUserData.commitChanges { [weak self] error in
            if let error = error {
                self?.showAlert("Error", "Could not commit changes to profile: \(error).")
            }else {
                self?.showAlert("Success", "Changes to profile saved.")
            }
        }
    }
    
    @IBAction func updateProfileImageButtonPressed(_ sender: UIButton){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [unowned self] alertAction in
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true)
        }
        
        let gallery = UIAlertAction(title: "Gallery", style: .default) { [unowned self] alertAction in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker,animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alertController.addAction(cameraAction)
        }
        alertController.addAction(gallery)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    @IBAction func deleteAccountPressed(_ sender: UIButton){
        currentUser.delete { [weak self] error in
            if let error = error{
                self?.showAlert("Deletion Error", "Encountered an error while trying to delete account: \(error)")
            } else {
                self?.showAlert("Account Deleted", "Your account has been successfully deleted.", completion: { action -> (Void) in
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        }
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("Selected image not found.")
            return
        }
        profilePictureImageView.image = image
        dismiss(animated: true)
    }
}

extension ProfileViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
