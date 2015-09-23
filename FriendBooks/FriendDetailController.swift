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
    func saveEdit(controller: FriendDetailController, friend: Friend)
    
}

class FriendDetailController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    
    var editedFriend: Friend?
    var mode: Mode = Mode.View
    var changeAvatar = false
    var changeCover = false
    
    var delegate: FriendDetailDelegate?
    
    @IBOutlet weak var friendName: UITextField!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var cover: UIImageView!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var avatarContainer: UIView!
    
    
    @IBOutlet weak var editSaveButton: UIBarButtonItem!
    
    @IBAction func editSave(sender: AnyObject) {
        
        switch mode {
            
        case Mode.Add:
            addNewFriend()
            
        case Mode.Edit:
            saveEdit()
            
        default: // View
            edit()
            
        }
    }
    
    func addNewFriend() {
        
        let friend = Friend()
        friend.friendID = appDelegate.lastestID
        appDelegate.lastestID++
        saveFriendInfo(friend)

        delegate?.addNewFriend(self, friend: friend)
    }

    func saveEdit() {
        
        saveFriendInfo(editedFriend!)
    
        delegate?.saveEdit(self, friend: editedFriend!)
    }

    func saveFriendInfo(friend: Friend) {
        
        friend.name = friendName.text!
        friend.phone = phone.text!
        friend.email = email.text!
    }
    
    func edit() {
        
        mode = Mode.Edit
        switchMode()
    }
    
    @IBAction func back(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    func fetchDataToUI() {
        
        friendName.text = editedFriend?.name
        
//        avatar.image = UIImage(named: (friend?.avatar)!)
//        cover.image = UIImage(named: (friend?.cover)!)
        email.text = editedFriend?.email
        phone.text = editedFriend?.phone
    }
    
    func decorateAvatar() {
        
        avatarContainer.layer.borderColor = UIColor.whiteColor().CGColor
        avatarContainer.layer.borderWidth = 2.0
        avatarContainer.layer.cornerRadius = avatarContainer.frame.size.width / 2
        avatarContainer.clipsToBounds = true
    }
    
    
    func switchMode() {
        
        switch mode {
            
        case Mode.Add, Mode.Edit:
            phone.enabled = true
            email.enabled = true
            friendName.enabled = true
            
            friendName.becomeFirstResponder()
            
            editSaveButton.title = "Save"

        default:
            email.enabled = false
            phone.enabled = false
            friendName.enabled = false
            
            editSaveButton.title = "Edit"
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == Mode.View {
            
            fetchDataToUI()
        }
        
        decorateAvatar()
        
        switchMode()
        
        registerAvatarTap()
        
        registerCoverTap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func registerImageTap(imageView: UIImageView, funcName: String) {
        
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: Selector(funcName)))
    }
    
    func registerCoverTap() {
        
        registerImageTap(cover, funcName: "pickCover")
    }
    
    func registerAvatarTap() {
        
        registerImageTap(avatar, funcName: "pickAvatar")
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
    
    func pickCover() {
        
        showImagePicker()
        changeCover = true
    }
    
    func pickAvatar() {
        
        showImagePicker()
        changeAvatar = true
    }
    
    func showImagePicker() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }

}

enum Mode {
    
    case View
    
    case Edit

    case Add
}

