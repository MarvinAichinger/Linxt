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
        layer.lineWidth = 4
        layer.strokeColor = UIColor.blue.cgColor

        self.layer.addSublayer(layer)
        
        
        //Player 1
        path = UIBezierPath()
        
        for line in linesPlayer1 {
            path.move(to: line.0)
            path.addLine(to: line.1)
        }
        
        layer = CAShapeLayer()

        layer.path = path.cgPath
        layer.lineWidth = 4
        layer.strokeColor = UIColor.red.cgColor

        self.layer.addSublayer(layer)
        
        path.close()
    }
    
    func drawLine(from: CGPoint, to: CGPoint, player: Int) -> Bool{
        if (player == 0) {
            linesPlayer0.append((from, to))
        }else if (player == 1) {
            linesPlayer1.append((from, to))
        }
        setNeedsDisplay()
        
        return true
    }
}
