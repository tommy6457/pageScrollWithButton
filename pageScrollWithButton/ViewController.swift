//
//  ViewController.swift
//  pageScrollWithButton
//
//  Created by 蔡尚諺 on 2022/2/1.
//

import UIKit

class ViewController: UIViewController {

    //Button
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBOutlet weak var underlineView: UIView!
    
    @IBOutlet weak var underlineViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var underlineViewCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var underlineViewTopConstraint: NSLayoutConstraint!
    
    //Pages
    var width: CGFloat?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var containerViews: [UIView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        let buttons = buttonStackView.subviews
        
//        for button in buttons {
//            let uibutton = button as! UIButton
//
//            uibutton.addTarget(self, action: #selector(changePage), for: .touchUpInside)
//        }
        
        for (index,button) in buttons.enumerated() {
            let uibutton = button as! UIButton
            uibutton.tag = index
            
            uibutton.addTarget(self, action: #selector(changePage), for: .touchUpInside)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        width = view.bounds.width
        
    }
    
    

    
    @objc func changePage(sender: UIButton){
        
        setButtonConstraint(button: sender)
        
        let targetX = CGFloat(sender.tag) * width!
        
        scrollView.setContentOffset(CGPoint(x: targetX, y: 0), animated: true)
    }
    
    func setButtonConstraint(button: UIButton){
        
        //先關閉
        underlineViewWidthConstraint.isActive = false
        underlineViewCenterXConstraint.isActive = false
        underlineViewTopConstraint.isActive = false
        //改值
        underlineViewWidthConstraint = underlineView.widthAnchor.constraint(equalTo: button.widthAnchor)
        underlineViewCenterXConstraint = underlineView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        underlineViewTopConstraint = underlineView.topAnchor.constraint(equalTo: button.bottomAnchor)
        //再Active
        underlineViewWidthConstraint.isActive = true
        underlineViewCenterXConstraint.isActive = true
        underlineViewTopConstraint.isActive = true
        
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.view.layoutIfNeeded()
        }.startAnimation()
        
    }
    
}

extension ViewController: UIScrollViewDelegate{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let width = width else { return }
        //targetContentOffset.pointee.x 除以 width一定會剛好，因為有paging enabled的關係
        let currentPage = Int(targetContentOffset.pointee.x / width)
        
        let buttons = buttonStackView.subviews
        let uibutton = buttons[currentPage] as! UIButton
        setButtonConstraint(button: uibutton)
        
    }
    
}
