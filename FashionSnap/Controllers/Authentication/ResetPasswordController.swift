//
//  ResetPasswordController.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 9/26/23.
//

import UIKit

protocol ResetPasswordControllerDelegate: class {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController)
}

class ResetPasswordController: UIViewController {
    //MARK: - Properties
    private let emailTextField = CustomTextField(placeholder: "Email")
    private var viewModel = ResetPasswordControllerViewModel()
    weak var delegate: ResetPasswordControllerDelegate?
    var email: String?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "FashionSnap"
        label.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 37)
        label.textColor = .white
        label.shadowColor =  #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        label.shadowOffset = CGSize(width: 4, height: 4)
        label.layer.cornerRadius = 9
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private let resetPasswordButton: UIButton = {
        let button = CustomButton(placeholder: "Reset Password")
        button.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        return button
        
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    
        
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        configureUI()

    }
    //MARK: - Actions
    @objc func handleReset() {
        guard let email = emailTextField.text else { return }
        showLoader(true)
        AuthService.resetPassword(withEmail: email) { error in
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                self.showLoader(false)
                return
            }
            self.delegate?.controllerDidSendResetPasswordLink(self)
        }
       
    }
    
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        
        updateForm()
    }
    
    
    @objc func handleDismissal() {        navigationController?.popViewController(animated: true)
    }
    //MARK: - Helpers
    func configureUI() {
        configureGradientLayer()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        emailTextField.text = email
        viewModel.email = email
        updateForm()
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.setDimensions(height: 80, width: 240)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    }
}

//MARK: - Extensions
extension ResetPasswordController : FormViewModel {
    func updateForm() {
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroundColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        resetPasswordButton.isEnabled = viewModel.isValid
    }
    
}
