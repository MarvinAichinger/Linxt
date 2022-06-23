//
//  LoadingMenuViewController.swift
//  linxtTest
//
//  Created by AHITM01 on 19.05.22.
//

import UIKit
import GoogleSignIn

class LoadingMenuViewController: UIViewController {
    

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var roomText: UILabel!
    @IBOutlet weak var mainText: UILabel!
    
    var gameManager: MultiplayerGameManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (gameManager.createdRoom) {
            gameManager.roomIDClosure = {
                self.roomText.text = self.gameManager.roomID
            }
        }
        
        gameManager.startGameClosure = {
            self.performSegue(withIdentifier: "toMultiplayerGame", sender: nil)
        }
        
        backButton.layer.cornerRadius = 24
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? MultiplayerViewController {
            view.gameManager = self.gameManager
        }else if let view = segue.destination as? MenuViewController {
            view.authentication = self.gameManager.authentication
        }
    }


}
