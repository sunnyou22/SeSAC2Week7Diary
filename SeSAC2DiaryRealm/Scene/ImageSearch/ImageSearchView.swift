//
//  ImageSearchView.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/21.
//

import UIKit

class ImageSearchView: BaseView {
    
    let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "원하시는 사진의 키워드를 입력해주세요."
       
        return view
    }()
    
    let collectionView: UICollectionView = {
        let itemCount: CGFloat = 3
        print(#function)
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 9
        let width = (UIScreen.main.bounds.width - (spacing * 4)) / itemCount
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        backgroundColor = .brown
        [searchBar, collectionView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        
        searchBar.snp.makeConstraints { make in
            
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).offset(0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(0)
            make.leading.trailing.equalTo(self.safeAreaInsets).offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
    }
}

