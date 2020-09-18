//
//  EditView.swift
//  PDFViewer
//
//  Created by facebook on 11/15/18.
//  Copyright © 2018 Todd Kramer. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import CardParts


class ReadView: UIView {
    
    var closeButton = UIButton(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
    
    var texts: [String] = ["abc"]
    
    var notes: [Note] = []
    var xC: CGFloat = 0
    var yC: CGFloat = 0
    var hText: String = "******"
    
    //initWithFrame to init view from code
    init(frame: CGRect, center: CGPoint, n: [Note], x: CGFloat, y: CGFloat, hText1: String) {
        super.init(frame: frame)
        notes = n
        print(n)
        xC = x
        yC = y
        hText = hText1
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
        
        self.addSubview(closeButton)
        
//        var s = ""
//
//        for c in notes {
//            s += c.message ?? "Temp" + "\n"
//        }
//        print(notes)
//        var lbl = UILabel(frame: CGRect(x: 50, y: 50, width: 400, height: 400))
//        lbl.message = s
//        self.addSubview(lbl)
        let cards = MyCardsViewController(n: notes, x: xC, y: yC, hText1: hText)
        cards.view.frame = CGRect(x: 10, y: 75, width: 480, height: 400)
        cards.view.backgroundColor = UIColor.white
        self.addSubview(cards.view)
    }
}

class MyCardsViewController: CardsViewController {
    
    var cards: [CardController] = []
    var notes: [Note]!
    
    var xG: CGFloat = 0
    var yG: CGFloat = 0
    var hText: String = "******"
    
    init(n: [Note], x: CGFloat, y: CGFloat, hText1: String) {
        super.init(nibName: nil, bundle: nil)
        notes = n
        xG = x
        yG = y
        hText = hText1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for things in notes {
            print(hText + " ||| " + things.selected!)
            
            if (abs(Double(xG) - things.x!) < 0.1 && abs(Double(yG) - things.y!) < 0.1) {
                print(things.message ?? "L")
                cards.append(CardPartTextViewCardController(n: things.message ?? "No content"))
            }
        }
        
        loadCards(cards: cards)
    }
}

class CardPartTextViewCardController: CardPartsViewController {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    var name: String?
    init(n: String) {
        super.init(nibName: nil, bundle: nil)
        name = n
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = name!
        
        setupCardParts([cardPartTextView])
    }
}

//class TestViewModel {
//
//    let name: String!
//
//    init() {
//
//    }
//}

