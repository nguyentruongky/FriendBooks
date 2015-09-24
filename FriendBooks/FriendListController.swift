//
//  FriendListController.swift
//  FriendBooks
//
//  Created by Ky Nguyen on 9/22/15.
//  Copyright © 2015 Ky Nguyen. All rights reserved.
//

import UIKit

class FriendListController: UITableViewController, FriendDetailDelegate {

    var db = CoreDataHelper()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var editedFriendIndex = -1
    
    @IBOutlet var friendTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate.friends = db.getFriendsFromDB()
        
        if appDelegate.friends.count == 0 {
            
            appDelegate.lastestID = 0
        }
        else {
            
            appDelegate.lastestID = appDelegate.friends[appDelegate.friends.count - 1].friendID + 1
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return appDelegate.friends.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringResources.FriendCell, forIndexPath: indexPath)

        cell.textLabel?.text = appDelegate.friends[indexPath.row].name

        return cell
    }

    func addNewFriend(controller: FriendDetailController, friend: Friend) {
        
        appDelegate.friends.append(friend)
        
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        
        db.addNewFriends([friend])
        
//        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: appDelegate.friends.count, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func update(controller: FriendDetailController, friend: Friend) {
        
        appDelegate.friends[editedFriendIndex] = friend

        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: editedFriendIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)

        db.updateFriend(friend, atIndex: editedFriendIndex)
        
        editedFriendIndex = -1
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
        
            let friend = appDelegate.friends[indexPath.row]
            db.removeFriend(friend, atIndex: indexPath.row)
            
            appDelegate.friends.removeAtIndex(indexPath.row)

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let controller = findTargetController(segue)
        
        if segue.identifier == StringResources.AddFriend {
        
        }
        else if segue.identifier == StringResources.ViewFriend {
            
            editedFriendIndex = (tableView.indexPathForSelectedRow?.row)!

            controller.editedFriend = appDelegate.friends[editedFriendIndex]
        }
    }

    func findTargetController(segue: UIStoryboardSegue) -> FriendDetailController {
        
        let navigationController = segue.destinationViewController as! UINavigationController
        
        let controller = navigationController.topViewController as! FriendDetailController
        
        controller.delegate = self
        
        return controller
    }
}
