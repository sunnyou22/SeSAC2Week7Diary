//
//  Extension_re.swift
//  SeSAC2Week7Diary
//
//  Created by 방선우 on 2022/08/17.
//
import Foundation
import UIKit



extension UIFont {
    static let normalLabel14 = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let semibold16 = UIFont.systemFont(ofSize: 16, weight: .semibold)
}

extension UIButton.Configuration {
   static func setbottomButtonsConfig(title: String, systemImageString: SystemName) -> UIButton.Configuration {
        
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .white
        config.image = UIImage(systemName: systemImageString.rawValue)
        config.imagePadding = 8
        config.imagePlacement = .top
        
        return config
}

}
