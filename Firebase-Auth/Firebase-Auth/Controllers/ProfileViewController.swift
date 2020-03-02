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

    private var currentUser: User
    
    // Initializers
    init?(_ coder: NSCoder, _ user: User){
        currentUser = user
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
