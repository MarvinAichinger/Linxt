//
//  MultiplayerMenuViewController.swift
//  linxtTest
//
//  Created by Aichinger Marvin on 17.05.22.
//

import UIKit

class MultiplayerMenuViewController: UIViewController {

    let gameManager: MultiplayerGameManager = MultiplayerGameManager()
    
    @IBOutlet weak var gameRoomTextField: UITextField!
    @IBOutlet weak var joinRoomButton: UIButton!

    @IBOutlet weak var searchGameButton: UIButton!
    
    @IBOutlet weak var createGameButton: UIButton!
    
    
    
    let gameColors = GameColors()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        joinRoomButton.isEnabled = false
        joinRoomButton.isHidden = true
        joinRoomButton.backgroundColor = gameColors.blue
        joinRoomButton.layer.cornerRadius = 10
        searchGameButton.layer.cornerRadius = 10
        createGameButton.layer.cornerRadius = 10
        
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
            joinRoomButton.isHidden = false
        }else {
            joinRoomButton.isEnabled = false
            joinRoomButton.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? LoadingMenuViewController {
            view.gameManager = self.gameManager
        }
    }
}
