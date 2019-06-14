//
//  ViewController.swift
//  PresenterLoginExample
//
//  Created by Julian Llorensi on 14/06/2019.
//  Copyright © 2019 globant. All rights reserved.
//

import UIKit

/// This is made it to avoid compiler errors at coding time
class ExpensesViewController: UIViewController {}
struct UserFeed {}
struct Session {
    static let shared = Session()
    
    func saveUser(_ username: String) {}
    func saveUserList(_ userFeed: UserFeed) {}
}
///

class LoginService {
    func login(username: String, password: String, completion: @escaping (String?,Error?) -> Void) {}
    func getUserList(token: String, completion: (UserFeed?,Error?) -> Void) {}
}

class LoginPresenter {
    var loginService: LoginService?
    
    convenience init(loginService : LoginService) {
        self.init()
        self.loginService = loginService
    }
    
    func loginUserSaveSessionAndGetUserList(username: String, password: String, completion: @escaping (Error?) -> Void) {
        self.loginService?.login(username: username , password: password, completion: { (user,error) in
            if error == nil {
                Session.shared.saveUser(user!)
                self.getUserList(completion: { (userFeed, error) in
                    if error == nil {
                        Session.shared.saveUserList(userFeed!)
                    }
                })
            }
            completion(error)
        })
    }
    
    private func getUserList(completion: @escaping (UserFeed?, Error?) -> Void) {
        self.loginService?.getUserList(token: "", completion: { (userFeed, error) in
            completion(userFeed,error)
        })
    }
}


class LoginViewController: ExpensesViewController {
    var loginService: LoginService?
    var loginPresenter: LoginPresenter?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Inside the ViewDidLoad we create the actual instance to the
    // Presenter were we also inject the actual Service
    override func viewDidLoad() {
        super.viewDidLoad()
        loginService = LoginService()
        loginPresenter = LoginPresenter.init(loginService: loginService!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didPressLogin(_ sender: UIButton) {
        guard checkIfTextBoxesValid() else {
            return
        }
        
        // startLoaderSpinner()
        loginPresenter?.loginUserSaveSessionAndGetUserList(username: usernameTextField.text!,
                                                           password: passwordTextField.text!, completion: { (error) in
            if error == nil {
                // stopLoaderSpinner()
                // self.performSegue(withIdentifier: "segue_show_resumen", sender: self)
            } else {
                // self.showErrorWithMsg("Disculpe, no se pudieron validad sus credenciales")
            }
        })
    }
    
    func checkIfTextBoxesValid() -> Bool {
        guard (usernameTextField.text?.count)! > 0 else {
            print("Please enter a username")
            return false
        }
        
        guard (passwordTextField.text?.count)! > 0 else {
            print("Please enter a password")
            return false
        }
        
        return true
    }
}

