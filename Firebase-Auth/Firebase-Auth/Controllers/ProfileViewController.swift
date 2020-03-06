//
//  ProfileViewController.swift
//  Firebase-Auth
//
//  Created by Cameron Rivera on 3/1/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import Kingfisher
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
    private var storageHandler = FirebaseStorageHandler()
    
    // Initializers
    init?(_ coder: NSCoder, _ user: User){
        currentUser = user
        selectedImage = UIImage(systemName: "moon")!
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        currentUser = Auth.auth().currentUser!
        selectedImage = UIImage(systemName: "moon")!
        super.init(coder: coder)
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
        profilePictureImageView.kf.setImage(with: currentUser.photoURL)
        imagePicker.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        displayNameTextField.delegate = self
    }
    
    @IBAction func commitChangesButtonPressed(_ sender: UIBarButtonItem){
        
        let mutableUserData = currentUser.createProfileChangeRequest()
        
        if let name = displayNameTextField.text, !name.isEmpty{
            mutableUserData.displayName = name
        }
        
        if let image = profilePictureImageView.image {
            
            let resizedImage = UIImage.resizeImage(originalImage: image, rect: self.profilePictureImageView.bounds)
            
            self.storageHandler.updatePhoto(userId: self.currentUser.uid, image: resizedImage) { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.showAlert("Error Retrieving URL", "\(error.localizedDescription)")
                case .success(let url):
                    mutableUserData.photoURL = url
                    
                    mutableUserData.commitChanges { [weak self] error in
                        if let error = error {
                            self?.showAlert("Error", "Could not commit changes to profile: \(error).")
                        }else {
                            self?.showAlert("Success", "Changes to profile saved.")
                        }
                    }
                }
            }
        }
        
//        if let phone = phoneTextField.text, !phone.isEmpty{
//            let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaultsHandler.getVerification(), verificationCode: FirebaseData.verificationCode)
//            currentUser.updatePhoneNumber(credential) { [weak self] error in
//                if let error = error{
//                    self?.showAlert("Update Error", "Could not update phone Number: \(error)")
//                } else {
//                    print("Phone number updated")
//                }
//            }
//        }
        
        if let email = emailTextField.text, !email.isEmpty{
            
            self.currentUser.updateEmail(to: email) { [weak self] error in
                if let error = error {
                    self?.showAlert("Update Error", "Could not successfully update email address: \(error)")
                } else {
                    print("Email updated")
                }
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
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem){
        do {
            try Auth.auth().signOut()
            UIViewController.showViewController(storyboardName: "Main", viewControllerId: "LoginNavigationController")
        } catch {
            showAlert("Sign Out Error", "\(error.localizedDescription)")
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
