//
//  Comment.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 9/19/23.
//

import Firebase

struct Comment {
    let uid: String
    let profileImageUrl: String
    let username: String
    let timestamp: Timestamp
    let commentText: String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl =  dictionary["profileImageUrl"] as? String ?? ""
        self.username =  dictionary["userName"] as? String ?? ""
        self.timestamp =  dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.commentText =  dictionary["comment"] as? String ?? ""
    }
}
