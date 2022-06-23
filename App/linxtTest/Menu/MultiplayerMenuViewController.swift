//
//  MultiplayerMenuViewController.swift
//  linxtTest
//
//  Created by Aichinger Marvin on 17.05.22.
//

import UIKit
import GoogleSignIn

class MultiplayerMenuViewController: UIViewController {
    
    var authentication: GIDAuthentication!

    let gameManager: MultiplayerGameManager = MultiplayerGameManager()
    
    @IBOutlet weak var gameRoomTextField: UITextField!
    @IBOutlet weak var joinRoomButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var createRoomButton: UIButton!
    @IBOutlet weak var searchGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        joinRoomButton.isEnabled = false
        
        searchGameButton.layer.cornerRadius = 10
        createRoomButton.layer.cornerRadius = 10
        backButton.layer.cornerRadius = 24
    }
    
    @IBAction func handleSearchGame(_ sender: UIButton) {
        gameManager.initSocket()
    }
    
    @IBAction func handlePrivateRoom(_ sender: UIButton) {
        gameManager.initSocketManager(joinRoomID: "")
        gameManager.initSocket()
    }
    
    @IBAction func handleJoinRoom(_ sender: UIButton) {
        gameManager.initSocketManager(joinRoomID: gameRoomTextField.text!)
        gameManager.initSocket()
    }
    
    @IBAction func gameRoomTextFieldValueChange(_ sender: UITextField) {
        if (sender.text != nil && sender.text?.count == 5) {
            joinRoomButton.isEnabled = true
        }else {
            joinRoomButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? LoadingMenuViewController {
            view.gameManager = self.gameManager
            self.gameManager.authentication = self.authentication
        }else if let view = segue.destination as? MenuViewController {
            view.authentication = self.authentication
        }
    }
}
