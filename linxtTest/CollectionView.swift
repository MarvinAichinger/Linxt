//
//  CollectionView.swift
//  linxtTest
//
//  Created by AHITM01 on 31.03.22.
//

import UIKit

class CollectionView: UICollectionView {

    var pointFrom: CGPoint = CGPoint(x: 0, y: 0)
    var pointTo: CGPoint = CGPoint(x: 0, y: 0)
    
    var linesPlayer0: [(CGPoint, CGPoint)] = [(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))]
    var linesPlayer1: [(CGPoint, CGPoint)] = [(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))]
    
    override func draw(_ rect: CGRect) {

        //Player 0
        var path = UIBezierPath()
        
        for line in linesPlayer0 {
            path.move(to: line.0)
            path.addLine(to: line.1)
        }
        
        path.close()
        
        UIColor.blue.set()
        path.lineWidth = 4
        path.stroke()
        
        //Player 1
        path = UIBezierPath()
        
        for line in linesPlayer1 {
            path.move(to: line.0)
            path.addLine(to: line.1)
        }
        
        path.close()
        
        UIColor.red.set()
        path.lineWidth = 4
        path.stroke()
    }
    
    func drawLine(from: CGPoint, to: CGPoint, player: Int) {
        if (player == 0) {
            linesPlayer0.append((from, to))
        }else if (player == 1) {
            linesPlayer1.append((from, to))
        }
        setNeedsDisplay()
    }
    

}
