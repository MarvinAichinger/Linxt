//
//  OverlayViewController.swift
//  linxtTest
//
//  Created by AHITM01 on 02.06.22.
//

import UIKit

class OverlayViewController: UIViewController {

    @IBOutlet weak var overlayTextField: UILabel!
    
    var labelText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.overlayTextField.text = labelText
    }
    


}
