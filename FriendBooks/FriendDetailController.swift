//
//  FriendDetailController.swift
//  FriendBooks
//
//  Created by Ky Nguyen on 9/22/15.
//  Copyright © 2015 Ky Nguyen. All rights reserved.
//

import UIKit

protocol FriendDetailDelegate : class {
    
    func addNewFriend(controller: FriendDetailController, friend: Friend)
    func update(controller: FriendDetailController, friend: Friend)
    
}

class FriendDetailController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var editedFriend: Friend?

    var changeAvatar = false
    var changeCover = false
    
    var delegate: FriendDetailDelegate?
    
    @IBOutlet weak var friendName: UITextField!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var cover: UIImageView!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var avatarContainer: UIView!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func save(sender: AnyObject) {
        
        if editedFriend != nil {
            
            update()
        }
        else {
            
            self.addNewFriend()
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        
        prepareEvent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func prepareUI() {
        
        if editedFriend != nil {
            
            fetchDataToUI()
        }
        else {
            
            friendName.becomeFirstResponder()
        }
        
        decorateAvatar()
    }

    func fetchDataToUI() {
        
        friendName.text = editedFriend?.name
        email.text = editedFriend?.email
        phone.text = editedFriend?.phone
        
        if let avatarData = editedFriend?.avatar {
            
            avatar.image = UIImage(data: avatarData)
        }
        
        if let coverData = editedFriend?.cover {
            
            cover.image = UIImage(data: coverData)
        }
    }
    
    func decorateAvatar() {
        
        avatarContainer.layer.borderColor = UIColor.whiteColor().CGColor
        avatarContainer.layer.borderWidth = 2.0
        avatarContainer.layer.cornerRadius = avatarContainer.frame.size.width / 2
        avatarContainer.clipsToBounds = true
    }
    
    func prepareEvent() {
        
        registerAvatarTap()
        
        registerCoverTap()
    }
    
    func addNewFriend() {
        
        let friend = saveNewFriendInfo()
        
        delegate?.addNewFriend(self, friend: friend)
    }
    
    func saveNewFriendInfo() -> Friend {
        
        let friend = Friend()
        
        friend.friendID = appDelegate.lastestID
        appDelegate.lastestID++
        
        saveFriendInfo(friend)
        
        return friend
    }
    
    func update() {
        
        saveFriendInfo(editedFriend!)
        
        delegate?.update(self, friend: editedFriend!)
    }
    
    func saveFriendInfo(friend: Friend) {
        
        friend.name = friendName.text!
        friend.phone = phone.text!
        friend.email = email.text!
        
        if let image = avatar.image {
            
            friend.avatar = UIImageJPEGRepresentation(image, 1)
        }
        
        if let image = cover.image {
            
            friend.cover = UIImageJPEGRepresentation(image, 1)
        }
    }
    
    func registerCoverTap() {
        
        registerImageTap(cover, funcName: "pickCover")
    }
    
    func pickCover() {
        
        showImagePicker()
        changeCover = true
    }
    
    func registerAvatarTap() {
        
        registerImageTap(avatar, funcName: "pickAvatar")
    }

    func pickAvatar() {
        
        showImagePicker()
        changeAvatar = true
    }
    
    func registerImageTap(imageView: UIImageView, funcName: String) {
        
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: Selector(funcName)))
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        if changeCover == true {
            
            cover.image = chosenImage
            changeCover = false
        }
        else if changeAvatar == true {

            avatar.image = chosenImage
            changeAvatar = false
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showImagePicker() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }

}
