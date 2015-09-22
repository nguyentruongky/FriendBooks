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
    
    static func setValueForObject(person: NSManagedObject, name: String, phone: String, email: String) -> NSManagedObject{
        
        person.setValue(name, forKey: "name")
        person.setValue(phone, forKey: "phone")
        person.setValue(email, forKey: "email")
        
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
    
    static func addNewFriends(friends: [Friend]) {
        
        let managedContext = getContext()
        
        for friend in friends {
            
            let friendFromCoreData = getEntity(managedContext)
            setValueForObject(friendFromCoreData, name: friend.name, phone: friend.phone, email: friend.email)
            
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
            friend.name = (friendCD.valueForKey("name") as? String)!
            friend.email = (friendCD.valueForKey("email") as? String)!
            friend.phone = (friendCD.valueForKey("phone") as? String)!
            
            friends.append(friend)
        }
        
        return friends
    }
}

