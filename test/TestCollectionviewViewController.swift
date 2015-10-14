//
//  TestCollectionviewViewController.swift
//  test
//
//  Created by nluo on 6/29/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TestCollectionviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GADBannerViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var tableData: [String] = ["Yu Teng", "Nan", "Wen", "Wensheng", "Chris", "Nadim", "Jon", "Murshed", "Dina"]
    var tableImages: [String] = ["Blank52", "Bookmark_off", "Bookmark_on", "Blank52", "Bookmark_off", "Bookmark_on", "Blank52", "Bookmark_off", "Bookmark_on"]
    var kCellIdentifier = "Cell"
    var kGoogleAdCellIdentifier = "GoogleAdCell"
    let adIndex = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        collectionView!.registerNib(UINib(nibName: "TestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifier)
        collectionView!.registerNib(UINib(nibName: "GoogleAdCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kGoogleAdCellIdentifier)
        
        var frame = collectionView.bounds
        frame.origin.x = frame.size.width * CGFloat(3)
        frame.origin.y = 0.0
        
        // 3
        let newPageView = UIImageView(image: UIImage(named: "Bookmark_off"))
        newPageView.contentMode = .ScaleAspectFit
        newPageView.frame = frame
        collectionView.addSubview(newPageView)
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("Error occured while loading banner ad: " + error.description)
        
        if (tableData[adIndex] == "banner ad") {
            tableData.removeAtIndex(adIndex)
            tableImages.removeAtIndex(adIndex)
            let indexPath = NSIndexPath(forRow: adIndex, inSection: 0)
            collectionView.deleteItemsAtIndexPaths([indexPath])
        }
    }
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        print("Received banner ad")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print ("number of items in section: \(tableData.count)")
        return tableData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (indexPath.row == adIndex) {
            if (tableData[adIndex] != "banner ad") {
                tableData.insert("banner ad", atIndex: adIndex)
                tableImages.insert("Blank52", atIndex: adIndex)
                let indexPath = NSIndexPath(forRow: adIndex, inSection: 0)
                collectionView.insertItemsAtIndexPaths([indexPath])
            }
            print("getting google ad cell")
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kGoogleAdCellIdentifier, forIndexPath: indexPath) as! GoogleAdCollectionViewCell

            if !cell.isLoaded {
                cell.setup(self, delegate: self)
            }
            
            return cell
        }
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! TestCollectionViewCell
        cell.title.text = tableData[indexPath.row]
        cell.abstract.text = "This is the abstract of " + tableData[indexPath.row] + ". Please click and you would find nothing happens."
        cell.image.image = UIImage(named: tableImages[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Cell \(indexPath.row) selected")
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var defaultSize = 200
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
            defaultSize = 220;
        } else {
            defaultSize = 200;
        }
        if indexPath.row == 3 {
            return CGSize(width: 300, height: defaultSize)
        } else if indexPath.row == adIndex && tableData[adIndex] == "banner ad" {
            return kGADAdSizeMediumRectangle.size
        }
        return CGSize(width: defaultSize, height: defaultSize)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
}
