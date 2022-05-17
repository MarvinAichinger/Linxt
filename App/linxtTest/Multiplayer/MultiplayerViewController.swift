//
//  ViewController.swift
//  linxtTest
//
//  Created by Aichinger Marvin on 11.03.22.
//

import UIKit


class MultiplayerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    let noOfCellsInRow = 24
    var widthOfCell = 1.0
    
    let gameManager: MultiplayerGameManager = MultiplayerGameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(self.noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(self.noOfCellsInRow))
        
        self.widthOfCell = Double(size)
        
        if let view = collectionView as? CollectionView {
            view.setSize(newSize: self.widthOfCell)
        }
        
        gameManager.setGameFieldAttributes(collectionView: collectionView, noOfCellsInRow: self.noOfCellsInRow)
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        gameManager.handleClick(index: indexPath.row, ui: true)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.noOfCellsInRow * self.noOfCellsInRow
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.cornerRadius = CGFloat(self.widthOfCell / 2.0)
        
        return cell
    }
    
    @IBAction func handlePinch(_ sender: UIPinchGestureRecognizer) {
        
        guard let gestureView = sender.view else {
          return
        }
        
        gestureView.transform = gestureView.transform.scaledBy(
          x: sender.scale,
          y: sender.scale
        )
        
        if(gestureView.transform.a < 1){
            gestureView.transform.a = 1
            gestureView.transform.d = 1
        }
        
        if(gestureView.transform.a > 2){
            gestureView.transform.a = 2
            gestureView.transform.d = 2
        }
        
        var newX = gestureView.center.x
        
        if(gestureView.frame.maxX <= UIScreen.main.bounds.maxX){
            newX = UIScreen.main.bounds.maxX-20 - gestureView.frame.width/2
        }
        
        if(gestureView.frame.minX >= UIScreen.main.bounds.minX){
            newX = UIScreen.main.bounds.minX+20 + gestureView.frame.width/2
        }
        
        gestureView.center = CGPoint(
          x: newX,
          y: gestureView.center.y
        )
        
        sender.scale = 1
        
    }
    
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        guard let gestureView = sender.view else {
            return
        }
        
        //print(gestureView.center.x)
        
        var newX = gestureView.center.x + translation.x
        var newY = gestureView.center.y + translation.y
        
        //print(newX)
        //print(translation.x)
        
        if(translation.x < 0 && gestureView.frame.maxX <= UIScreen.main.bounds.maxX){
            newX = UIScreen.main.bounds.maxX-20 - gestureView.frame.width/2
        }
        
        if(translation.x > 0 && gestureView.frame.minX >= UIScreen.main.bounds.minX){
            newX = UIScreen.main.bounds.minX+20 + gestureView.frame.width/2
        }
        
        if(translation.y > 0 && gestureView.frame.maxY >= UIScreen.main.bounds.maxY){
            newY = UIScreen.main.bounds.maxY - gestureView.frame.height/2
        }
        
        if(translation.y < 0 && gestureView.frame.minY <= UIScreen.main.bounds.minY){
            newY = UIScreen.main.bounds.minY + gestureView.frame.height/2
        }
        
        //print(newX)
        
        //newX = gestureView.frame.maxX > self.accessibilityFrame.size.width ? newX : gestureView.center.x
        
        gestureView.center = CGPoint(
            x: newX,
            y: newY
        )
        
        sender.setTranslation(.zero, in: view)
        
        
    }
    
    
}

extension MultiplayerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
      _ gestureRecognizer: UIGestureRecognizer,
      shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
      return true
    }
}


