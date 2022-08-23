//
//  ImageSearchCollectionViewCell.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/22.
//

import UIKit
import SnapKit

class CustomCollectionViewCell: BaseCollectionViewCell {
    
    let imageView: CustomImageView = {
        let view = CustomImageView(frame: .zero)
        
      return view
    }()
    
    override func configureUI() {
        self.addSubview(imageView)
        
    }

    override func setConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self)
           
        }
    }
}
