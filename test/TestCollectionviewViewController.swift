//
//  TestCollectionviewViewController.swift
//  test
//
//  Created by nluo on 6/29/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import UIKit

class TestCollectionviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var tableData: [String] = ["Yu Teng", "Nan", "Wen", "Wensheng", "Chris", "Nadim", "Jon", "Murshed", "Dina"]
    var tableImages: [String] = ["Blank52", "Bookmark_off", "Bookmark_on", "Blank52", "Bookmark_off", "Bookmark_on", "Blank52", "Bookmark_off", "Bookmark_on"]
    var kCellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        var frame = collectionView.bounds
        frame.origin.x = frame.size.width * CGFloat(3)
        frame.origin.y = 0.0
        
        // 3
        let newPageView = UIImageView(image: UIImage(named: "Bookmark_off"))
        newPageView.contentMode = .ScaleAspectFit
        newPageView.frame = frame
        collectionView.addSubview(newPageView)

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! TestCollectionViewCell
        cell.title.text = tableData[indexPath.row]
        cell.abstract.text = "This is the abstract of " + tableData[indexPath.row] + ". Please click and you would find nothing happens."
        cell.image.image = UIImage(named: tableImages[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("Cell \(indexPath.row) selected")
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var defaultSize = 200
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
            defaultSize = 220;
        } else {
            defaultSize = 200;
        }
        if indexPath.row == 3 {
            return CGSize(width: defaultSize*2, height: defaultSize)
        }
        return CGSize(width: defaultSize, height: defaultSize)
    }
    
    /*func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }*/
    
}
