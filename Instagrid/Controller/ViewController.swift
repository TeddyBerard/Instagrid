//
//  ViewController.swift
//  Instagrid
//
//  Created by Teddy Bérard on 15/06/2018.
//  Copyright © 2018 Teddy Bérard. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ArrangementLeft: UIButton!
    @IBOutlet weak var ArrangementMiddle: UIButton!
    @IBOutlet weak var ArrangementRight: UIButton!
    @IBOutlet weak var pictureView: PictureView!
    @IBOutlet weak var swipeImage: UIImageView!
    @IBOutlet weak var swipeLabel: UILabel!
    
    enum Arrangement {
        case Left, Middle, Right
    }
    
    var arrangement : Arrangement = .Middle
    var buttonSelected = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setArrangement()
        changeTextSwipeLabel()
        pictureView.style = .Middle
        let panGestureReconizer = UIPanGestureRecognizer(target: self, action: #selector(sendCreation(_:)))
        pictureView.addGestureRecognizer(panGestureReconizer)
    }
    
    @objc func sendCreation(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            transformPictureViewWith(gesture: sender)
            break
        case .cancelled, .ended:
            let translation = sender.translation(in: pictureView)
            print(translation.y)
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self.pictureView.transform = .identity
            }, completion: { (succes) in
                let image = self.pictureView.captureView()
                let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            })
            break
        default:
            break
        }
    }
    
    private func transformPictureViewWith(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: pictureView)
        let translationTransform = CGAffineTransform(translationX: translation.x , y: translation.y)
        
        pictureView.transform = translationTransform
    }
    
    func setArrangement() {
        switch self.arrangement {
        case .Left:
            pictureView.style = .Left
            ArrangementLeft.setImage(#imageLiteral(resourceName: "SelectedLeft"), for: .normal)
            ArrangementMiddle.setImage(#imageLiteral(resourceName: "Layout 2"), for: .normal)
            ArrangementRight.setImage(#imageLiteral(resourceName: "Layout 3"), for: .normal)
            break
        case .Middle:
            pictureView.style = .Middle
            ArrangementMiddle.setImage(#imageLiteral(resourceName: "SelectedMiddle"), for: .normal)
            ArrangementRight.setImage(#imageLiteral(resourceName: "Layout 3"), for: .normal)
            ArrangementLeft.setImage(#imageLiteral(resourceName: "Layout 1"), for: .normal)
            break
        case .Right:
            pictureView.style = .Right
            ArrangementRight.setImage(#imageLiteral(resourceName: "SelectedRight"), for: .normal)
            ArrangementMiddle.setImage(#imageLiteral(resourceName: "Layout 2"), for: .normal)
            ArrangementLeft.setImage(#imageLiteral(resourceName: "Layout 1"), for: .normal)
            break
        }
    }
    
    
    @IBAction func selectedLeftButton(_ sender: Any) {
        self.arrangement = .Left
        setArrangement()
    }
    
    @IBAction func selectedMiddleButton(_ sender: Any) {
        self.arrangement = .Middle
        setArrangement()
    }
    
    @IBAction func selectedRightButton(_ sender: Any) {
        self.arrangement = .Right
        setArrangement()
    }
    
    
    func changeTextSwipeLabel() {
        if UIDevice.current.orientation.isLandscape {
            swipeLabel.text = "Swipe left to share"
            swipeImage.image = #imageLiteral(resourceName: "chevron left")
        } else {
            swipeLabel.text = "Swipe up to share"
            swipeImage.image = #imageLiteral(resourceName: "chevron top")
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.changeTextSwipeLabel()
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            switch self.arrangement {
            case .Left:
                self.pictureView.style = .Left
                break
            case .Middle:
                self.pictureView.style = .Middle
                break
            case .Right:
                self.pictureView.style = .Right
                break
            }
        })
    }
    
    
    
    private func callPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let ac = UIAlertController(title: "Photo source", message: "Choose a method", preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
            
        }))
        
        ac.addAction(UIAlertAction(title: "Photo", style: .default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
           self.present(imagePicker, animated: true, completion: nil)
            
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (nil) in
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pictureView.changePicture(name: buttonSelected, image: pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func PictureTopLeftButton(_ sender: Any) {
        print("Ok")
        askPermissionPicture()
        buttonSelected = "PictureTopLeft"
    }
    
    @IBAction func PictureTopRightButton(_ sender: Any) {
        print("Ok")
        askPermissionPicture()
        buttonSelected = "PictureTopRight"
    }
    
    @IBAction func PictureBotLeftButton(_ sender: Any) {
        print("Ok")
        buttonSelected = "PictureBotLeft"
        askPermissionPicture()
    }
    
    @IBAction func PictureBotRightButton(_ sender: Any) {
        print("Ok")
        askPermissionPicture()
        buttonSelected = "PictureBotRight"
    }
    
    func askPermissionPicture() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.callPicker()
                }
                else {}
            })
        } else if photos == .authorized {
            self.callPicker()
        }
    }
    
    

}

