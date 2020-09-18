//
//  EditView.swift
//  PDFViewer
//
//  Created by facebook on 11/15/18.
//  Copyright © 2018 Todd Kramer. All rights reserved.
//

import Foundation
import UIKit

class EditView: UIView {
    
    let yellow = UIColor.yellow.withAlphaComponent(1)
    
    var closeButton = UIButton(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
    var textField = UITextView(frame: CGRect(x: 10, y: 10, width: 400, height: 350))
    var submitButton = UIButton(frame: CGRect(x: 425, y: 425, width: 50, height: 50))

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
    
    //common func to init our view
    private func setupView(center: CGPoint) {
        self.center = center
        // Change UIView background colour
        self.backgroundColor=UIColor.white
        
        // Add rounded corners to UIView
        self.layer.cornerRadius=25
        
        // Add border to UIView
        self.layer.borderWidth=2
        
        self.layer.borderColor = UIColor.white.cgColor
        
        
        // Shadow and Radius for Circle Button
        closeButton.backgroundColor = UIColor.black
        closeButton.layer.shadowColor = UIColor.black.cgColor
        closeButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        closeButton.layer.masksToBounds = false
        closeButton.layer.shadowRadius = 1.0
        closeButton.layer.shadowOpacity = 0.5
        closeButton.layer.cornerRadius = closeButton.frame.width / 2
        
        
        let icon = UIImage(named: "baseline_close_white_48dp")!
        closeButton.setImage(icon, for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        
        textField.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Type some notes here!"
        
//        textField.layer.shadowColor = UIColor.black.cgColor
//        textField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        textField.layer.masksToBounds = false
//        textField.layer.shadowRadius = 1.0
//        textField.layer.shadowOpacity = 0.5
//        textField.layer.cornerRadius = 5
        
        
        submitButton.backgroundColor = yellow
        submitButton.layer.shadowColor = UIColor.black.cgColor
        submitButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        submitButton.layer.masksToBounds = false
        submitButton.layer.shadowRadius = 1.0
        submitButton.layer.shadowOpacity = 0.5
        submitButton.layer.cornerRadius = closeButton.frame.width / 2
        
        let icon2 = UIImage(named: "baseline_check_white_48dp")!
        submitButton.setImage(icon2, for: .normal)
        submitButton.imageView?.contentMode = .scaleAspectFit
        submitButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.addSubview(textField)
        self.addSubview(closeButton)
        self.addSubview(submitButton)
    }
}


/// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}
