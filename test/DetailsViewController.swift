//
//  DetailsViewController.swift
//  test
//
//  Created by nluo on 5/21/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import UIKit
import MediaPlayer

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    lazy var api : APIController = APIController(delegate: self)
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var album: Album?
    var tracks = [Track]()
    let kCellIdentifier: String = "TrackCell"
    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    var lastPlayIndexPath : NSIndexPath?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        titleLabel.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
        if self.album != nil {
            api.lookupAlbum(self.album!.collectionId)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! TrackCell
        
        let track = self.tracks[indexPath.row]
        cell.titleLabel.text = track.title
        cell.playIcon.text = "▶️"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var track = tracks[indexPath.row]
        
        mediaPlayer.contentURL = NSURL(string: track.previewUrl)
        if lastPlayIndexPath != nil {
            if indexPath.row != lastPlayIndexPath!.row {
                mediaPlayer.stop()
                mediaPlayer.play()
                (tableView.cellForRowAtIndexPath(lastPlayIndexPath!) as! TrackCell).playIcon.text = "▶️"
            } else {
                mediaPlayer.pause()
                /*if mediaPlayer.playbackState == MPMoviePlaybackState.Playing{
                    mediaPlayer.pause()
                    (tableView.cellForRowAtIndexPath(lastPlayIndexPath!) as! TrackCell).playIcon.text = "▶️"
                } else {
                    mediaPlayer.play()
                }*/
            }
        } else {
            mediaPlayer.stop()
            mediaPlayer.play()
        }
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            cell.playIcon.text = "◾️"
            lastPlayIndexPath = indexPath
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = Track.tracksWithJSON(results)
            self.tracksTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}