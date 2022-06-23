//
//  LoginViewController.swift
//  linxtTest
//
//  Created by Aichinger Marvin on 31.05.22.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    var authentication: GIDAuthentication!
    
    let signInConfig = GIDConfiguration(clientID: "769667831806-mcou0acoml622t102kdr563qrogtn0g1.apps.googleusercontent.com")

    
    @IBAction func loginButtonTouched(_ sender: Any) {
        print("pressed")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
          guard error == nil else { return }
            guard let user = user else { return }

                user.authentication.do { authentication, error in
                    guard error == nil else { return }
                    guard let authentication = authentication else { return }

                    //let idToken = authentication.idToken
                    self.authentication = authentication
                    
                    guard let authData = try? JSONEncoder().encode(["token": self.authentication.idToken]) else {
                        return
                    }
                    let url = URL(string: "http://172.17.217.10:3100/api/user/auth")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                    let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
                        if let data = data, let dataString = String(data: data, encoding: .utf8) {
                            if let matches = try? JSONSerialization.jsonObject(with: data, options: []) {
                                print(matches)
                            }
                        }
                    }
                    task.resume()
                    print("sent")
                    
                    // Send ID token to backend (example below).
                    
                    let defaults = UserDefaults.standard
                    defaults.setValue(user.profile?.givenName, forKey: "playerName")
                    
                    print(defaults.string(forKey: "playerName"))
                    
                    self.performSegue(withIdentifier: "toMenu", sender: nil)
                    
                }
          // If sign in succeeded, display the app's main content View.
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? MenuViewController {
            view.authentication = self.authentication
        }
    }
    
    /*func tokenSignInExample(idToken: String) {
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
    }*/


}

