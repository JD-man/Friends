//
//  ProfileViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {
    typealias UserMyPageData = (UserGender, String, Bool, Int, Int)
    typealias UserAgeRange = (Int, Int)
    var viewModel: ProfileViewModel?
    
    init(profileViewModel: ProfileViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = profileViewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("ProfileVC deinit")
    }
    
    private let profileTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .systemBackground
        $0.showsVerticalScrollIndicator = false        
        $0.rowHeight = UITableView.automaticDimension
        $0.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        $0.register(ProfileTableViewFooter.self, forHeaderFooterViewReuseIdentifier: ProfileTableViewFooter.identifier)
    }
    
    private let updateBarButton = UIBarButtonItem().then {
        $0.title = "저장"
        $0.style = .plain
    }
    
    private let footerView = ProfileTableViewFooter()
    private var testRelay = BehaviorRelay<[Bool]>(value: [false])
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        viewConfig()
        profileTableViewConfig()
        binding()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        view.addSubview(profileTableView)
        profileTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        // Nav config
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.rightBarButtonItem = updateBarButton
    }
    
    private func profileTableViewConfig() {
        testRelay
            .asDriver()
            .drive(profileTableView.rx.items(
                cellIdentifier: ProfileTableViewCell.identifier,
                cellType: ProfileTableViewCell.self)) { [weak self] row, item, cell in
                    cell.expand(item)
                    cell.baseCardView.moreButton.rx.tap
                        .asDriver()
                        .drive { [weak self] _ in
                            guard let strongSelf = self else { return }
                            var value = strongSelf.testRelay.value
                            value[row] = !value[row]
                            strongSelf.testRelay.accept(value)
                        }.disposed(by: cell.disposeBag)
                }.disposed(by: disposeBag)
        
        profileTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func binding() {
        let input = ProfileViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map { _ in return () }.asDriver(onErrorJustReturn: ()),
            withdrawTap: footerView.withdrawButton.rx.tap.asDriver(),
            updateButtonTap: updateBarButton.rx.tap.map { [weak self] in
                self?.makeUpdateData() ?? (.unselected, "", false, 0, 1) }
                .asDriver(onErrorJustReturn: (.unselected, "", false, 0, 1))
        )
        let output = viewModel?.transform(input, disposeBag: disposeBag)
        
        output?.gender
            .asDriver(onErrorJustReturn: .unselected)
            .drive(footerView.genderView.rx.gender)
            .disposed(by: disposeBag)
        
        output?.hobby
            .asDriver(onErrorJustReturn: "")
            .drive(footerView.hobbyView.hobbyTextField.inputTextField.rx.text)
            .disposed(by: disposeBag)
        
        output?.searchable
            .asDriver(onErrorJustReturn: false)
            .drive(footerView.allowSearchingView.allowSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        output?.minAgeIndex
            .asDriver(onErrorJustReturn: 0)
            .drive(footerView.ageView.ageSlider.rx.lowerValueStepIndex)
            .disposed(by: disposeBag)
        
        output?.maxAgeIndex
            .asDriver(onErrorJustReturn: 47)            
            .drive(footerView.ageView.ageSlider.rx.upperValueStepIndex)
            .disposed(by: disposeBag)
        
        output?.ageRange
            .asDriver(onErrorJustReturn: "18-65")
            .drive(footerView.ageView.ageLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func makeUpdateData() -> UserMyPageData {
        let gender = footerView.genderView.gender
        let hobby = footerView.hobbyView.hobbyTextField.inputTextField.text ?? ""
        let searchable = footerView.allowSearchingView.allowSwitch.isOn
        let minAgeIndex = footerView.ageView.ageSlider.lowerValueStepIndex
        let maxAgeIndex = footerView.ageView.ageSlider.upperValueStepIndex
        
        return (gender, hobby, searchable, minAgeIndex, maxAgeIndex)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}
