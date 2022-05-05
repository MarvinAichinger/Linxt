//
//  CollectionView.swift
//  linxtTest
//
//  Created by AHITM01 on 31.03.22.
//

import UIKit

class CollectionView: UICollectionView {
    
    var linesPlayer0: [(CGPoint, CGPoint)] = [(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))]
    var linesPlayer1: [(CGPoint, CGPoint)] = [(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))]
    
    var gameColors: GameColors = GameColors()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        //Player 0
        var path = UIBezierPath()
        
        var layer = CAShapeLayer()
        
        for line in linesPlayer0 {
            path.move(to: line.0)
            path.addLine(to: line.1)
        }

        
        path.close()

        layer.path = path.cgPath
        layer.lineWidth = 10
        layer.strokeColor = gameColors.blueCG

        self.layer.addSublayer(layer)
        
        
        //Player 1
        path = UIBezierPath()
        
        for line in linesPlayer1 {
            path.move(to: line.0)
            path.addLine(to: line.1)
        }
        
        layer = CAShapeLayer()

        layer.path = path.cgPath
        layer.lineWidth = 10
        layer.strokeColor = gameColors.redCG

        self.layer.addSublayer(layer)
        
        path.close()
        
        UIColor.red.set()
        path.lineWidth = 4
        path.stroke()
        
    }
    
    func drawLine(from: CGPoint, to: CGPoint, player: Int) -> Bool {
        
        let overlap = checkIfLinesOverlap(from: from, to: to);
        
        //print (overlap)
        
        if (!overlap) {
            if (player == 0) {
                linesPlayer0.append((from, to))
            }else if (player == 1) {
                linesPlayer1.append((from, to))
            }
            setNeedsDisplay()
            return true
        }else {
            setNeedsDisplay()
            return false
        }
    }
    
    func checkIfLinesOverlap(from: CGPoint, to: CGPoint) -> Bool {
        
        var allLines: [(CGPoint, CGPoint)] = []
        allLines.append(contentsOf: linesPlayer0)
        allLines.append(contentsOf: linesPlayer1)
        
        for line in allLines {
            
            let ax = from.x
            let ay = from.y
            let bx = to.x
            let by = to.y
            let cx = line.0.x
            let cy = line.0.y
            let dx = line.1.x
            let dy = line.1.y
            
            let d = (ax - bx) * (cy - dy) - (ay - by) * (cx - dx)
            
            if (d != 0) {
            
                let a = ax*by - ay*bx
                let b = cx*dy - cy*dx
                
                let x = (a * (cx - dx) - b * (ax - bx)) / d
                let y = (a * (cy - dy) - b * (ay - by)) / d
                
                if (x < max(ax, bx) && x > min(ax, bx) && x < max(cx, dx) && x > min(cx, dx)) {
                    
                    if (Int(x) != Int(from.x) && Int(y) != Int(from.y) && Int(x) != Int(to.x) && Int(y) != Int(to.y)) {
                        //print(x)
                        //print(y)
                        return true
                    }
                    
                }
            
            }
            
        }
        
        return false
        
    }
}
