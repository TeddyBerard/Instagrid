//
//  PictureView.swift
//  Instagrid
//
//  Created by Teddy Bérard on 16/06/2018.
//  Copyright © 2018 Teddy Bérard. All rights reserved.
//

import UIKit

class PictureView: UIView {

    @IBOutlet private var PictureTopLeft: UIButton!
    @IBOutlet private var PictureTopRight: UIButton!
    @IBOutlet private var PictureBotRight: UIButton!
    @IBOutlet private var PictureBotLeft: UIButton!
    
    enum Style {
        case Left, Middle, Right
    }
    
    var style: Style = .Middle {
        didSet {
            setStyle(style)
        }
    }
    
    public func captureView() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { (succes) in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    public func changePicture(name: String, image: UIImage) {
        switch name {
        case "PictureTopLeft":
            self.PictureTopLeft.setImage(image, for: .normal)
            self.PictureTopLeft.imageView?.contentMode = .scaleToFill
            break
        case "PictureTopRight":
            self.PictureTopRight.setImage(image, for: .normal)
            self.PictureTopRight.imageView?.contentMode = .scaleToFill
            break
        case "PictureBotLeft":
            self.PictureBotLeft.setImage(image, for: .normal)
            self.PictureBotLeft.imageView?.contentMode = .scaleToFill
            break
        case "PictureBotRight":
            self.PictureBotRight.setImage(image, for: .normal)
            self.PictureBotRight.imageView?.contentMode = .scaleToFill
            break
        default:
            break
        }
    }
    
    
    private func setStyle(_ style: Style) {
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
    
    private func setLeft() {
        PictureTopLeft.frame.size.width = 270
        
        PictureBotLeft.frame.size.width = 127.5
        PictureTopRight.isHidden = true
        PictureBotRight.isHidden = false
        animateSquare()
    }
    
    private func setMiddle() {
        PictureTopLeft.frame.size.width = 127.5
        PictureBotLeft.frame.size.width = 270
        PictureBotLeft.frame.size.height = 127.5
        PictureBotRight.isHidden = true
        PictureTopRight.isHidden = false
        animateSquare()
    }
    
    private func setRight() {
        PictureTopLeft.frame.size.width = 127.5
        PictureBotLeft.frame.size.width = 127.5
        PictureTopRight.isHidden = false
        PictureTopLeft.isHidden = false
        PictureBotLeft.isHidden = false
        PictureBotRight.isHidden = false
        animateSquare()
    }
    
    private func animateSquare() {
        PictureTopLeft.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        PictureBotRight.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        PictureBotLeft.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        PictureTopRight.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.PictureTopLeft.transform = .identity
            self.PictureBotRight.transform = .identity
            self.PictureBotLeft.transform = .identity
            self.PictureTopRight.transform = .identity
        }, completion: nil)
    }
}
