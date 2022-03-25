//
//  ViewController.swift
//  linxtTest
//
//  Created by Aichinger Marvin on 11.03.22.
//

import UIKit


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    let noOfCellsInRow = 24
    var widthOfCell = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //let size = collectionView.bounds.width / 24


        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(self.noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(self.noOfCellsInRow))
        
        self.widthOfCell = Double(size)
        
        return CGSize(width: size, height: size)
        

    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        print("Row: \(floor(Double(indexPath.row / self.noOfCellsInRow)))")
        print("Column: \(indexPath.row % self.noOfCellsInRow)")
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.noOfCellsInRow * self.noOfCellsInRow
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    
        // Configure the cell
        
        //round corners
        cell.contentView.clipsToBounds = true
        let radius = cell.contentView.frame.size.width / 2
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
        
        if(gestureView.transform.a > 4 ){
            gestureView.transform.a = 4
            gestureView.transform.d = 4
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
        
        
        
        print(gestureView.center.x)
        
        var newX = gestureView.center.x + translation.x
        var newY = gestureView.center.y + translation.y
        
        print(newX)
        print(translation.x)
        
        
        if(translation.x < 0 && gestureView.frame.maxX <= UIScreen.main.bounds.maxX){
            newX = UIScreen.main.bounds.maxX-20 - gestureView.frame.width/2
        }
        
        if(translation.x > 0 && gestureView.frame.minX >= UIScreen.main.bounds.minX){
            newX = UIScreen.main.bounds.minX+20 + gestureView.frame.width/2
        }
        
        
        
        print(newX)
        
        //newX = gestureView.frame.maxX > self.accessibilityFrame.size.width ? newX : gestureView.center.x
        
        gestureView.center = CGPoint(
            x: newX,
            y: gestureView.center.y + translation.y
        )
        
        sender.setTranslation(.zero, in: view)
        
        
    }
    
    
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
      _ gestureRecognizer: UIGestureRecognizer,
      shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
      return true
    }
}
