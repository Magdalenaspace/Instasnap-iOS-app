//
//  UserService.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 9/5/23.
//
import Firebase

typealias FireStoreCompletion = (Error?) -> Void

struct UserService {
    // 1 user with id
    static func fetchUser(withUid uid: String ,completion: @escaping (User) -> Void) {
        // Use 1 user
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else {
                return
            }
            
            let user = User(dictionary: dictionary)
            completion(user)
            //completion handler is out there in profile feed page setchng
        }
    }
    
    // fetch all users (get)
    static func fetchUsers(completion: @escaping ([User]) -> Void) {
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            //            snapshot.documents.forEach { document in
            //                print("DEBUG:🐞\(document.data())")
            //            }
            //$0 represents each
            let users = snapshot.documents.map({ User(dictionary: $0.data()) })
            completion(users)
        }
    }
    
    static func follow(uid: String, completion: @escaping(FireStoreCompletion)){
        //checks if the current user is logged in
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        //creates a new document in the COLLECTION_FOLLOWINGS collection for the current user. The document is added to the user-following subcollection. The document contains an empty dictionary.
        COLLECTION_FOLLOWINGS.document(currentUid).collection("user-following").document(uid).setData([:]){ error in
            // creates a new document in the COLLECTION_FOLLOWERS collection for the user that is being followed.
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:],completion: completion)
            
        }
    }
    
    static func unfollow(uid: String, completion: @escaping(FireStoreCompletion)){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWINGS.document(currentUid).collection("user-following").document(uid).delete { error in
            
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
    //check id, change button
    static func ifUserIsFollowedCheck(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWINGS.document(currentUid).collection("user-following").document(uid).getDocument {
            (snapshot,error) in
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
        
    }
    
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, _ ) in
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWINGS.document(uid).collection("user-following").getDocuments { (snapshot, _ ) in
                let followings = snapshot?.documents.count ?? 0
                
                COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, _ in
                    let posts = snapshot?.documents.count ?? 0
                    completion(UserStats(followers: followers, followings: followings, posts: posts))
                }
                
            }
        }
    }
    
}




