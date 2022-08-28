//
//  WriteViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/21.
//

import UIKit
import RealmSwift //Realm 1.

protocol SelectImageDelegate {
    func sendImageData(image: UIImage)
}

final class WriteViewController: BaseViewController { //더이상 상속하지 않는 클래스에 final을 붙임
    
    let mainView = WriteView()
    let localRealm = try! Realm() //Realm 2. Realm 테이블에 데이터를 CRUD할 때, Realm 테이블 경로에 접근
    var keyHeight: CGFloat = 0 // 키보드 높이 지정 변수?
    var transitionFetchfunction: (() -> Void)?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardNotifications()
    }
    
    override func configure() {
        mainView.searchImageButton.addTarget(self, action: #selector(selectImageButtonClicked), for: .touchUpInside)
        mainView.sampleButton.addTarget(self, action: #selector(sampleButtonClicked), for: .touchUpInside)
        
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.leftBarButtonItem = saveButton
        let closeButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancleButtonClicked))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    //Realm Create Sample
    @objc func sampleButtonClicked() {
        
        let task = UserDiary_re(diaryTitle: "가오늘의 일기\(Int.random(in: 1...1000))", diaryContent: "일기 테스트 내용", diaryDate: Date(), regdate: Date(), photo: nil) // => Record
        
        try! localRealm.write {
            localRealm.add(task) //Create
            print("Realm Succeed")
            dismiss(animated: true)
        }
    }
    
    @objc func cancleButtonClicked() {
       
        let alert = UIAlertController(title: "메인화면으로 가기", message: "본 일기내용은 저장되지 않습니다. 정말 메인화면으로 가시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "네", style: .default) { _ in
            self.dismiss(animated: true)
        }
        let cancle = UIAlertAction(title: "아니오", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancle)
        
        present(alert, animated: true)
    }
    
    //Realm + 이미지 도큐먼트 저장
    @objc func saveButtonClicked() {
        
        guard let title = mainView.titleTextField.text else {
            showAlertMessage(title: "제목을 입력해주세요", button: "확인")
            return
            }
        
        let task = UserDiary_re(diaryTitle: title, diaryContent: mainView.contentTextView.text!, diaryDate: Date(), regdate: Date(), photo: nil) // 데이터 가져와서
        
        do {
            try localRealm.write({
                localRealm.add(task) // 램에 저장
            })
        } catch let error {
            print(error)
        }
        
        if let image = mainView.userImageView.image {
            saveImageToDocument(fileName: "\(task.objectId).jpg", image: image)
        
//        try! localRealm.write {
//            localRealm.add(task) //Create
//
//            task.diaryContent = mainView.contentTextView.text
//            task.diaryTitle = mainView.titleTextField.text!
            
            print("Realm Succeed")
        } else {
            print("이미지 없어용")
        }
        transitionFetchfunction!()
        self.dismiss(animated: true)
    }
    
    @objc func selectImageButtonClicked() {
        let vc = ImageSearchViewController()
        vc.delegate = self // 값전달의 인스턴스가 같아야하기때문에
        transition(vc, transitionStyle: .presentNavigation)
    }
    
    //MARK: - 키보드 메서드
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            keyHeight = keyboardHeight
            
            self.view.frame.origin.y = -keyboardHeight
        }
    }
    @objc
    func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeKeyboardNotifications()
    }
}

extension WriteViewController: SelectImageDelegate {
  
    func sendImageData(image: UIImage) {
        // 전달받은 이미지를 보여줘
        mainView.userImageView.image = image
    }
}

