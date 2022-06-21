//
//  GameManager.swift
//  linxtTest
//
//  Created by AHITM01 on 05.05.22.
//

import Foundation
import UIKit
import SPConfetti

class CoopGameManager {
    
    var turnChangedClosure: (() -> ())?
    var turn = Players.player1 {
        didSet {
            turnChangedClosure?()
        }
    }
    
    var winner = Players.neutral
    var finishGameClosure: (() -> ())?
    
    var gameRunning = true
    var gameColors: GameColors = GameColors()
    
    func handleClick(collectionView: UICollectionView, indexPath: IndexPath, noOfCellsInRow: Int) {
        
        if (!gameRunning) {
            return;
        }
        
        //print(indexPath.section)
        //print("Row: \(floor(Double(indexPath.row / self.noOfCellsInRow)))")
        //print("Column: \(indexPath.row % self.noOfCellsInRow)")
        
        let row = floor(Double(indexPath.row / noOfCellsInRow))
        let column = Double(indexPath.row % noOfCellsInRow)
        
        let c = collectionView.cellForItem(at: indexPath)
        
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
    
    func surrender(player: Players) {
        if (player == Players.player1) {
            gameFinished(winner: Players.player2)
        }else {
            gameFinished(winner: Players.player1)
        }
    }
    
    func gameFinished(winner: Players) {
        gameRunning = false;
        
        self.winner = winner
        finishGameClosure?()
        
        SPConfettiConfiguration.particlesConfig.colors.removeAll()
        SPConfetti.stopAnimating()
        /*if (winner == Players.player1) {
            SPConfettiConfiguration.particlesConfig.colors = [gameColors.blue]
        }else {
            SPConfettiConfiguration.particlesConfig.colors = [gameColors.red]
        }*/
        SPConfettiConfiguration.particlesConfig.colors = [UIColor.systemYellow]
        SPConfetti.startAnimating(.fullWidthToDown, particles: [.arc], duration: 5)
    }
    
}

