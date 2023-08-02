//
//  LoginViewController.swift
//  Infuzamed
//
//  Created by Vazgen on 7/12/23.
//

import UIKit


class LoginViewController: BaseViewController {
    // MARK: - @IBOutlet
    @IBOutlet var loginTexfield: UITextField!
    @IBOutlet var loginBackgroundView: GradientView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordBackgroundView: GradientView!

    // MARK: - Base
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    @IBAction func loginAction(_ sender: Any) {
        showLoader()
        LoginManager.shared.login(login: loginTexfield.text, password: passwordTextField.text) { [weak self] succes in
            self?.hideLoder()
            if succes {
                self?.openMenu()
            } else {
                self?.showAlert(text: "Error")
            }
        }
    }
}

// MARK: - Private
private extension LoginViewController {
    func setupView() {
        loginBackgroundView.gradientColors = [UIColor(hex: "024057"), UIColor(hex: "05A0DB")]
        passwordBackgroundView.gradientColors = [UIColor(hex: "024057"), UIColor(hex: "05A0DB")]
        let attributedLoginPlaceholder = NSAttributedString(string: "Login", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white // Set your desired color here
        ])
        let attributedPassPlaceholder = NSAttributedString(string: "Password", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white // Set your desired color here
        ])
        loginTexfield.attributedPlaceholder = attributedLoginPlaceholder
        passwordTextField.attributedPlaceholder = attributedPassPlaceholder
    }

    func showAlert(text: String) {
        let alert = UIAlertController(title: text, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default))
        present(alert, animated: true, completion: nil)
    }

    func openMenu() {
        navigationController?.pushViewController(MenuViewController(), animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}




