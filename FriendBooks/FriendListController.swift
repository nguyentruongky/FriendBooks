//
//  FriendListController.swift
//  FriendBooks
//
//  Created by Ky Nguyen on 9/22/15.
//  Copyright © 2015 Ky Nguyen. All rights reserved.
//

import UIKit

class FriendListController: UITableViewController, FriendDetailDelegate {

//    var friends = [Friend]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var editedFriendIndex = -1
    
    @IBOutlet var friendTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        appDelegate.friends = CoreDataHelper.getFriendsFromCoreData()
//        appDelegate.lastestID = GeneralHelper.getLastestFriendID(appDelegate.friends)
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source

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
//        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: appDelegate.friends.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveEdit(controller: FriendDetailController, friend: Friend) {
        
        appDelegate.friends[editedFriendIndex] = friend

        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: editedFriendIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)

        editedFriendIndex = -1
    }

    func getFriends() {
        
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let controller = findTargetController(segue)
        
        if segue.identifier == StringResources.AddFriend {
            
            controller.mode = Mode.Add
        }
        else if segue.identifier == StringResources.ViewFriend {
            
            editedFriendIndex = (tableView.indexPathForSelectedRow?.row)!
            controller.mode = Mode.View
            controller.friend = appDelegate.friends[editedFriendIndex]
        }
    }

    func findTargetController(segue: UIStoryboardSegue) -> FriendDetailController {
        
        let navigationController = segue.destinationViewController as! UINavigationController
        
        let controller = navigationController.topViewController as! FriendDetailController
        
        controller.delegate = self
        
        return controller
    }


}
