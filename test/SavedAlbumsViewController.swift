//
//  SavedAlbumsViewController.swift
//  test
//
//  Created by nluo on 6/9/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import UIKit
import CoreData

class SavedAlbumsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var savedAlbumsTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let managedObjectContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var albums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.fetchAlbums()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    // Fetch Albums from db and set to albums
    func fetchAlbums() {
        let fetchRequest = NSFetchRequest(entityName: "Album")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var errorPointer : NSErrorPointer = nil
        
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: errorPointer) as? [Album] {
            albums = fetchResults
        }
    }
    
}
