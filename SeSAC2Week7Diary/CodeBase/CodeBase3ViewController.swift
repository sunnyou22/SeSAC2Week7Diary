//
//  CodeBase3ViewController.swift
//  SeSAC2Week7Diary
//
//  Created by 방선우 on 2022/08/17.
//

/*
 백그라운드 이미지뷰

 하위 요소들의 컬러는 이미지뷰를 제외하고 흰색
 버튼 7개 d
 프로필 사진 이미지뷰 -> 코너레디오스 d
 레이블 5개 d
 섹션나누는 뷰 1개
 
 레이아웃 잡기
 */



import UIKit
import SnapKit

class CodeBase3ViewController: UIViewController {
    
    
    //MARK: 섹션 뷰
    let sectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    //MARK: 카톡이미지 배경 => 뒤에 이미지 어둡게
    let backgrountImageView: UIImageView = {
        let url = "https://i.pinimg.com/736x/a6/4b/13/a64b136846e4da45b637bf9d4c570b6d.jpg"
        let data = try! Data(contentsOf: URL(string: url)!)
        let view = UIImageView()
        view.image = UIImage(data: data)
        view.layer.opacity = 0.5
        
        return view
    }()

   //MARK: 프로필 사진
   let profileImageView: UIImageView = {
       let url = "https://image.dongascience.com/Photo/2020/03/5bddba7b6574b95d37b6079c199d7101.jpg"
       let data = try! Data(contentsOf: URL(string: url)!)
       let view = UIImageView()
       view.image = UIImage(data: data)
       view.clipsToBounds = true
       view.layer.cornerRadius = 15
       
       return view
   }()
   
   //MARK: 버튼
   let xmarkButton: UIButton = {
       let view = UIButton()
       view.setImage(UIImage(systemName: SystemName.xmark.rawValue, withConfiguration: CodeBase3ViewController.buttonConfig), for: .normal)
       return view
   }()
   
   let giftButton: UIButton = {
       let view = UIButton()
       view.setImage(UIImage(systemName: SystemName.giftcircle.rawValue, withConfiguration: CodeBase3ViewController.buttonConfig), for: .normal)
       return view
   }()
   
   let sendMoneyButton: UIButton = {
       let view = UIButton()
       view.setImage(UIImage(systemName: SystemName.sendMoney.rawValue, withConfiguration: CodeBase3ViewController.buttonConfig), for: .normal)
       return view
   }()
   
   let settingButton: UIButton = {
       let view = UIButton()
       view.setImage(UIImage(systemName: SystemName.gearshapecircle.rawValue, withConfiguration: CodeBase3ViewController.buttonConfig), for: .normal)
       return view
   }()
   
   let chatButton: UIButton = {
       let view = UIButton()
       view.setImage(UIImage(systemName: SystemName.chat.rawValue, withConfiguration: CodeBase3ViewController.buttonConfig), for: .normal)
       return view
   }()
 
   let editButton: UIButton = {
       let view = UIButton()
       view.setImage(UIImage(systemName: SystemName.edit.rawValue, withConfiguration: CodeBase3ViewController.buttonConfig), for: .normal)
       return view
   }()
   
   let kakaoStoryButton: UIButton = {
       let view = UIButton()
       view.setImage(UIImage(systemName: SystemName.kakaoStory.rawValue, withConfiguration: CodeBase3ViewController.buttonConfig), for: .normal)
       return view
   }()
   
   //MARK: 레이블
   
   let usernameLabel: UILabel = {
       let view = UILabel()
       view.text = "방선우"
       view.textColor = .white
       view.font = UIFont.semibold16
       
       return view
   }()

let userstateLabel: UILabel = {
   let view = UILabel()
   view.text = "안녕하세요"
   view.textColor = .white
   view.font = UIFont.normalLabel14
   
   return view
}()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatButton.configuration = .setbottomButtonsConfig(title: "나와의 채팅", systemImageString: .chat)
        editButton.configuration = .setbottomButtonsConfig(title: "프로필 편집", systemImageString: .edit)
        kakaoStoryButton.configuration = .setbottomButtonsConfig(title: "카카오 스토리", systemImageString: .kakaoStory)
        
        [backgrountImageView, xmarkButton, settingButton, sendMoneyButton, giftButton, editButton, chatButton, kakaoStoryButton, sectionView, usernameLabel, userstateLabel, profileImageView].forEach { view.addSubview($0) }
    
        backgrountImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        xmarkButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        sendMoneyButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(settingButton.snp.leading).offset(-16)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
//
        giftButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(sendMoneyButton.snp.leading).offset(-16)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
//
        editButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(view)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
//
        chatButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.trailing.equalTo(editButton.snp.leadingMargin).offset(-16)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
//
        kakaoStoryButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.equalTo(editButton.snp.trailingMargin).offset(-16)
            make.width.equalTo(150)
            make.height.equalTo(100)
        }

        sectionView.snp.makeConstraints { make in
            make.bottom.equalTo(editButton.snp.top).offset(-30)
            make.centerX.equalTo(view)
            make.height.equalTo(1.3)
            make.width.equalTo(UIScreen.main.bounds.width)
        }

        // 여기서 올
        userstateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(sectionView.snp.top).offset(-30)
            make.centerX.equalTo(view)
        }

        usernameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(userstateLabel.snp.top).offset(-8)
            make.centerX.equalTo(view)
        }

        profileImageView.snp.makeConstraints { make in
            make.bottom.equalTo(usernameLabel.snp.top).offset(-8)
            make.centerX.equalTo(view)
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
    }
}


extension CodeBase3ViewController {
    private static let buttonConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
}
