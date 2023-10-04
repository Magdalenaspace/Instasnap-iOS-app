//
//  UserCell.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 9/12/23.
//

import UIKit

class UserCell: UITableViewCell {
    
    //MARK: - Properties
    var viewModel: UserCellViewModel? {
        didSet {
            configure()
        }
    }
    //searchField
    
    
    //profileImageView
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = #imageLiteral(resourceName: "Screenshot 2023-07-06 at 5.05.20 PM")
        return iv
    }()
                            
    //userNameLabel
    private let userNameLabel: UILabel = {
        let unLabel = UILabel()
        unLabel.font = UIFont.boldSystemFont(ofSize: 16)
        unLabel.text = "Hi USERnAME"
        
        return unLabel
    }()
    
    //fullNameLabel
    private let fullNameLabel: UILabel = {
        let flLabel = UILabel()
        flLabel.font = UIFont.boldSystemFont(ofSize: 12)
        flLabel.text = "Hi FullNAme"
        flLabel.textColor = .gray
        return flLabel
    }()
    
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 50, width: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [userNameLabel, fullNameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 10
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configure(){
        guard let viewModel = viewModel else { return }
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        userNameLabel.text =  viewModel.username
        fullNameLabel.text = viewModel.fullname
        
    }
    
    //MARK: -
    
}
