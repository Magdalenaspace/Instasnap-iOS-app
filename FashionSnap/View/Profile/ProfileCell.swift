//
//  ProfileCell.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 7/31/23.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    //MARK: - Properties
    var  viewModel: PostViewModel? {
        didSet {
            configure()
        }
    }
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
//        iv.image = #imageLiteral(resourceName: "Screenshot 2023-07-06 at 5.05.20 PM")
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    
    //MARK: - LyfeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(postImageView)
        //profileCell is the superView of postImage
        postImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not beeen implemented")
    }
    
    //MARK: - Helpers
    
    func  configure() {
        guard let viewModel = viewModel else { return }
        postImageView.sd_setImage(with: viewModel.imageUrl)
        
    }
    
}
