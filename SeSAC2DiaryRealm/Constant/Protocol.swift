//
//  Protocol.swift
//  CodeBaseAssignment
//
//  Created by 방선우 on 2022/08/21.
//

import UIKit

//프로토콜은 기본 기능 구현이 안됐지..
protocol ReuseIdentifier {
    static var reusableIdentifier: String { get }
}

extension UIViewController: ReuseIdentifier {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReuseIdentifier {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
