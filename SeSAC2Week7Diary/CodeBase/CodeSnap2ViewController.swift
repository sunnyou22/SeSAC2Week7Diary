//
//  CodeSnap2ViewController.swift
//  SeSAC2Week7Diary
//
//  Created by 방선우 on 2022/08/17.
//

import UIKit

import SnapKit

class CodeSnap2ViewController: UIViewController {

    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    let redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let yellowView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        [redView, blackView].forEach { // 여기 순서대로 추가됨
            view.addSubview($0)
        }
        
        // 여기서부터 놓침
        redView.addSubview(yellowView) //containerView, stackView => 이 두개는 addSubi
        
        redView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view)
        }
        
        blackView.snp.makeConstraints { make in
            make.edges.equalTo(redView).inset(50) //.offset(50)
        }
    }
}
