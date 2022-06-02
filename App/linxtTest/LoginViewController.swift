//
//  LoginViewController.swift
//  linxtTest
//
//  Created by Aichinger Marvin on 31.05.22.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    let signInConfig = GIDConfiguration(clientID: "769667831806-mcou0acoml622t102kdr563qrogtn0g1.apps.googleusercontent.com")

    
    @IBAction func loginButtonTouched(_ sender: Any) {
        print("pressed")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
          guard error == nil else { return }
            guard let user = user else { return }

                user.authentication.do { authentication, error in
                    guard error == nil else { return }
                    guard let authentication = authentication else { return }

                    let idToken = authentication.idToken
                    // Send ID token to backend (example below).
                    
                    func tokenSignInExample(idToken: String) {
                        guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
                            return
                        }
                        let url = URL(string: "https://yourbackend.example.com/tokensignin")!
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
                            // Handle response from your backend.
                        }
                        task.resume()
                    }
                    
                }
          // If sign in succeeded, display the app's main content View.
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
    }
    
    


}

