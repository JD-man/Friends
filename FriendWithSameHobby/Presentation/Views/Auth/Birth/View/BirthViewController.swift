//
//  BirthViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

class BirthViewController: UIViewController {
    
    var viewModel: BirthViewModel?
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "생년월일을 알려주세요"
        $0.textColor = AssetsColors.black.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 20)
    }
    
    private let yearTextField = BaseTextField(text: "1990", status: .inactive).then {
        $0.tintColor = .clear
    }
    private let monthTextField = BaseTextField(text: "1", status: .inactive).then {
        $0.tintColor = .clear
    }
    private let dayTextField = BaseTextField(text: "11", status: .inactive).then {
        $0.tintColor = .clear
    }
    
    private let yearLabel = UILabel().then {
        $0.text = "년"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 16)
    }
    
    private let monthLabel = UILabel().then {
        $0.text = "월"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 16)
    }
    
    private let dayLabel = UILabel().then {
        $0.text = "일"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 16)
    }
    
    private let nextButton = BaseButton(title: "다음", status: .disable, type: .h48)
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
    }
    
    init(viewModel: BirthViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        [titleLabel, yearTextField, monthTextField, dayTextField,
        yearLabel, monthLabel, dayLabel, nextButton]
            .forEach { view.addSubview($0) }
        
        let textFieldWidth = (UIScreen.main.bounds.width - (27 * 2) - (4) - (16 * 2) - (15 * 3)) / 3
        print(textFieldWidth)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(97)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        yearTextField.snp.makeConstraints { make in
            make.width.equalTo(textFieldWidth)
            make.height.greaterThanOrEqualTo(yearTextField.frame.height)
            make.top.equalTo(titleLabel.snp.bottom).offset(91)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.leading.equalTo(yearTextField.snp.trailing).offset(4)
            make.centerY.equalTo(yearTextField.snp.centerY)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.width.equalTo(textFieldWidth)
            make.height.equalTo(yearTextField)
            make.top.equalTo(yearTextField)
            make.leading.equalTo(yearLabel.snp.trailing).offset(23)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.leading.equalTo(monthTextField.snp.trailing).offset(4)
            make.centerY.equalTo(yearTextField.snp.centerY)
        }
        
        dayTextField.snp.makeConstraints { make in
            make.width.equalTo(textFieldWidth)
            make.height.equalTo(yearTextField)
            make.top.equalTo(yearTextField)
            make.leading.equalTo(monthLabel.snp.trailing).offset(23)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.leading.equalTo(dayTextField.snp.trailing).offset(4)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(yearTextField.snp.centerY)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(nextButton.frame.height)
            make.top.equalTo(monthTextField.snp.bottom).offset(76)
        }
        
        [yearTextField, monthTextField, dayTextField]
            .forEach {
                $0.inputTextField.inputView = datePicker
            }        
    }
    
    private func binding() {
        
    }
}
