//
//  EntryViewController.swift
//  PDFViewer
//
//  Created by facebook on 11/16/18.
//  Copyright © 2018 Todd Kramer. All rights reserved.
//

import Foundation
import UIKit

class EntryViewController: UIViewController {
    
//    @IBOutlet weak var getStartedButton: UIButton!
//    var getStartedButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
//    let vc = ViewController() //your view controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
//        getStartedButton.center = CGPoint(x: self.view.frame.size.width  / 2,
//                                          y: self.view.frame.size.height / 2)
//        getStartedButton.frame.origin.y = 600
//        // Do any additional setup after loading the view, typically from a nib.
//        getStartedButton.backgroundColor = UIColor(red: 255/255, green: 234/255, blue: 138/255, alpha: 1)
//        getStartedButton.layer.shadowColor = UIColor.black.cgColor
//        getStartedButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        getStartedButton.layer.masksToBounds = false
//        getStartedButton.layer.shadowRadius = 1.0
//        getStartedButton.layer.shadowOpacity = 0.5
//        getStartedButton.layer.cornerRadius = 4
//        getStartedButton.addTarget(self, action: #selector(goodTimes), for: .touchUpInside)
////        self.view.addSubview(getStartedButton)
//    }
//    @objc func goodTimes() {
////        self.present(vc, animated: true, completion: nil)
////        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "PDFView") as! ViewController
////        self.navigationController!.pushViewController(VC1, animated: true)
//        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//        if let navController = VC1.navigationController { // Creating a navigation controller with VC1 at the root of the navigation stack.
//            self.present(navController, animated:true, completion: nil)
//        }
//    }
}

@IBDesignable class MyButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
