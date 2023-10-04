//
//  AuthenticationViewModel.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 7/19/23.
//

import UIKit

protocol FormViewModel {
    func updateForm()
}
protocol AuthenticationViewModel {
    var isValid: Bool { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}


struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    //computed var -> returns boolean
    var isValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return isValid ?  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.8)
    }
    
    var buttonTitleColor: UIColor {
        return isValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct RegistrationViewModel: AuthenticationViewModel {
    
    var fullName: String?
    var username: String?
    var email: String?
    var password: String?
    
    var isValid: Bool {
        return fullName?.isEmpty == false && username?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return isValid ?  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.8)
    }
    
    var buttonTitleColor: UIColor {
        return isValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
    
}

struct ResetPasswordControllerViewModel: AuthenticationViewModel {
    var email: String?
    //computed var -> returns boolean
    var isValid: Bool {
        return email?.isEmpty == false 
    }
    
    var buttonBackgroundColor: UIColor {
        return isValid ?  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.8)
    }
    
    var buttonTitleColor: UIColor {
        return isValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}
