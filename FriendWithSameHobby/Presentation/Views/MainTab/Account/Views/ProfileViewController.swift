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
import RxKeyboard
import RxGesture

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
        $0.backgroundColor = .clear
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
    private var disposeBag = DisposeBag()
    private let commentButtonTap = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        viewConfig()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "정보 관리"
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        view.addSubview(profileTableView)
        profileTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        profileTableView.sectionHeaderTopPadding = 1
        
        // Nav config
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.rightBarButtonItem = updateBarButton
    }
    
    private func binding() {
        let input = ProfileViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asDriver(),
            withdrawTap: footerView.withdrawButton.rx.tap.asDriver(),            
            updateButtonTap: updateBarButton.rx.tap.map { [weak self] in
                self?.makeUpdateData() ?? (.unselected, "", false, 0, 1) }
                .asDriver(onErrorJustReturn: (.unselected, "", false, 0, 1)),
            commentButtonTap: commentButtonTap.asSignal()
        )
        let output = viewModel?.transform(input, disposeBag: disposeBag)
        
        output?.profileItem
            .asDriver(onErrorJustReturn: [])
            .drive(profileTableView.rx.items(
                cellIdentifier: ProfileTableViewCell.identifier,
                cellType: ProfileTableViewCell.self)) { [weak self] row, item, cell in
                    cell.configure(with: item)
                    cell.baseCardView.sesacCommentView.moreButton.rx.tap
                        .asSignal()
                        .emit { _ in
                            self?.commentButtonTap.accept(())
                        }.disposed(by: cell.disposeBag)
                        
//                    Expanding method
//                    cell.baseCardView.moreButton.rx.tap
//                        .asDriver()
//                        .drive { [weak self] _ in
//                            guard let strongSelf = self else { return }
//                            var value = strongSelf.testRelay.value
//                            value[row] = !value[row]
//                            strongSelf.testRelay.accept(value)
//                        }.disposed(by: cell.disposeBag)
                }.disposed(by: disposeBag)
        
        profileTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
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
        
        RxKeyboard.instance.visibleHeight
            .drive { [weak self] in
                self?.keyboardHandling(height: $0)
            }.disposed(by: disposeBag)
        
        view.rx
            .tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
    }
    
    private func keyboardHandling(height: CGFloat) {
        if height == 0.0 {
            view.frame.origin.y = 0
        } else {
            view.frame.origin.y -= height
        }
    }
    
    private func makeUpdateData() -> UserMyPageData {
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
