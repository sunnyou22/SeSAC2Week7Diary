//
//  ImageSearchViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/21.
//

import UIKit

class ImageSearchViewController: BaseViewController {
    
    var delegate: SelectImageDelegate? // 값전달
    var selectImage: UIImage? //1.
    //    var perPageImageCount = 10
    var mainView = ImageSearchView()
    var imageURLList: [URL] = []
    var selectIndexPath: IndexPath? // 선택한 이미지 보더주기 위한 프로퍼티
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let selectButton = UIBarButtonItem(title: "사진선택", style: .plain, target: self, action: #selector(selectPhoto))
        navigationItem.leftBarButtonItem = selectButton
        let cancleButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancleButtonClicked))
        navigationItem.rightBarButtonItem = cancleButton
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
    
    @objc func selectPhoto() {
        guard let selectImage = selectImage else {
            showAlertMessage(title: "사진을 선택해주세요", button: "확인")
            return
        }
        
        delegate?.sendImageData(image: selectImage) // 이미지 전달
        dismiss(animated: true)
    }
    
    override func configure() {
        mainView.collectionView.register(ImageSearchCollectionViewCell.self, forCellWithReuseIdentifier: ImageSearchCollectionViewCell.reusableIdentifier)
        
        mainView.searchBar.searchTextField.addTarget(self, action: #selector(doKeyboardDown), for: .editingDidEndOnExit)
        
        mainView.searchBar.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    @objc
    func doKeyboardDown() {
        mainView.searchBar.resignFirstResponder()
        UnsplashAPIManager.shared.callRequst(page: 1, query: mainView.searchBar.text!) { json in
            UnsplashAPIManager.shared.requestUnsplashImage(json: json) { imageList in
                
                self.imageURLList = imageList
            }
        }
        mainView.collectionView.reloadData()
    }
}

extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if mainView.searchBar.text == nil {
            self.imageURLList.removeAll()
            return 0
        } else if mainView.searchBar.text?.count != 0 {
            return imageURLList.count
        }
        
        //        guard let imageCount =  perPageImageCount else {
        //            print("🧨이미지가 없습니다🧨")
        //            return 0}
        return 3 // 내 옛날 인덱스 오류 찾아보기
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.reusableIdentifier, for: indexPath) as? ImageSearchCollectionViewCell else { return UICollectionViewCell()}
        let dataList = imageURLList.map { url in
            try! Data(contentsOf: url)
        }
        
        if mainView.searchBar.text == nil {
            self.imageURLList.removeAll()
        } else if mainView.searchBar.text?.count != 0 {
            cell.imageView.image = UIImage(data: dataList[indexPath.item])
            return cell
        }
        
        print(imageURLList)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //선택된 셀을 가져옴 wow tag를 이용하는 것도 생각해보기(int로 지정될거임)
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageSearchCollectionViewCell else { return }
        
        //데이터에 인덱스 넣어주기
        selectIndexPath = indexPath
        
        //화면에 보여주기
        cell.layer.borderWidth = CGFloat(selectIndexPath == indexPath ? imageURLList.count : 0)
        cell.layer.borderColor = selectIndexPath == indexPath ? Constants.BaseColor.point.cgColor : nil
        
        selectImage = cell.imageView.image
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectIndexPath = nil
        selectImage = nil
        collectionView.reloadData()
    }
}

extension ImageSearchViewController: UISearchBarDelegate {
    
}
