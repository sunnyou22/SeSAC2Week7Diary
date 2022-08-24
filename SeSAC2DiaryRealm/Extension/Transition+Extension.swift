//
//  Transition+Extension.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/21.
//

import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case present // 네비 없이 Present
        case presentNavigation // 네이비게이션 임베드 Present
        case presentFullScreen // 네비게이션 풀스크린
        case push
    }
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present) {
        
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        case .presentNavigation:
            let vc = viewController
            let nav = UINavigationController(rootViewController: viewController)
            vc.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        case .presentFullScreen:
            let vc = viewController
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    
}
