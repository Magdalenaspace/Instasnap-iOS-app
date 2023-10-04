//
//  CustomButton.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 7/19/23.
//

import UIKit

class CustomButton: UIButton {
    init(placeholder: String) {
        super.init(frame: .zero)
        
        setTitle(placeholder, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1).withAlphaComponent(0.8)
        layer.cornerRadius = 5
        setHeight(50)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        isEnabled = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
