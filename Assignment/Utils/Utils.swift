//
//  Utils.swift
//  Assignment
//
//  Created by Ayan Chakraborty on 07/09/20.
//  Copyright © 2020 Assignment Ayan Chakraborty. All rights reserved.
//

import Foundation
import UIKit


func StrAny(_ item: Any?) -> String {
    if let val = item {
        return "\(val)"
    }
    return String(describing: item)
    
}

extension UIImageView {
    
    func downloadFromURL(url: String) {
        if let url = URL(string: url) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }else{
                        DispatchQueue.main.async {
                            self?.image = UIImage(named: "noImgFound")
                        }
                    }
                }
            }
        }else{
            self.image = UIImage(named: "noImgFound")
        }
        
    }
}

@IBDesignable
class CustomCardView: UIView {

    @IBInspectable var cornerRad: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.shadowRadius = newValue
            layer.masksToBounds = false
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            layer.shadowColor = UIColor.darkGray.cgColor
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            layer.shadowColor = UIColor.black.cgColor
            layer.masksToBounds = false
        }
    }

}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func toNSAttributedString() -> NSAttributedString {
        return NSMutableAttributedString(string: self)
    }
}

extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
