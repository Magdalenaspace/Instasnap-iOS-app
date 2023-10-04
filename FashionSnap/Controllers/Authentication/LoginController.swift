//
//  LoginController.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 7/19/23.
//


import UIKit

//to make sure the correct user is being fetched in MainTabC..
protocol AuthenticationDelegate: class {
    func authenticationDidComplete()
}

class LoginController: UIViewController {
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    
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
    
    private var emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private var passwordTextField: CustomTextField   = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: CustomButton = {
        let button = CustomButton(placeholder: "Log in")
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
//        button.isEnabled = false
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account?", secondPart: "Sign up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgotten password?", secondPart: "Get help")
        button.addTarget(self, action: #selector(handleResetButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
    }
    
    // MARK: - Actions
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("DEBUG:🐞Failed to log user in with  \(error.localizedDescription)")
                    return
                }
                print("DEBUG: Succsses log user in⭐️.")
                self.delegate?.authenticationDidComplete()
            }
        }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        // no self as it takes to RegistrationController
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
        
//        print("Show Sign Up here")
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        updateForm()
    }
    
    @objc func handleResetButton() {
        let controller = ResetPasswordController()
        controller.delegate = self
        controller.email = emailTextField.text
        navigationController?.pushViewController(controller, animated: true)
        
    }
    //MARK: - Helpers
    func configureUI(){
        
        configureGradientLayer()
        navigationController?.navigationBar.barStyle = .black
        //navigationController?.navigationBar.isHidden = false
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.setDimensions(height: 80, width: 240)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObserver() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
}

//MARK: - Extensions
extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.isValid
    }
    
}


//MARK: - ResetPasswordControllerDelegate
extension LoginController: ResetPasswordControllerDelegate {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController) {
        navigationController?.popViewController(animated: true)
        showMessage(withTitle: "Success", message: "We send a message to reset your password.")
    }
    
    
}
