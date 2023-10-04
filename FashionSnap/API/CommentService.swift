//
//  CommentService.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 9/19/23.
//

import Firebase

class CommentService {
    
    static func uploadComment(comment: String, postId: String, user: User, completion: @escaping(FireStoreCompletion)) {
        
        let data: [String: Any] = ["uid": user.uid,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date()),
                                   "userName": user.username,
                                   "profileImageUrl": user.profileImageURL]
        
        COLLECTION_POSTS.document(postId).collection("comments").addDocument(data: data, completion: completion)
        
    }
    
    
    static func fetchComment(forPost postId: String, completion: @escaping([Comment]) -> Void) {
        var comments = [Comment]()
        let query = COLLECTION_POSTS.document(postId).collection("comments")
            .order(by: "timestamp", descending: true)
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    comments.append(comment)
                }
            })
            
            completion(comments)
        }
    }
}
