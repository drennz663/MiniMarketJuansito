//
//  signUpViewController.swift
//  MiniMarketJuancito
//
//  Created by DAMII on 19/12/24.
//

import UIKit
import FirebaseAuth

class signUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                completion?()
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    
    @IBAction func registrarButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Por favor ingresa un correo electrónico válido.")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Por favor ingresa una contraseña.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) {
            (firebaseResult, error) in if let e = error {
                self.showAlert(title: "Error", message: e.localizedDescription)
            } else {
                self.showAlert(title: "Éxito", message: "¡Usuario registrado exitosamente!") {
                    
                    self.performSegue(withIdentifier: "goToNext", sender: self)
                }
            }
        }
    }
    
}
    

