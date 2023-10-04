//
//  NotificationService.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 9/25/23.
//

import Firebase

class NotificationService {
    
    static func uploadNotification(toUid uid: String,
                                   fromUser: User,
                                   type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard  uid != currentUid else { return }
        
        let documentReference = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "uid": fromUser.uid,
                                   "type": type.rawValue,
                                   "id": documentReference.documentID,
                                   "userProfileImageUrl":fromUser.profileImageURL,
                                   "userName": fromUser.username]
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
            
        }
        
        documentReference.setData(data)
    
    }
    
    static func fetchNotification(completion: @escaping([Notification]) -> Void ){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").order(by: "timestamp", descending: true)
        
            query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let notifications = documents.map( { Notification(dictionary: $0.data()) })
            completion(notifications)
        }
    }
}
