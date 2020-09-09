//
//  RunningActivity.swift
//  CureMantra
//
//  Created by Ayan Chakraborty on 31/10/19.
//  Copyright © 2019 Debasish Bouri. All rights reserved.
//

import UIKit



class RunningActivity: UIView {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var indicatorView: UIView?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicatorView?.layer.cornerRadius = 8
        indicator.startAnimating()
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2024026113)
        self.indicatorView?.layer.cornerRadius = 12
    }
    
    class func show(for viewController: UIViewController?){
        let view = initFromNib()
        view.tag = 09815
        if let vc = viewController {
            view.frame = vc.view.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.translatesAutoresizingMaskIntoConstraints = true
        }
        viewController?.view.addSubview(view)
    }
    
    class func dismiss(for viewController: UIViewController?){
        if let views = viewController?.view.viewWithTag(09815){
            views.removeFromSuperview()
        }
    }
    
    deinit {
        print("$End: ", self)
    }
}

extension RunningActivity {
    
    @discardableResult
    class func show() -> RunningActivity {
        let view = initFromNib()
        view.tag = 09815
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        self.dismiss()
        DispatchQueue.main.async {
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                view.frame = window.bounds
                window.addSubview(view)
                window.bringSubviewToFront(view)
            }
        }
        return view as! RunningActivity

    }
    
    class func dismiss(){
        DispatchQueue.main.async {
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                if let views = window.viewWithTag(09815){
                    views.removeFromSuperview()
                }
            }
        }
    }
    
    func message(message msg: String?){
        self.message.text = msg
    }
    
    
}


extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
