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
    var pageViews: [UITableView?] = []
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // 1
        pageLabels = [["row 1", "row 2", "row 3", "row 1", "row 2", "row 3", "row 1", "row 2", "row 3", "row 1", "row 2", "row 3", "row 1", "row 2", "row 3"], ["row a", "row b"], ["WENSHENG", "CHEN"], ["WENSHENG1", "CHEN"], ["WENSHENG2", "CHEN"], ["WENSHENG3", "CHEN"], ["WENSHENG4", "CHEN"]]
        
        let pageCount = pageLabels.count
        
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
        scrollView.contentSize = CGSize(width: screenSize.width * CGFloat(pageLabels.count),
            height: scrollView.frame.height)
        
        print("align subviews height \(scrollView.frame.height)")
        
        for var i = 0; i < pageViews.count; ++i {
            if let view = pageViews[i] {
                view.frame = CGRectMake(CGFloat(i) * screenSize.width, 0,
                screenSize.width, scrollView.frame.height);
            }
        }
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        let screenSize = UIScreen.mainScreen().bounds
        scrollView.contentOffset.x = CGFloat(currentPage) * screenSize.width
        
        alignSubviews()
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageLabels.count {
            // If it's outside the range of what you have to display, then do nothing
            print("Skip page \(page)")
            return
        }
        print("Load page \(page)")
        
        // 1
        if pageViews[page] != nil {
            print("View is already loaded")
            // Do nothing. The view is already loaded.
        } else {
            // 2
            let frame = self.view.frame
            let theFrame = CGRectMake(frame.origin.x + frame.size.width * CGFloat(page), frame.origin.y, frame.size.width, frame.size.height)
            print("Adding page \(page) at (\(frame.origin.x), \(frame.origin.y))")
            // 3
            let newPageView = UITableView()
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = theFrame
            newPageView.delegate = self
            newPageView.dataSource = self
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
            print("Purge page \(page)")
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let screenWidth = UIScreen.mainScreen().bounds.width
        currentPage = Int(floor((scrollView.contentOffset.x * 2.0 + screenWidth) / (screenWidth * 2.0)))
        
        print ("Current page \(currentPage)")
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
        for var index = lastPage+1; index < pageLabels.count; ++index {
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var data: [String] = []
        for var i = 0; i < pageViews.count; ++i {
            if (tableView == pageViews[i]) {
                data = pageLabels[i]
                break
            }
        }
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("coming here \(indexPath.row)")

        var data: [String] = []
        for var i = 0; i < pageViews.count; ++i {
            if (tableView == pageViews[i]) {
                data = pageLabels[i]
                break
            }
        }

        let cell: UITableViewCell = UITableViewCell()
        cell.detailTextLabel?.text = data[indexPath.row]
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }

}
