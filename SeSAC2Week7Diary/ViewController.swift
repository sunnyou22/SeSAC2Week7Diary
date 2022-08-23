//
//  ViewController.swift
//  SeSAC2Week7Diary
//
//  Created by 방선우 on 2022/08/16.
//

import UIKit
import SeSAC2UIFramwork

class ViewController: UIViewController {
    
    var name = "고래밥"
    
    private var age = 22
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        testOpen()
        
        let vc = CodeBase3ViewController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        
//        showSesacAlert(title: "테스트 얼럿", messagge: "테스트 메세지", buttonTitle: "변경") { _ in
//            self.view.backgroundColor = .lightGray
//        }
        
        //MARK: ActivityViewController
//        let image = UIImage(systemName: "star.fill")!
//        let shareURL = "https://www.appple.com"
//        let text = "WWDC"
//        sesacShowActivityViewController(shareImage: image, shareURL: shareURL, shareText: text)
        
        let web = OpenWebView.presentWebViewController(self, url: "https://www.naver.com", transitionStyle: .present)
    }
}

