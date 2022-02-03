//
//  ProfileAgeView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/31.
//
import UIKit
import DoubleSlider
import RxSwift

final class ProfileAgeView: UIView {
    let titleLabel = UILabel().then {
        $0.text = "상대방 연령대"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    let ageLabel = UILabel().then {
        $0.text = "20-36"
        $0.textColor = AssetsColors.green.color
        $0.font = AssetsFonts.NotoSansKR.medium.font(size: 14)
    }
    
    var labels: [String] = []
    var ageSlider = DoubleSlider()
    
    var lowerCircleLayer = CALayer()
    var upperCircleLayer = CALayer()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ageSliderConfig()
        viewConfig()
        binding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func ageSliderConfig() {
        labels = Array(18 ... 65).map { String($0) }
        ageSlider.labelDelegate = self
        ageSlider.numberOfSteps = labels.count
        ageSlider.smoothStepping = true
        
        ageSlider.labelsAreHidden = true
        ageSlider.lowerValueStepIndex = 0
        ageSlider.upperValueStepIndex = labels.count - 1
        
        let width: CGFloat = 24
        let xPos = (40.0 - width) * 0.5
        [lowerCircleLayer, upperCircleLayer]
            .forEach {
                $0.frame = CGRect(x: xPos, y: xPos, width: width, height: width)
                $0.cornerRadius = width * 0.5
                $0.backgroundColor = AssetsColors.green.color.cgColor
            }
        
        ageSlider.upperThumbLayer.addSublayer(upperCircleLayer)
        ageSlider.lowerThumbLayer.addSublayer(lowerCircleLayer)
        ageSlider.trackHighlightTintColor = AssetsColors.green.color
    }
    
    private func viewConfig() {
        [titleLabel, ageLabel, ageSlider]
            .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.trailing.equalTo(self)
        }
        
        ageSlider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(23)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(40)
            make.bottom.equalTo(self)
        }
    }
    
    private func binding() {
        ageSlider.rx.controlEvent(.valueChanged)
            .map { [weak self] in
                let lowerValue = self?.ageSlider.lowerValueStepIndex ?? 0
                let upperValue = self?.ageSlider.upperValueStepIndex ?? 47
                return "\(lowerValue + 18)-\(upperValue + 18)" }
            .asDriver(onErrorJustReturn: "")
            .drive(ageLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension ProfileAgeView: DoubleSliderLabelDelegate {
    func labelForStep(at index: Int) -> String? {
        let item: String? = (index < labels.count && index >= 0) ? labels[index] : nil
        return item
    }
}
