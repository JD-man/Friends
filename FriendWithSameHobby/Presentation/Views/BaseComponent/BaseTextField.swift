//
//  BaseTextField.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/22.
//
import UIKit
import Then
import SnapKit

final class BaseTextField: UIView {
    let inputTextField = UITextField().then {
        $0.basicConfig()
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    let lineView = UIView()
    
    let validationLabel = UILabel().then {
        $0.text = "상태"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(text: String, status: BaseTextFieldStatus) {
        self.init()
        viewConfig()
        statusUpdate(text: text, status: status)
    }
    
    private func viewConfig() {
        [inputTextField, lineView, validationLabel]
            .forEach { addSubview($0) }
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.height.equalTo(48)
            make.trailing.leading.equalTo(self).inset(12)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalTo(self)
            make.top.equalTo(inputTextField.snp.bottom)
        }
        
        validationLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.top.equalTo(lineView).offset(4)
            make.leading.trailing.equalTo(inputTextField)
        }
    }
    
    func statusUpdate(text: String, status: BaseTextFieldStatus) {
        inputTextField.text = text
        inputTextField.textColor = status.textColor
        lineView.backgroundColor = status.lineColor
        validationLabel.textColor = status.validationTextColor
        inputTextField.backgroundColor = status.backGroundColor
    }
}

enum BaseTextFieldStatus {
    case inactive
    case focus
    case active
    case disable
    case error
    case success
    
    var backGroundColor: UIColor {
        switch self {
        case .disable:
            return AssetsColors.gray3.color
        default:
            return .systemBackground
        }
    }
        
    var textColor: UIColor {
        switch self {
        case .inactive, .disable:
            return AssetsColors.gray7.color
        default:
            return AssetsColors.black.color
        }
    }
    
    var lineColor: UIColor {
        switch self {
        case .inactive, .active:
            return AssetsColors.gray3.color
        case .focus:
            return AssetsColors.focus.color
        case .disable:
            return .clear
        case .error:
            return AssetsColors.error.color
        case .success:
            return AssetsColors.success.color
        }
    }
    
    var validationTextColor: UIColor {
        switch self {
        case .error:
            return AssetsColors.error.color
        case .success:
            return AssetsColors.success.color
        default:
            return .clear
        }
    }

}