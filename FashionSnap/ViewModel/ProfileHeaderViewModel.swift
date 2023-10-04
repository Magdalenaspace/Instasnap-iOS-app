//
//  ProfileHeaderViewModel.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 9/5/23.
//

import UIKit
import SDWebImage

struct ProfileHeaderViewModel {
    
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageURL: URL? {
        return URL(string: user.profileImageURL)
    }
    
    var followButtonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
         return user.isFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isCurrentUser ? .black : .white
    }
    
    var numberOfFollowers: NSAttributedString {
        return attributedStateText(value: user.stats.followers, label: "Followers")
    }
    
    var numberOfFollowings: NSAttributedString {
        return attributedStateText(value: user.stats.followings, label: "Following")
    }
    
    var numberOfPosts: NSAttributedString {
        return attributedStateText(value: user.stats.posts, label: "Posts")
    }
    
    init(user: User) {
        self.user = user
    }
    
    func attributedStateText(value: Int, label: String) -> NSAttributedString {
        //"\(value)\n" to have new line
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.gray ]))
    
        return attributedText
    }
}

