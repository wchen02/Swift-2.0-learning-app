//
//  TestPagedTableView.swift
//  test
//
//  Created by Wensheng Chen on 7/17/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//
import UIKit
import CoreData

class TestPagedTableViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    var pageLabels: [[String]] = []
    var data: [String] = []
    var pageViews: [UITableView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // 1
        pageLabels = [["row 1", "row 2", "row 3"], ["row a", "row b"], ["WENSHENG", "CHEN"]]
        
        let pageCount = pageLabels.count
        
        // 2
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }

        // 4
        let screenSize = UIScreen.mainScreen().bounds
        scrollView.contentSize = CGSize(width: screenSize.width * CGFloat(pageCount),
            height: screenSize.height)
        
        // 5
        loadVisiblePages()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        println("rotated")
        let screenSize = UIScreen.mainScreen().bounds
        scrollView.contentSize = CGSize(width: screenSize.width * CGFloat(pageLabels.count),
            height: screenSize.height)
        
        for var index = 0; index < pageViews.count; ++index {
            purgePage(index)
        }
        
        loadVisiblePages()
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageLabels.count {
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
            var frame = UIScreen.mainScreen().bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            println("Adding page \(page) at (\(frame.origin.x), \(frame.origin.y))")
            // 3
            var newPageView = UITableView()
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            newPageView.delegate = self
            newPageView.dataSource = self
            data = pageLabels[page]
            scrollView.addSubview(newPageView)
            
            // 4
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageLabels.count {
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
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + screenWidth) / (screenWidth * 2.0)))
        println ("Current page \(page)")
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageLabels.count; ++index {
            purgePage(index)
        }
        
        scrollView.bringSubviewToFront(pageViews[page]!)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        cell.detailTextLabel?.text = data[indexPath.row]
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }

}
