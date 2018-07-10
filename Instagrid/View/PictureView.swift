//
//  PictureView.swift
//  Instagrid
//
//  Created by Teddy Bérard on 16/06/2018.
//  Copyright © 2018 Teddy Bérard. All rights reserved.
//

import UIKit

class PictureView: UIView {

    @IBOutlet private var pictureTopLeft: UIButton!
    @IBOutlet private var pictureTopRight: UIButton!
    @IBOutlet private var pictureBotRight: UIButton!
    @IBOutlet private var pictureBotLeft: UIButton!
    
    enum Style {
        case Left, Middle, Right
    }
    
    var style: Style = .Middle {
        didSet {
            setStyle(style)
        }
    }
    
    public func captureView() -> UIImage { // capture the view in UIImage and return it
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { (succes) in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    
    private func setStyle(_ style: Style) { // set the style
        switch style {
        case .Left:
            setLeft()
            break
        case .Middle:
            setMiddle()
            break
        case .Right:
            self.setRight()
            break
        }
    }
    
    private func setLeft() { // set the view for the arregment left
        pictureTopLeft.frame.size.width = pictureTopRight.frame.size.width * 2 + 15
        pictureBotLeft.frame.size.width = pictureBotRight.frame.size.width
        pictureTopRight.isHidden = true
        pictureBotRight.isHidden = false
        self.pictureTopLeft.imageView?.contentMode = .center
        self.pictureBotLeft.imageView?.contentMode = .scaleToFill
        animateSquare()
    }
    
    private func setMiddle() {
        pictureTopLeft.frame.size.width = pictureTopRight.frame.size.width
        pictureBotLeft.frame.size.width = pictureBotRight.frame.size.width * 2 + 15
        pictureBotRight.isHidden = true
        pictureTopRight.isHidden = false
        self.pictureTopLeft.imageView?.contentMode = .scaleToFill
        self.pictureBotLeft.imageView?.contentMode = .center

        animateSquare()
    }
    
    private func setRight() {
        pictureTopLeft.frame.size.width = pictureTopRight.frame.size.width
        pictureBotLeft.frame.size.width = pictureTopRight.frame.size.width
        pictureTopRight.isHidden = false
        pictureTopLeft.isHidden = false
        pictureBotLeft.isHidden = false
        pictureBotRight.isHidden = false
        
        self.pictureBotLeft.imageView?.contentMode = .scaleToFill
        self.pictureTopLeft.imageView?.contentMode = .scaleToFill
        animateSquare()
    }
    
    private func animateSquare() { // Animate the view when a arragement are selected
        pictureTopLeft.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        pictureBotRight.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        pictureBotLeft.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        pictureTopRight.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.pictureTopLeft.transform = .identity
            self.pictureBotRight.transform = .identity
            self.pictureBotLeft.transform = .identity
            self.pictureTopRight.transform = .identity
        }, completion: nil)
    }
}
