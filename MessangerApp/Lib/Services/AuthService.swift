//
//  AuthService.swift
//  MessangerApp
//
//  Created by andy on 03.11.2021.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
}

class AuthService {
    private let auth = Auth.auth()

    func register(email: String?, password: String?, confirmPassword: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
