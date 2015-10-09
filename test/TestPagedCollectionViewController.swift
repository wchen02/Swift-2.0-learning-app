//
//  TestPagedCollectionViewController.swift
//  test
//
//  Created by Wensheng Chen on 7/21/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//
import UIKit
import CoreData

class TestPagedCollectionViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    let barSize: CGFloat = 44.0
    var pageViews: [UICollectionView?] = []
    var currentPage: Int = 0
    
    var tableData: [[String]] = [["Yu Teng", "Nan", "Wen", "Wensheng", "Chris", "Nadim", "Jon", "Murshed", "Dina","Yu Teng", "Nan", "Wen", "Wensheng", "Chris", "Nadim", "Jon", "Murshed", "Dina"], ["Yu Teng2", "Nan2", "Wen2", "Wensheng2", "Chris2", "Nadim2", "Jon2", "Murshed2", "Dina2","Yu Teng2", "Nan2", "Wen2", "Wensheng2", "Chris2", "Nadim2", "Jon2", "Murshed2", "Dina2"],["Yu Teng3", "Nan3", "Wen3", "Wensheng3", "Chris3", "Nadim3", "Jon3", "Murshed3", "Dina3","Yu Teng3", "Nan3", "Wen3", "Wensheng3", "Chris3", "Nadim3", "Jon3", "Murshed3", "Dina3"], ["Yu Teng4", "Nan4", "Wen4", "Wensheng4", "Chris4", "Nadim4", "Jon4", "Murshed4", "Dina4","Yu Teng4", "Nan4", "Wen4", "Wensheng4", "Chris4", "Nadim4", "Jon4", "Murshed4", "Dina4"]]
    var tableImages: [String] = ["Blank52", "Bookmark_off", "Bookmark_on", "Blank52", "Bookmark_off", "Bookmark_on", "Blank52", "Bookmark_off", "Bookmark_on","Blank52", "Bookmark_off", "Bookmark_on", "Blank52", "Bookmark_off", "Bookmark_on", "Blank52", "Bookmark_off", "Bookmark_on"]
    var kCellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let pageCount = tableData.count
        
        // 2
        pageControl.currentPage = currentPage
        pageControl.numberOfPages = pageCount
        
        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        alignSubviews()
        
        // 5
        loadVisiblePages()
    }
    
    func alignSubviews() {
        // Position all the content views at their respective page positions
        let screenSize = UIScreen.mainScreen().bounds
        scrollView.contentSize = CGSize(width: screenSize.width * CGFloat(tableData.count),
            height: scrollView.frame.height)
        
        println("align subviews height \(scrollView.frame.height)")
        
        for var i = 0; i < pageViews.count; ++i {
            if let view = pageViews[i] {
                view.frame = CGRectMake(CGFloat(i) * screenSize.width, 0,
                    screenSize.width, scrollView.frame.height - 120);
            }
        }
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        let screenSize = UIScreen.mainScreen().bounds
        scrollView.contentOffset.x = CGFloat(currentPage) * screenSize.width
        
        alignSubviews()
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= tableData.count {
            // If it's outside the range of what you have to display, then do nothing
            println("Skip page \(page)")
            return
        }
        println("Load page \(page)")
        
        // 1
        if let pageView = pageViews[page] {
            println("View is already loaded")
            // Do nothing. The view is already loaded.
        } else {
            // 2
            //var frame = CGRectMake(UIScreen.mainScreen().bounds.width * CGFloat(page), 0,
                //UIScreen.mainScreen().bounds.width, scrollView.frame.height);
            let frame = self.view.frame
            let theFrame = CGRectMake(frame.origin.x + frame.size.width * CGFloat(page), frame.origin.y, frame.size.width, frame.size.height - 120)
            println("Adding page \(page) at (\(frame.origin.x), \(frame.origin.y))")
            // 3
            var newPageView = UICollectionView(frame: theFrame, collectionViewLayout: UICollectionViewFlowLayout())
            newPageView.contentMode = .ScaleAspectFit
            newPageView.delegate = self
            newPageView.dataSource = self
            scrollView.addSubview(newPageView)
            
            // 4
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= tableData.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            println("Purge page \(page)")
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let screenWidth = UIScreen.mainScreen().bounds.width
        currentPage = Int(floor((scrollView.contentOffset.x * 2.0 + screenWidth) / (screenWidth * 2.0)))
        
        println ("Current page \(currentPage)")
        // Update the page control
        pageControl.currentPage = currentPage
        
        // Work out which pages you want to load
        let firstPage = currentPage - 1
        let lastPage = currentPage + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < tableData.count; ++index {
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var data: [String] = []
        for var i = 0; i < pageViews.count; ++i {
            if (collectionView == pageViews[i]) {
                data = tableData[i]
                break
            }
        }
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var page = 0
        
        for var i = 0; i < pageViews.count; ++i {
            if (collectionView == pageViews[i]) {
                page = i
                break
            }
        }
        
        collectionView.registerNib(UINib(nibName: "TestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifier)


        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! TestCollectionViewCell
        cell.title.text = tableData[page][indexPath.row]
        cell.abstract.text = "This is the abstract of " + tableData[page][indexPath.row] + ". Please click and you would find nothing happens."
        cell.image.image = UIImage(named: tableImages[indexPath.row])

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var baseSize = 0

        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
            baseSize = 40
        } else {
            baseSize = 60
        }
        
        if indexPath.row == 3 || indexPath.row == 6 || indexPath.row == 10 {
            return CGSize(width: baseSize * 4 * 2 + 20, height: baseSize * 3)
        }
        
        return CGSize(width: baseSize * 4, height: baseSize * 3)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(5, 5, 5, 5); //top,left,bottom,right
    }
}
