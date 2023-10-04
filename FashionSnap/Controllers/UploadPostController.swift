//
//  UploadPostController.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 9/14/23.
//

import UIKit
import JGProgressHUD

//action back to tabBarController
protocol UploadPostControllerDelegate: class {
    func controllerDidFinishUploadPost(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {
    
    // MARK: - Properties
    
    var currentUser: User?
    
    weak var delegate: UploadPostControllerDelegate?
    
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Enter Caption"
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.delegate = self
        tv.backgroundColor = .white
        tv.placeHolderShouldCenter = false
        tv.textColor = .black
        return tv
    }()
    
    private let characterContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "0/100"
        return label
        
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
//        view.backgroundColor = .white
        
        
    }
    // MARK: - Actions
    @objc func didTapCancel(){
        dismiss(animated: false, completion: nil)
//        navigationController?.popViewController(animated:true)
            
        
    }
    
    @objc func didTapDone(){
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let user = currentUser else { return }
        showLoader(true)
        
        PostService.uploadPost(caption: caption, image: image, user: user) { error in
            self.showLoader(false)
            
            if let error = error {
                print("DEBUG: Failed the upload with \(error.localizedDescription)")
                return
            }
            
        }
        
        self.delegate?.controllerDidFinishUploadPost(self)
    }
    
    // MARK: - Helpers
    func configureUI() {
        navigationItem.title = "Upload Post"
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapDone))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 200, width: 200)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(characterContentLabel)
        characterContentLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor, paddingBottom:  -12, paddingRight: 12)
        
        
    }
    
    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
}
// MARK: - UITextViewDelegate
extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        characterContentLabel.text = "\(count)/100"
    }
}
