//
//  BackupTableViewCell.swift
//  SeSAC2DiaryRealm
//
//  Created by 방선우 on 2022/08/24.
//

import Foundation
import UIKit
import SwiftUI

class BackupTableViewCell: BaseTableViewCell {

let titleLabel: UILabel = {
   let view = UILabel()
    view.textColor = Constants.BaseColor.text
    view.backgroundColor = Constants.BaseColor.background
    view.layer.borderColor = Constants.BaseColor.border
    view.layer.borderWidth = Constants.Desgin.borderWidth
    view.clipsToBounds = true
    view.layer.cornerRadius = Constants.Desgin.cornerRadius
    
    return view
}()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        backgroundColor = .systemBackground
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentView.addSubview(titleLabel)
    }
    
    override func setConstraints() {
        let spacing = 20
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(spacing)
            make.leading.equalTo(contentView).inset(spacing)
        }
    }
}
