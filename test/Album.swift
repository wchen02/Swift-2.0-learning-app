//
//  Album.swift
//  test
//
//  Created by nluo on 5/21/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import Foundation
import CoreData


class Album: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var price: String
    @NSManaged var thumbnailImageURL: String
    @NSManaged var largeImageURL: String
    @NSManaged var itemURL: String
    @NSManaged var artistURL: String
    //@NSManaged var collectionId: NSNumber
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, price: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String, artistURL: String, collectionId: Int) {
        let managedObjectContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName("Album", inManagedObjectContext: managedObjectContext)!
        super.init(entity: entity, insertIntoManagedObjectContext: nil)
        
        self.title = name
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
        //self.collectionId = NSNumber(long: collectionId)
    }
    
    /*class func createInManagedObjectContext(moc: NSManagedObjectContext, name: String, price: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String, artistURL: String, collectionId: Int) -> Album {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Album", inManagedObjectContext: moc) as! test.Album
        newItem.title = name
        newItem.price = price
        newItem.thumbnailImageURL = thumbnailImageURL
        newItem.largeImageURL = largeImageURL
        newItem.itemURL = itemURL
        newItem.artistURL = artistURL
        newItem.collectionId = NSNumber(long: collectionId)
        
        return newItem
    }*/
    
    static func albumsWithJSON(results: NSArray) -> [Album] {
        // Create an empty array of Albums to append to from this list
        var albums = [Album]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in results {
                
                var name = result["trackName"] as? String ?? result["collectionName"] as? String
                /*if name == nil {
                name = result["collectionName"] as? String
                }*/
                
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
                var price = result["formattedPrice"] as? String
                if price == nil {
                    price = result["collectionPrice"] as? String
                    if price == nil {
                        var priceFloat: Float? = result["collectionPrice"] as? Float
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$\(nf.stringFromNumber(priceFloat!)!)"
                        } else {
                            price = "Free"
                        }
                    }
                }
                
                let thumbnailURL = result["artworkUrl60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String
                }
                
                if let collectionId = result["collectionId"] as? Int {
                    var newAlbum = Album(name: name!,
                        price: price!,
                        thumbnailImageURL: thumbnailURL,
                        largeImageURL: imageURL,
                        itemURL: itemURL!,
                        artistURL: artistURL,
                        collectionId: collectionId)
                    albums.append(newAlbum)
                }
            }
        }
        return albums
    }
}