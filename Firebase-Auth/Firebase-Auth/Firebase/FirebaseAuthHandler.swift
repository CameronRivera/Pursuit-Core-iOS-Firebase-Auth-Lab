//
//  FirebaseHandler.swift
//  Firebase-Auth
//
//  Created by Cameron Rivera on 3/1/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthHandler {
    static let shared = FirebaseAuthHandler()
    private let firebaseAuth: Auth
    
    private init(){
        firebaseAuth = Auth.auth()
    }
    
    func logInExistingUser(_ email: String, _ password: String, completion: @escaping (Result<User, Error>) -> ()) {
        firebaseAuth.signIn(withEmail: email, password: password) { (result, error) in
            if let user = result?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func createNewAccount(_ email: String, _ password: String, completion: @escaping (Result<User, Error>) -> ()) {
        firebaseAuth.createUser(withEmail: email, password: password) { (result, error) in
            if let user = result?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
