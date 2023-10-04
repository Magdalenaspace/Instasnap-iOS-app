//
//  User.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 9/5/23.
//

import Foundation
import Firebase

struct User {
    let email: String
    let fullname: String
    let profileImageURL: String
    let uid: String
    let username: String
    
    var isFollowed = false
    var stats: UserStats!
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid}
    
    //custom init to pharse the dictionary into the user obj
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.stats = UserStats(followers: 0, followings: 0, posts: 0)
    }
}

struct UserStats {
    let followers: Int
    let followings: Int
    let posts: Int
}






// -MARK: Decodable
//import Foundation
//
//struct User: Decodable {
//    let email: String
//    let fullname: String
//    let profileImageURL: String
//    let uid: String
//    let username: String
//
//    // Define the keys used in the JSON and associate them with struct properties
//    enum CodingKeys: String, CodingKey {
//        case email
//        case fullname
//        case profileImageURL = "profile_image_url"
//        case uid
//        case username
//    }
//
//    // Define a custom initializer that utilizes the `decode` method
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
//        self.fullname = try container.decodeIfPresent(String.self, forKey: .fullname) ?? ""
//        self.profileImageURL = try container.decodeIfPresent(String.self, forKey: .profileImageURL) ?? ""
//        self.uid = try container.decodeIfPresent(String.self, forKey: .uid) ?? ""
//        self.username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
//    }
//}
