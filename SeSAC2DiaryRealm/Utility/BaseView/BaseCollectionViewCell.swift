//
//  BaseCollectionViewCell.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/22.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setConstraints()
        setCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() { }
    func setConstraints() { }
    
    @discardableResult
    func setCellLayout() -> UICollectionViewFlowLayout { return UICollectionViewFlowLayout()}
}
