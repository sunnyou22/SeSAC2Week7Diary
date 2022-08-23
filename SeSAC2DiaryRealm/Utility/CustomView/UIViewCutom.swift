//
//  UIViewCutom.swift
//  CodeBaseAssignment
//
//  Created by 방선우 on 2022/08/19.
//

import UIKit

//MARK: 버튼 커스텀
class CustomButtonUI: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtonLabel(title: String, systemImageString: SystemName?, fontSize: CGFloat, fontweight: UIFont.Weight) {
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.numberOfLines = 0
        titleLabel?.font = .systemFont(ofSize: fontSize, weight: fontweight)
        titleLabel?.minimumScaleFactor = 0.5
        backgroundColor = .clear
       configuration = setButtonCig(title: title, systemImageString: systemImageString)
    }
    
    // 버튼 config를 따로 써주는게 좋을까
    func setButtonCig(title: String, systemImageString: SystemName?) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        
        if let systemImageString = systemImageString {
            config.title = title
            config.baseBackgroundColor = .clear
            config.baseForegroundColor = .white
            config.image = UIImage(systemName: systemImageString.rawValue, withConfiguration: buttonConfig)
            config.imagePadding = 8
            config.imagePlacement = .top
            return config
        } else {
            config.title = title
            config.baseBackgroundColor = .clear
            config.baseForegroundColor = .white
            return config
        }
    }
}
    
//MARK: 이미지뷰 커스텀
    class CustomImageView: UIImageView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
//            setRoundImageBorder()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            
//            guard let view = UINib(nibName: "ImageContainView", bundle: nil).instantiate(withOwner: self).first as? UIView else { return }
//            view.frame = bounds
//            view.backgroundColor = .lightGray
//            self.addSubview(view)
        }
        
        func fetchImageURL(url: String) {
            let url = url
            let data = try! Data(contentsOf: URL(string: url)!)
            image = UIImage(data: data)
        }
        
//        func setRoundImageBorder() {
//            clipsToBounds = true
//            layer.cornerRadius = frame.size.width / 2
//            layer.borderColor = UIColor.gray.cgColor
//            layer.borderWidth = 2
//        }
    }

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomTextView: UITextView {
 
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
