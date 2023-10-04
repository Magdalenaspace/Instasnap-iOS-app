//
//  AuthService.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 7/19/23.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let userName: String?
    let profileImage: UIImage
}

struct AuthService {
    static func logUserIn(withEmail email: String, password: String , completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping(Error?) -> Void) {
        //        print("DEBUG: Credentials are \(credentials)")
        
        ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                
                if let error = error {
                    print("DEBUG: Failed to register user with\(error.localizedDescription)")
                    //if we have a error we return and do go any further
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                //upload data to Firebase
                let data: [String: Any] = ["uid": uid,
                                           "fullname": credentials.fullName,
                                           "username": credentials.userName,
                                           "email": credentials.email,
                                           "password": credentials.password,
                                           "profileImageURL": imageUrl]
                //upload data to FireStoreDB
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
                
            }
        }
        
    }
    
    static func resetPassword(withEmail email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
}
