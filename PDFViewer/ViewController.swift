
//  Copyright © 2018 Todd Kramer. All rights reserved.

import UIKit
import PDFKit
import Starscream


class ViewController: UIViewController {
    
    // MARK: - Networking
    var socket = WebSocket(url: URL(string: "ws://40.117.127.142:22430/socket")!, protocols: ["chat"])
    let userName = "Robbie"
    // Must change line 47
    let textBookName = "ece106"
    // MARK: - Outlets

    let yellow = UIColor.yellow.withAlphaComponent(0.3)
    
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var pdfThumbnailView: PDFThumbnailView!
    @IBOutlet weak var sidebarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var appTitle: UINavigationItem!
    
    var editView: EditView?
    var readView: ReadView?
    var sideBarView: SideBarView?
    
    var dimmedBackground: UIView?
    var currentSelections: PDFSelection?
    var addText: String?
    
    var document: PDFDocument?
    
    var tempAnnotation: PDFAnnotation?
    var tempPageForAnnotation: Int?
    var curBounds: CGRect?
    var curSelected: String = ""
    
    var mostRecentlyAddedNote: Note?
    
    var notes: [Note] = []
    var annotations: [PDFAnnotation] = []
    // MARK: - Constants

    let thumbnailDimension = 44
    let pdfURL = Bundle.main.url(forResource: "ece106", withExtension: "pdf")
    let animationDuration: TimeInterval = 0.25
    let sidebarBackgroundColor = UIColor(named: "SidebarBackgroundColor")

    func sendQuery() {
        socket.write(string: "{ \"type\": \"load\", \"query\": \"ten\", \"docid\": \"ece106\" }")
    }
    
    @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
        let translation = recognizer.location(in: pdfView)
        
        let anotPoint = CGPoint(x: translation.x - 27, y:(translation.y - pdfView.frame.height + 5) * -1.0)
        
        if let pg = pdfView.page(for: anotPoint, nearest: true) {
            let annotationFind = pdfView.convert(translation, to: pg)
            
            if let anot = pg.annotation(at: annotationFind) {
                print("hit annotation")
                print(annotationFind.x)
                print(annotationFind.y)
                let curSelected = ""
                
                readView = ReadView(frame: CGRect(x: 10, y: 100, width: 500, height: 500), center: CGPoint(x: pdfView.frame.size.width / 2, y: pdfView.frame.size.height / 2), n: notes, x: anot.bounds.origin.x, y: anot.bounds.origin.y, hText1: curSelected)
                dimmedBackground = UIView(frame: CGRect(x: 0, y: 0, width: 2000, height: 2000))
                if let d = dimmedBackground {
                    d.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                    pdfView.addSubview(d)
                }
                if let v = readView {
                    self.view.addSubview(v)
                    v.closeButton.addTarget(self, action: #selector(closeView2), for: .touchUpInside)
                }
            }
        } else {
            
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.title = "Electricity & Magnetism"
        appTitle.title = "Intro to Mechanics"
//        appTitle.title = "ece106"
        addCustomMenu()
        socket.connect()
        socket.delegate = self
        setup()
        addObservers()
        
    }
    
    
    
    func websocketDisconnected(socket: WebSocketClient) {
        
    }
    
    
    func addCustomMenu() {
        let printToConsole = UIMenuItem(title: "Add Note", action: #selector(openSelectedText))
        UIMenuController.shared.menuItems = [printToConsole]
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        self.view.endEditing(true)
//    }
    
    @objc func openSelectedText() {
        print("Text select option")
        currentSelections = pdfView.currentSelection
        editView = EditView(frame: CGRect(x: 10, y: 100, width: 500, height: 500), center: CGPoint(x: pdfView.frame.size.width / 2, y: pdfView.frame.size.height / 2))
        if let v = editView {
            dimmedBackground = UIView(frame: CGRect(x: 0, y: 0, width: 2000, height: 2000))
            if let d = dimmedBackground {
                d.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                pdfView.addSubview(d)
            }
            self.view.addSubview(v)
            
            v.closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
            v.submitButton.addTarget(self, action: #selector(submitNotes), for: .touchUpInside)
        }
    }
    
    @objc func closeView() {
        if let v = editView {
            v.removeFromSuperview()
        }
        if let d = dimmedBackground {
            d.removeFromSuperview()
        }
        if let e = readView {
            e.removeFromSuperview()
        }
        self.pdfView.isUserInteractionEnabled = true
    }
    
    @objc func closeView2() {
        if let d = dimmedBackground {
            d.removeFromSuperview()
        }
        if let e = readView {
            e.removeFromSuperview()
        }
        self.pdfView.isUserInteractionEnabled = true
    }
    
    @objc func submitNotes() {
        if let v = editView {
            addText = v.textField.text
            print("Submitting Notes")
            curBounds = currentSelections!.bounds(for: pdfView.currentPage!)
            
            curSelected = ""
            
            for s in pdfView?.currentSelection?.selectionsByLine() ?? [] {
                if let tempStr = s.string {
                    curSelected = curSelected + tempStr
                }
            }
            tempPageForAnnotation = Int(pdfView.currentPage!.label!)! - 1
            
            let d: [String: Any] = [
                "x" : curBounds!.origin.x,
                "y" : curBounds!.origin.y,
                "h" : curBounds!.size.height,
                "w" : curBounds!.size.width,
                "message" : addText!,
                "page" : tempPageForAnnotation!,
                "type" : "createNote",
                "docid" : textBookName,
                "user": userName,
                "selected": curSelected
            ]
            
//            let coolColour = generateRandomPastelColor()
            tempAnnotation = PDFAnnotation(bounds: CGRect(x: curBounds!.origin.x, y: curBounds!.origin.y, width: curBounds!.size.width, height: curBounds!.size.height), forType: PDFAnnotationSubtype.freeText, withProperties: nil)
            tempAnnotation?.color = yellow
            tempAnnotation?.interiorColor = yellow
            tempAnnotation?.backgroundColor = yellow
//            tempAnnotation?.color = coolColour.withAlphaComponent(0.5)
//            tempAnnotation?.interiorColor = coolColour.withAlphaComponent(0.5)
//            tempAnnotation?.backgroundColor = coolColour.withAlphaComponent(0.5)
            tempAnnotation?.fontColor = UIColor.black
            tempAnnotation?.isHighlighted = true
            tempAnnotation?.fieldName = "What theeee this is test"
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                socket.write(string: String(data: jsonData, encoding: .utf8) ?? "apple juice")
            
            } catch {
                print(error.localizedDescription)
            }
            
            v.removeFromSuperview()
        }
        if let d = dimmedBackground {
            d.removeFromSuperview()
        }
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.scalePDFViewToFit()
        }, completion: nil)
    }

    deinit {
        removeObservers()
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
    // MARK: - Setup

    func setup() {
        setupThumbnailView()
        toggleSidebar()
        loadPDF()
        scalePDFViewToFit()
        loadSideBar()
    }

    func loadSideBar() {
         sideBarView = SideBarView(frame: CGRect(x: -300, y: 100, width: 400, height: 70), center: CGPoint(x: pdfView.frame.size.width / 2, y: pdfView.frame.size.height / 2))
        if let v = sideBarView{
            self.view.addSubview(v)
            v.delegate = self
            v.searchButton.addTarget(self, action: #selector(filterAnotes), for: .touchUpInside)
        }
    }
    @objc func filterAnotes() {
        print("Filter")
        if let v = sideBarView {
//            dimmedBackground = UIView(frame: CGRect(x: 0, y: 0, width: 2000, height: 2000))
//            if let d = dimmedBackground {
//                d.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//                pdfView.addSubview(d)
//            }
//            self.view.addSubview(v)
            let s = v.textField.text!
            print("Search term " + s )
            // remove all annotations
            let pdfPages = document?.pageCount
            for i in 0...pdfPages! {
                if let page = document?.page(at: i) {
                    let annotes = page.annotations
                    for an in annotes {
                        page.removeAnnotation(an)
                    }
                }
            }
                
            // add new ones in
            let q = "{\"type\": \"load\", \"query\": \"" + s + "\", \"docid\": \"" + textBookName + "\"}"
            print(q)
            socket.write(string: q)
            animateIn()
        }
    }
    
    
    
    func setupPDFView() {
        pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
    }

    func setupThumbnailView() {
        pdfThumbnailView.pdfView = pdfView
        pdfThumbnailView.thumbnailSize = CGSize(width: thumbnailDimension, height: thumbnailDimension)
        pdfThumbnailView.backgroundColor = sidebarBackgroundColor
    }

    func loadPDF() {
        guard let url = pdfURL else { return }
        document = PDFDocument(url: url)
        
        pdfView.document = document
        pdfView.displayMode = .singlePageContinuous
        resetNavigationButtons()
    }
    
    func generateRandomPastelColor() -> UIColor {
        // Randomly generate number in closure
//        let randomColorGenerator = { ()-> CGFloat in
//            CGFloat(arc4random() % 256 ) / 256
//        }
//
//        var red: CGFloat = randomColorGenerator()
//        var green: CGFloat = randomColorGenerator()
//        var blue: CGFloat = randomColorGenerator()
//
        
        let c1 = UIColor(red: 227, green: 208, blue: 255, alpha: 1)
        let c2 = UIColor(red: 180, green: 225, blue: 250, alpha: 1)
        let c3 = UIColor(red: 255, green: 234, blue: 138, alpha: 1)
        let c4 = UIColor(red: 183, green: 236, blue: 236, alpha: 1)
        let c5 = UIColor(red: 255, green: 197, blue: 139, alpha: 1)
        
        var colours = [c1,c2,c3,c4,c5]
        colours.shuffle()
        return colours[0]
    }
    
    
    func createAnnotations() {
        for n in notes {
            let tempAnnotation = PDFAnnotation(bounds: CGRect(x: n.x!, y: n.y!, width: n.w!, height: n.h!), forType: PDFAnnotationSubtype.freeText, withProperties: nil)
//            let coolColour = generateRandomPastelColor()
            tempAnnotation.color = yellow
            tempAnnotation.interiorColor = yellow
            tempAnnotation.backgroundColor = yellow
            tempAnnotation.fontColor = UIColor.black
            tempAnnotation.isHighlighted = true
            tempAnnotation.fieldName = "What theeee this is test"
            
            if let pg = document?.page(at: n.page!) {
                pg.addAnnotation(tempAnnotation)
                annotations.append(tempAnnotation)
            }
        }
    }
    
    func removeAnnotation(n: Note) {
        if let pg = document?.page(at: n.page!) {
            for i in 0 ..< annotations.count {
                if abs(Double(annotations[i].bounds.origin.x) - n.x!) < 10 && abs(Double(annotations[i].bounds.origin.y) - n.y!) < 10 {
                    pg.removeAnnotation(annotations[i])
                }
            }
        }
    }

    // MARK: - Notifications

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(resetNavigationButtons), name: .PDFViewPageChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name:
            UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        editView?.frame.origin.y -= keyboardFrame.height/2
    
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        editView?.frame.origin.y += keyboardFrame.height/2
        
    }
    
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Actions

    @IBAction func sidebarTapped(_ sender: Any) {
        toggleSidebar()
    }

    @IBAction func resetTapped(_ sender: Any) {
        scalePDFViewToFit()
    }

    @IBAction func previousTapped(_ sender: Any) {
        pdfView.goToPreviousPage(sender)
    }

    @IBAction func nextTapped(_ sender: Any) {
        pdfView.goToNextPage(sender)
    }

    // MARK: - Logic

    func toggleSidebar() {
        let thumbnailViewWidth = pdfThumbnailView.frame.width
        let screenWidth = UIScreen.main.bounds.width
        let multiplier = thumbnailViewWidth / (screenWidth - thumbnailViewWidth) + 1.0
        let isShowing = sidebarLeadingConstraint.constant == 0
        let scaleFactor = pdfView.scaleFactor
        UIView.animate(withDuration: animationDuration) {
            self.sidebarLeadingConstraint.constant = isShowing ? -thumbnailViewWidth : 0
            self.pdfView.scaleFactor = isShowing ? scaleFactor * multiplier : scaleFactor / multiplier
            self.view.layoutIfNeeded()
        }
    }

    func scalePDFViewToFit() {
        UIView.animate(withDuration: animationDuration) {
            self.pdfView.scaleFactor = 1.18
            self.view.layoutIfNeeded()
        }
    }

    @objc func resetNavigationButtons() {
        previousButton.isEnabled = pdfView.canGoToPreviousPage
        nextButton.isEnabled = pdfView.canGoToNextPage
    }
}


class ImageStampAnnotation: PDFAnnotation {
    
    var image: UIImage!
    
    // A custom init that sets the type to Stamp on default and assigns our Image variable
    init(with image: UIImage!, forBounds bounds: CGRect, withProperties properties: [AnyHashable : Any]?) {
        super.init(bounds: bounds, forType: PDFAnnotationSubtype.stamp, withProperties: properties)
        
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        
        // Get the CGImage of our image
        guard let cgImage = self.image.cgImage else { return }
        
        // Draw our CGImage in the context of our PDFAnnotation bounds
        context.draw(cgImage, in: self.bounds)
        
    }
}

// MARK: - FilePrivate
extension ViewController {
    
    fileprivate func sendMessage(_ message: String) {
        socket.write(string: message)
    }
    
    fileprivate func messageReceived(_ message: String, senderName: String) {
        
    }
}

extension ViewController: SideBarViewDelegate {
    func animateIn() {
        print("Touched sidebar")
        UIView.animate(withDuration: 1, animations: {
            if (Double(self.sideBarView?.frame.origin.x ?? -1) < 0.0) {
                self.sideBarView?.frame.origin.x += 300
            }
            else {
                self.sideBarView?.frame.origin.x -= 300
            }
        })
    }
}

