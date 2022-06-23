//
//  GameManager.swift
//  linxtTest
//
//  Created by AHITM01 on 05.05.22.
//

import Foundation
import UIKit
import SocketIO
import GoogleSignIn
import SPConfetti

class MultiplayerGameManager {
    
    var authentication: GIDAuthentication!
    
    var turnChangedClosure: (() -> ())?
    var turn = Players.player1 {
        didSet {
            turnChangedClosure?()
        }
    }
    
    var player = Players.player1;
    var gameRunning = true;
    var gameColors: GameColors = GameColors()
    
    var winner = Players.neutral
    
    var url = "http://172.17.217.10"
    
    var manager = SocketManager(socketURL: URL(string: "172.17.217.10:3000")!, config: [.log(true), .compress, .connectParams(["token" : "Linxt", "userName" : UserDefaults.standard.string(forKey: "playerName")])])
    var socket: SocketIOClient!
    var roomID = "";
    
    var collectionView: UICollectionView!
    var noOfCellsInRow: Int!
    
    var createdRoom = false
    var roomIDClosure: (() -> ())?
    
    var startGameClosure: (() -> ())?
    var finishGameClosure: (() -> ())?
    
    var searchedForGame = true;
    
    func initSocketManager(joinRoomID: String) {
        if (joinRoomID == "") {
            self.manager = SocketManager(socketURL: URL(string: url + ":3000")!, config: [.log(true), .compress, .connectParams(["token" : "Linxt", "isPrivate" : "true", "userName" : UserDefaults.standard.string(forKey: "playerName")])])
            self.createdRoom = true
        }else {
            self.manager = SocketManager(socketURL: URL(string: url + ":3000")!, config: [.log(true), .compress, .connectParams(["token" : "Linxt", "roomId" : joinRoomID, "userName" : UserDefaults.standard.string(forKey: "playerName")])])
        }
        self.searchedForGame = false
    }
    
    func initSocket() {
        
        self.socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
            print("connected")
        }
        
        socket.on("gameRoomID") {data, ack in
            print(data[0])
            self.roomID = data[0] as! String
            
            //Thread.sleep(forTimeInterval: 1)
            
            if (self.createdRoom) {
                self.roomIDClosure?()
            }
        }
        
        socket.on("startGame") {data, ack in
            print(data[0])
            if let starting = data[0] as? Bool {
                if (!starting) {
                    //self.turn = Players.player2
                    self.player = Players.player2
                }
            }
            Thread.sleep(forTimeInterval: 1)
            
            UserDefaults.standard.setValue(data[1], forKey: "enemyName")
            
            self.startGameClosure?()
        }
        
        socket.on("pointSet") {data, ack in
            debugPrint(data[0])
            self.handleClick(index: data[0] as! Int, ui: false)
        }
        
        socket.connect()
    }
    
    func handleClick(index: Int, ui: Bool) {
        
        if (ui && self.turn != player) {
            return
        }
        
        if (!gameRunning) {
            return
        }
        
        if (ui) {
            self.socket.emit("pointSet", roomID, index)
        }
        
        let indexPath = IndexPath(row: index, section: 0)

        
        //print(indexPath.row)
        //print("Row: \(floor(Double(indexPath.row / self.noOfCellsInRow)))")
        //print("Column: \(indexPath.row % self.noOfCellsInRow)")
        
        let row = floor(Double(indexPath.row / noOfCellsInRow))
        let column = Double(indexPath.row % noOfCellsInRow)
        
        
        let c = collectionView.cellForItem(at: indexPath)
        //collectionView.cellForItem(at: IndexPath(row: , section: 0))
        
        if let cell = c as? CollectionViewCell {
            if (cell.isOccupiedFrom == Players.neutral) {
                if (turn == Players.player1) {
                    
                    if (row == 0 || row == Double(noOfCellsInRow - 1)) {
                        return;
                    }
                    
                    cell.contentView.backgroundColor = gameColors.blue
                    cell.isOccupiedFrom = Players.player1
                    self.turn = Players.player2
                    
                    if (column == 0) {
                        cell.hasConnectionToSide1 = true
                    }
                    if (column == Double(noOfCellsInRow - 1)) {
                        cell.hasConnectionToSide2 = true
                    }
                }else {
                    
                    if (column == 0 || column == Double(noOfCellsInRow - 1)) {
                        return;
                    }
                    
                    cell.contentView.backgroundColor = gameColors.red
                    cell.isOccupiedFrom = Players.player2
                    self.turn = Players.player1
                    
                    if (row == 0) {
                        cell.hasConnectionToSide1 = true
                    }
                    if (row == Double(noOfCellsInRow - 1)) {
                        cell.hasConnectionToSide2 = true
                    }
                }
            }
            
            
            var cellsForNewConnections = [CollectionViewCell]()
            
            for i in (0 ... 7) {
                var nextColumn: Double = -1;
                var nextRow: Double = -1;
                switch i {
                case 0:
                    nextRow = row - 2
                    nextColumn = column + 1
                case 1:
                    nextRow = row - 1
                    nextColumn = column + 2
                case 2:
                    nextRow = row + 1
                    nextColumn = column + 2
                case 3:
                    nextRow = row + 2
                    nextColumn = column + 1
                case 4:
                    nextRow = row + 2
                    nextColumn = column - 1
                case 5:
                    nextRow = row + 1
                    nextColumn = column - 2
                case 6:
                    nextRow = row - 1
                    nextColumn = column - 2
                case 7:
                    nextRow = row - 2
                    nextColumn = column - 1
                default:
                    break
                }
                
                if (!(Int(nextRow) > noOfCellsInRow - 1 || nextRow < 0 || Int(nextColumn) > noOfCellsInRow - 1 || nextColumn < 0)) {
                    
                    let index = (nextRow * Double(noOfCellsInRow)) + nextColumn
                    let newIndexPath = IndexPath(row: Int(index), section: 0)
                    let newCell = collectionView.cellForItem(at: newIndexPath) as! CollectionViewCell
                    
                    //print(newCell.isOccupiedFrom)
                    
                    if let view = collectionView as? CollectionView {
                        if (newCell.isOccupiedFrom == Players.player1 && cell.isOccupiedFrom == Players.player1) {
                            let success = view.drawLine(from: cell.center, to: newCell.center, player: 0)
                            if (success) {
                                cellsForNewConnections.append(newCell)
                            }
                        }
                        if (newCell.isOccupiedFrom == Players.player2 && cell.isOccupiedFrom == Players.player2) {
                            let success = view.drawLine(from: cell.center, to: newCell.center, player: 1)
                            if (success) {
                                cellsForNewConnections.append(newCell)
                            }
                        }
                    }
                    
                }
                
                
            }
            
            let winStatus = cell.buildConnectionsTo(cells: cellsForNewConnections)
            
            if (winStatus != Players.neutral) {
                gameFinished(winner: winStatus)
            }
            
        }
    }
    
    func setGameFieldAttributes(collectionView: UICollectionView, noOfCellsInRow: Int) {
        self.collectionView = collectionView
        self.noOfCellsInRow = noOfCellsInRow
    }
    
    func gameFinished(winner: Players) {
        gameRunning = false;
        
        self.winner = winner
        finishGameClosure?()
        
        if (winner == Players.player1) {
            SPConfettiConfiguration.particlesConfig.colors = [gameColors.blue]
        }else {
            SPConfettiConfiguration.particlesConfig.colors = [gameColors.red]
        }
        SPConfetti.startAnimating(.fullWidthToDown, particles: [.arc], duration: 5)
        
        if (winner == player) {
            sendFinishedGame(won: true)
        }else {
            sendFinishedGame(won: false)
        }
    }
    
    func sendFinishedGame(won: Bool) {
        if (!searchedForGame) {
            return
        }
        guard let authData = try? JSONEncoder().encode(["token": self.authentication.idToken, "won": won.description]) else {
            return
        }
        let url = URL(string: url + ":3100/api/user")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            // Handle response from your backend.
        }
        task.resume()
        print("sent")
    }
    
}
