//
//  FirstViewController.swift
//  SeSAC2UIFramwork
//
//  Created by 방선우 on 2022/08/16.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var stratImageView: UIImageView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var tutorialLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stratImageView.image = UIImage(systemName: "star.fill")
        stratImageView.tintColor = .systemGray4
        
        tutorialLabel.numberOfLines = 0
        tutorialLabel.font = .boldSystemFont(ofSize: 25)
        tutorialLabel.backgroundColor = .red
        tutorialLabel.text = """
        일기 씁시다!
        잘 써봅시다!
        """
        
        blackView.backgroundColor = .black
        blackView.alpha = 0
        
        tutorialLabel.alpha = 0 //투명해서 안보임
        UIView.animate(withDuration: 3) {
            self.tutorialLabel.alpha = 1
            self.tutorialLabel.backgroundColor = .yellow
        } completion: { _ in
            self.animateBlackView()
        }

    }
    
    func animateBlackView() {
        
        UIView.animate(withDuration: 1) {
            self.blackView.frame.size.width += 250
            self.blackView.alpha = 1
        } completion: { _ in
        
            self.blackView.transform = CGAffineTransform(scaleX: 3, y: 1)
            self.blackView.alpha = 1
            self.animateImageView()
        }
    }
    
    func animateImageView() {
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
            self.stratImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
//            <#code#>
        }

    }
}
    


//func animateBlackView() {

//UIView.animate(withDuration: 2) {
//    self.blackView.frame.size.width += 250
//    self.blackView.alpha = 1
//} completion: { _ in
//

//    UIView.animate(withDuration: 2) {
//        self.blackViewWidth.constant += 200
//        self.blackView.alpha = 1
//    } completion: { _ in
//
//    }
//
//}
