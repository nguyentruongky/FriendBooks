//
//  Utilities.swift
//  FriendBooks
//
//  Created by Ky Nguyen on 9/22/15.
//  Copyright © 2015 Ky Nguyen. All rights reserved.
//

import Foundation

class GeneralHelper {
    
    func getLastestFriendID(friends: [Friend]) -> Int {
        
        var lastestIndex = 0
        
        for friend in friends {
            
            if friend.friendID >= lastestIndex {
                
                lastestIndex = friend.friendID
            }
        }
        
        return lastestIndex
    }
}