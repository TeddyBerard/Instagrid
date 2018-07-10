//
//  ViewController.swift
//  Instagrid
//
//  Created by Teddy Bérard on 15/06/2018.
//  Copyright © 2018 Teddy Bérard. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var ArrangementLeft: UIButton!
    @IBOutlet weak var ArrangementMiddle: UIButton!
    @IBOutlet weak var ArrangementRight: UIButton!
    @IBOutlet weak var pictureView: PictureView!
    @IBOutlet weak var swipeImage: UIImageView!
    @IBOutlet weak var swipeLabel: UILabel!
    
    var translation = CGPoint(x: 0.00, y: 0.00)
    var selectedPicture = Picture()
    

    enum Arrangement {
        case Left, Middle, Right
    }
    
    var arrangement : Arrangement = .Middle
    var buttonSelected : UIButton?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setArrangement()
        changeTextSwipeLabel()
        pictureView.style = .Middle
        let panGestureReconizer = UIPanGestureRecognizer(target: self, action: #selector(sendCreation(_:)))
        pictureView.addGestureRecognizer(panGestureReconizer)
    }
    
    @objc func sendCreation(_ sender: UIPanGestureRecognizer) { // send the creation with some animation
        switch sender.state {
        case .began, .changed:
            transformPictureViewWith(gesture: sender)
            break
        case .cancelled, .ended:
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self.translation = sender.translation(in: self.pictureView) // model 
                if UIDevice.current.orientation.isLandscape && self.translation.x < -1.00 {
                    self.pictureView.transform = CGAffineTransform(translationX: -1000.00, y: self.translation.y)
                } else if UIDevice.current.orientation.isPortrait && self.translation.y < -1.00 {
                    self.pictureView.transform = CGAffineTransform(translationX: self.translation.x, y: -1000.00)
                } else {
                    self.pictureView.transform = .identity
                }
            }, completion: { (succes) in
                print(self.translation)
                if UIDevice.current.orientation.isLandscape && self.translation.x < -1.00 {
                    self.sharePicture()
                } else if UIDevice.current.orientation.isPortrait && self.translation.y < -1.00 {
                    self.sharePicture()
                }
            })
            break
        default:
            break
        }
    }
   
    private func sharePicture() { // call the shared view Model
        let image = self.pictureView.captureView()
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityViewController,animated: true, completion: {})
        activityViewController.completionWithItemsHandler = { activity, succes, items, error in
            self.pictureView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self.pictureView.transform = .identity
            }, completion: nil)
        }
    }
    
    private func transformPictureViewWith(gesture: UIPanGestureRecognizer) { // add gesture for move the view question
        let translation = gesture.translation(in: pictureView)
        let translationTransform = CGAffineTransform(translationX: translation.x , y: translation.y)
        pictureView.transform = translationTransform
    }
    
    func setArrangement() { // set the arrangement of the view question
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
    
    
    @IBAction func selectedLeftButton(_ sender: Any) { // Action for change the arrangement of picture
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
    
    
    func changeTextSwipeLabel() { // Change text and image
        if UIDevice.current.orientation.isLandscape {
            swipeLabel.text = "Swipe left to share"
            swipeImage.image = #imageLiteral(resourceName: "chevron left")
        } else {
            swipeLabel.text = "Swipe up to share"
            swipeImage.image = #imageLiteral(resourceName: "chevron top")
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) { // Recall the style when the user change orientation of photne
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
    
    
    
    private func callPicker() { // Print the Alert so that the user can choose method to take picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let ac = UIAlertController(title: "Photo source", message: "Choisissez Camera pour prendre une photo ou Photo pour sélectionner une photo depuis votre photothèque.", preferredStyle: .actionSheet)
    
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
    
    
    @IBAction func PictureTopLeftButton(_ sender: Any) { // Action for select the method for select the picture and know which are selected
        askPermissionPicture()
       // self.selectedPicture
        if let button = sender as? UIButton {
            buttonSelected = button
        }
    }
    
    @IBAction func PictureTopRightButton(_ sender: Any) {
        askPermissionPicture()
        if let button = sender as? UIButton {
            buttonSelected = button
        }
    }
    
    @IBAction func PictureBotLeftButton(_ sender: Any) {
        askPermissionPicture()
        if let button = sender as? UIButton {
            buttonSelected = button
        }
    }
    
    @IBAction func PictureBotRightButton(_ sender: Any) {
        askPermissionPicture()
        if let button = sender as? UIButton {
            buttonSelected = button
        }
    }
    
    func askPermissionPicture() { // Ask the permission for select or take picture /!\ Important
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

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { // Call the function for change the picture when the user valid a picture
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedPicture.selectedPicture = pickedImage
        }
        picker.dismiss(animated: true, completion: {
            var image = UIImage()
            image = self.selectedPicture.selectedPicture
            self.buttonSelected?.setImage(image, for: .normal)
            //
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { // dismiss the view of photo library or camera when the user stop it
        picker.dismiss(animated: true, completion: nil)
    }

}

