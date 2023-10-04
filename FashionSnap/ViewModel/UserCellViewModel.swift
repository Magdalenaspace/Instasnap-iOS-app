//
//  UserCellViewModel.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 9/12/23.
//

import Foundation

class UserCellViewModel {
    
    private let user: User
    
    var profileImageURL: URL? {
        return URL(string: user.profileImageURL)
    }
    
    var fullname: String {
        return user.fullname
    }
    
    var username: String {
        return user.username
    }
    
    init(user: User) {
        self.user = user
    }
}

