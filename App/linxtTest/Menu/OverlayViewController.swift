//
//  OverlayViewController.swift
//  linxtTest
//
//  Created by AHITM01 on 02.06.22.
//

import UIKit
import GoogleSignIn

class OverlayViewController: UIViewController {

    @IBOutlet weak var overlayTextField: UILabel!
    
    var labelText = ""
    
    var authentication: GIDAuthentication!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.overlayTextField.text = labelText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? MenuViewController {
            view.authentication = self.authentication
        }
    }


}
