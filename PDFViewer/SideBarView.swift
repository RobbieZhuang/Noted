//
//  EditView.swift
//  PDFViewer
//
//  Created by facebook on 11/15/18.
//  Copyright © 2018 Todd Kramer. All rights reserved.
//

import Foundation
import UIKit

protocol SideBarViewDelegate {
    func animateIn()
}
class SideBarView: UIView {
    let yellow = UIColor.yellow.withAlphaComponent(1)
//    var closeButton = UIButton(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
    var textField = UITextView(frame: CGRect(x: 5, y: 7, width: 295, height: 35))
    var searchButton = UIButton(frame: CGRect(x: 350, y: 17, width: 40, height: 40))
    var delegate: SideBarViewDelegate?
    //initWithFrame to init view from code
    init(frame: CGRect, center: CGPoint) {
        super.init(frame: frame)
    
        setupView(center: center)
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ////        setupView()
    }
    @objc func customViewClick() {
        delegate?.animateIn()
    }
    
    //common func to init our view
    private func setupView(center: CGPoint) {
        
//        self.center = center
        // Change UIView background colour
        self.backgroundColor=UIColor.white
        
        // Add rounded corners to UIView
        self.layer.cornerRadius=25
        
        // Add border to UIView
        self.layer.borderWidth=2
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.5
        let gesture = UITapGestureRecognizer(target: self, action: #selector(customViewClick))
        self.addGestureRecognizer(gesture)
        
        // Shadow and Radius for Circle Button
//        closeButton.backgroundColor = UIColor.black
//        closeButton.layer.shadowColor = UIColor.black.cgColor
//        closeButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        closeButton.layer.masksToBounds = false
//        closeButton.layer.shadowRadius = 1.0
//        closeButton.layer.shadowOpacity = 0.5
//        closeButton.layer.cornerRadius = closeButton.frame.width / 2
//
        textField.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        textField.placeholder = "Search something!"
//        textField.font = 
        textField.backgroundColor = UIColor.white
        
        
        searchButton.backgroundColor = yellow//UIColor(displayP3Red: 255/255, green: 234/255, blue: 138/255, alpha: 1)
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchButton.layer.masksToBounds = false
        searchButton.layer.shadowRadius = 1.0
        searchButton.layer.shadowOpacity = 0.5
        searchButton.layer.cornerRadius = searchButton.frame.width / 2
//        searchButton.setImage(UIImage(named: "baseline-search-black-36dp.png"), for: .normal)
        let icon = UIImage(named: "baseline_search_black_36dp")!
        searchButton.setImage(icon, for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        self.addSubview(textField)
//        self.addSubview(closeButton)
        self.addSubview(searchButton)
    }
}
