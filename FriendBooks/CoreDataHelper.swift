//
//  CoreDataHelper.swift
//  FriendBooks
//
//  Created by Ky Nguyen on 9/22/15.
//  Copyright © 2015 Ky Nguyen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper  {
    
    private var managedContext: NSManagedObjectContext
    
    init() {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

        self.managedContext = delegate.managedObjectContext
    }

    private func getFriends() -> [NSManagedObject]? {
        
        let fetchRequest = NSFetchRequest(entityName: "Friend")
        
        do {
            
            return try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        }
        catch {
            
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return nil
    }
    
    func getFriendsFromDB() -> [Friend] {
        
        let friendsCD = getFriends()
        
        if let unwrappedFriends = friendsCD {
            
            return parseFriendCoreDataToFriend(unwrappedFriends)
        }
        
        return [Friend]()
    }
    
    func updateFriend(friend: Friend, atIndex index: Int) {
        
        let friendsCD = getFriends()
        
        if let unwrappedFriends = friendsCD {
            
            let updatedFriend = unwrappedFriends[index]
            
            updateFriend(updatedFriend, friendNewInfo: friend)
        }
        
    }
    
    private func updateFriend(updatedFriend: NSManagedObject, friendNewInfo friend: Friend) {
        
//        let id = updatedFriend.valueForKey("friendID") as! Int
//        
//        if id == friend.friendID {
        
            setValueForObject(updatedFriend, friend: friend)
            
            saveContext()
//        }

    }
    
    func removeFriend(friend: Friend, atIndex index: Int) {
        
        let friendsCD = getFriends()
        
        if let unwrappedFriends = friendsCD {
            
            let removedFriend = unwrappedFriends[index]
        
            removeFriend(removedFriend)
        }
    }
    
    private func removeFriend(removedFriend: NSManagedObject) {
        
//        let id = removedFriend.valueForKey("friendID") as! Int
//        
//        if id == friend.friendID {
//            
            managedContext.deleteObject(removedFriend)
            
            saveContext()
//        }
    }
    
    func addNewFriends(friends: [Friend]) {
        
        for friend in friends {
            
            let friendFromCoreData = getEntity(managedContext)
            
            setValueForObject(friendFromCoreData, friend: friend)
            
            saveContext()
        }
    }
    
    private func getEntity(managedContext: NSManagedObjectContext) -> NSManagedObject  {
        
        let entity = NSEntityDescription.entityForName("Friend", inManagedObjectContext: managedContext)
        
        return NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
    }
    
    private  func parseFriendCoreDataToFriend(friendsCD: [NSManagedObject]) -> [Friend] {
        
        var friends = [Friend]()
        
        for friendCD in friendsCD {
            
            let friend = Friend()
            
            friend.friendID = (friendCD.valueForKey("friendID") as? Int)!
            friend.name = (friendCD.valueForKey("name") as? String)!
            friend.email = (friendCD.valueForKey("email") as? String)!
            friend.phone = (friendCD.valueForKey("phone") as? String)!
            friend.avatar = (friendCD.valueForKey("avatar") as? NSData)
            friend.cover = (friendCD.valueForKey("cover") as? NSData)
            
            friends.append(friend)
        }
        
        return friends
    }
    
    // set friend model data to friend entity
    func setValueForObject(person: NSManagedObject, friend: Friend) -> NSManagedObject{
        
        person.setValue(friend.friendID, forKey: "friendID")
        person.setValue(friend.name, forKey: "name")
        person.setValue(friend.phone, forKey: "phone")
        person.setValue(friend.email, forKey: "email")
        person.setValue(friend.avatar, forKey: "avatar")
        person.setValue(friend.cover, forKey: "cover")
        
        return person
    }
    
    private func saveContext() {
        
        do  {
            
            try managedContext.save()
        }
        catch {}
    }
}

