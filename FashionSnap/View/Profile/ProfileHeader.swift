//
//  ProfileHeader.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 7/31/23.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: class {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
}
class ProfileHeader: UICollectionReusableView {
    //MARK: - Properties
    
    var viewModel: ProfileHeaderViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
//        iv.image = #imageLiteral(resourceName: "Screenshot 2023-07-07 at 12.26.08 PM")
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        return iv

    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
//        label.text = "Test Test"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    //lazy load as it hasn't been initialized yet but we add target within instead of putting in Lifecycle init  method
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var postLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage( #imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage( #imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage( #imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: nameLabel.bottomAnchor,left: leftAnchor, right: rightAnchor,paddingTop: 16, paddingLeft: 24,paddingRight: 24  )
        
        let stack = UIStackView(arrangedSubviews: [postLabel, followersLabel,followingLabel])
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12, height: 50)
        
        let topDevider  = UIView()
        topDevider.backgroundColor = .lightGray
        
        let buttomDevider  = UIView()
        buttomDevider.backgroundColor = .lightGray
        
        let buttomStack = UIStackView(arrangedSubviews: [gridButton, listButton, bookMarkButton])
        buttomStack.distribution = .fillEqually
        
        addSubview(buttomStack)
        addSubview(topDevider)
        addSubview(buttomDevider)
        
        buttomStack.anchor(left: leftAnchor, bottom:  bottomAnchor, right: rightAnchor, height: 50)
        topDevider.anchor(top: buttomStack.topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        buttomDevider.anchor(top: buttomStack.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
                                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not beeen implemented")
    }
    
    //MARK: - Actions
    //this wouldn't work without lazy
    @objc func handleEditProfileButton() {
        print("Debug: handle edit button.")
        guard let viewModel = viewModel else { return }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
        
    }
    
    //MARK: - Helper
    func configure() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.fullname
        print("DEBUG:🐞 Configure header with User info..")
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        editProfileFollowButton.setTitle(viewModel.followButtonText, for: .normal)
        editProfileFollowButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.followButtonBackgroundColor
        followersLabel.attributedText = viewModel.numberOfFollowers
        followingLabel.attributedText = viewModel.numberOfFollowings
        postLabel.attributedText = viewModel.numberOfPosts
    }
    
//    func attributedStateText(value: Int, label: String) -> NSAttributedString {
//        //"\(value)\n" to have new line
//        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
//        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.gray ]))
//
//        return attributedText
//    }
}
