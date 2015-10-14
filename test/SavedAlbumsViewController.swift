//
//  SavedAlbumsViewController.swift
//  test
//
//  Created by nluo on 6/9/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class SavedAlbumsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, GADBannerViewDelegate {
    
    @IBOutlet weak var savedAlbumsTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bannerView: DFPBannerView!
    
    let managedObjectContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var albums = [Album]()
    var filteredAlbums = [Album]()
    var kCellIdentifier = "albumCell"
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Google Mobile Ads SDK version: " + DFPRequest.sdkVersion())
        bannerView.adSize = kGADAdSizeBanner
        bannerView.adUnitID = "/6499/example/banner"
        bannerView.rootViewController = self
        
        let request = DFPRequest()
        request.testDevices = [ kGADSimulatorID ];
        bannerView.loadRequest(request)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.fetchAlbums()
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("Error occured while loading banner ad")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.searchActive) {
            return self.filteredAlbums.count
        }
        return albums.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)!
        
        var album: Album
        //album = self.albums[indexPath.row]
        if(searchActive){
            album = self.filteredAlbums[indexPath.row]
        } else {
            album = self.albums[indexPath.row]
        }
        
        cell.detailTextLabel?.text = album.price
        cell.textLabel?.text = album.title
        
        if let imgURL = NSURL(string: album.thumbnailImageURL),
            imgData = NSData(contentsOfURL: imgURL) {
                cell.imageView?.image = UIImage(data: imgData)
        }
        
        return cell
    }

    // Fetch Albums from db and set to albums
    func fetchAlbums() {
        let fetchRequest = NSFetchRequest(entityName: "Album")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            if let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Album] {
                albums = fetchResults
            }
        } catch _ as NSError {
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailsViewController: DetailsViewController = segue.destinationViewController as? DetailsViewController {
            let albumIndex = savedAlbumsTableView!.indexPathForSelectedRow!.row
            let selectedAlbum = self.albums[albumIndex]
            detailsViewController.album = selectedAlbum
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let albumToDelete = albums[indexPath.row]
            albumToDelete.delete()
            fetchAlbums()
            savedAlbumsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContentForSearchText(searchBar.text!)
        if(self.filteredAlbums.count == 0){
            self.searchActive = false;
        } else {
            self.searchActive = true;
        }
        self.savedAlbumsTableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredAlbums = self.albums.filter({( album: Album) -> Bool in
            let stringMatch = album.title.lowercaseString.rangeOfString(searchText.lowercaseString)
            return stringMatch != nil
        })
    }
}
