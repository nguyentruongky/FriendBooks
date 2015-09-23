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
    
    private static func getEntity(managedContext: NSManagedObjectContext) -> NSManagedObject  {
        
        
        let entity = NSEntityDescription.entityForName("Friend", inManagedObjectContext: managedContext)
        
        return NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
    }
    
    private static func getContext() -> NSManagedObjectContext {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.managedObjectContext
    }
    
    static func setValueForObject(person: NSManagedObject, friend: Friend) -> NSManagedObject{
        
        person.setValue(friend.friendID, forKey: "friendID")
        person.setValue(friend.name, forKey: "name")
        person.setValue(friend.phone, forKey: "phone")
        person.setValue(friend.email, forKey: "email")
        
        return person
    }

    
    static func getFriendsFromCoreData() -> [Friend] {
        
        let managedContext = getContext()
        
        var friendsCD = [NSManagedObject]()
        
        let fetchRequest = NSFetchRequest(entityName: "Friend")
        
        do {
            
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchResults {
                
                friendsCD = results
            }
        }
        catch {
            
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        let friends = parseFriendCoreDataToFriend(friendsCD)
        
        return friends
    }
    
    static func updateFriendInfo(friend: Friend) {
        
        let managedContext = getContext()
        
        let fetchRequest = NSFetchRequest(entityName: "Friend")
        
        do {
            
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchResults {
                
                for result in results {
                    
                    let id = result.valueForKey("friendID") as! Int
                    
                    if id == friend.friendID {
                        
                        setValueForObject(result, friend: friend)
                        
                        try managedContext.save()
                        
                        break
                    }
                }
                
            }
        }
        
        catch {
            
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }


    }
    
    static func removeFriend(friend: Friend) {
        
        let managedContext = getContext()
        
        let fetchRequest = NSFetchRequest(entityName: "Friend")
        
        do {
            
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchResults {
                
                for result in results {
                    
                    let id = result.valueForKey("friendID") as! Int
                    
                    if id == friend.friendID {
                        
                        managedContext.deleteObject(result)
                        
                        try managedContext.save()
                        
                        break
                    }
                }
                
            }
        }
            
        catch {
            
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        

    }
    
    static func addNewFriends(friends: [Friend]) {
        
        let managedContext = getContext()
        
        for friend in friends {
            
            let friendFromCoreData = getEntity(managedContext)
            
            setValueForObject(friendFromCoreData, friend: friend)
            
            do {
                
                try managedContext.save()
            }
            catch {
                
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }

        }
    }
    
    private static func parseFriendCoreDataToFriend(friendsCD: [NSManagedObject]) -> [Friend] {
        
        var friends = [Friend]()
        
        for friendCD in friendsCD {
            
            let friend = Friend()
            friend.friendID = (friendCD.valueForKey("friendID") as? Int)!
            friend.name = (friendCD.valueForKey("name") as? String)!
            friend.email = (friendCD.valueForKey("email") as? String)!
            friend.phone = (friendCD.valueForKey("phone") as? String)!
            
            friends.append(friend)
        }
        
        return friends
    }
}

