//
//  UserSearchViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/09.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

class MatchingViewController: UIViewController {
    
    private let backButton = UIBarButtonItem().then {
        $0.image = AssetsImages.arrow.image
    }
    private let refreshButton = UIButton().then {
        $0.setImage(AssetsImages.clarityRefreshLine.image, for: .normal)
        $0.addCorner(rad: 8, borderColor: AssetsColors.green.color)
    }
    private let stopMatchingButton = UIBarButtonItem().then {
        $0.title = "찾기중단"
        $0.setTitleTextAttributes([.font : AssetsFonts.NotoSansKR.medium.font(size: 14)], for: .normal)
    }
    private let queueTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundView = EmptyUserListView(of: .around)
        $0.register(QueueTableViewCell.self, forCellReuseIdentifier: QueueTableViewCell.identifier)
    }
    
    private var disposeBag = DisposeBag()
    private var viewModel: MatchingViewModel
    private let aroundButton = TopTabButton(title: "주변 새싹", status: .selected)
    private let requestedButton = TopTabButton(title: "받은 요청", status: .unselected)
    private let changeHobbyButton = BaseButton(title: "취미 변경하기", status: .fill, type: .h48)
    
    private let toggleButtonTap = PublishRelay<Int>()
    private let matchingButtonTap = PublishRelay<Int>()
    private let commentButtonTap = PublishRelay<Int>()
    
    init(viewModel: MatchingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "새싹 찾기"
        navigationController?.navigationBar.isHidden = false
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        [aroundButton, requestedButton, queueTableView, changeHobbyButton, refreshButton]
            .forEach { view.addSubview($0) }
        
        refreshButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        changeHobbyButton.snp.makeConstraints { make in
            make.bottom.height.equalTo(refreshButton)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(refreshButton.snp.leading).offset(-8)
        }
        
        aroundButton.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.top.leading.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
        }
        
        requestedButton.snp.makeConstraints { make in
            make.width.equalTo(aroundButton)
            make.top.height.equalTo(aroundButton)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        queueTableView.snp.makeConstraints { make in
            make.top.equalTo(aroundButton.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        // nav config
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = stopMatchingButton
    }
    
    private func binding() {
        let input = MatchingViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asDriver(onErrorJustReturn: ()),
            backButtonTap: backButton.rx.tap.asDriver(),
            stopMatchingButtonTap: stopMatchingButton.rx.tap.asDriver(),
            changeHobbyButtonTap: changeHobbyButton.rx.tap.asDriver(),
            aroundButtonTap: aroundButton.tabButton.rx.tap.asDriver(),
            requestedButtonTap: requestedButton.tabButton.rx.tap.asDriver(),
            matchingButtonTap: matchingButtonTap,
            refreshingButtonTap: refreshButton.rx.tap.asDriver(),
            commentButtonTap: commentButtonTap
            //toggleButtonTap: toggleButtonTap
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfMatchingItemViewModel> { [weak self] dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QueueTableViewCell.identifier, for: indexPath) as? QueueTableViewCell,
                  let self = self else { return UITableViewCell() }
            cell.configure(with: item)

            cell.matchingButton.rx.tap.map { indexPath.item }
                .asSignal(onErrorJustReturn: 0)
                .emit(to: self.matchingButtonTap)
                .disposed(by: cell.disposeBag)

            cell.baseCardView.moreButton.rx.tap.map { indexPath.item }
                .asSignal(onErrorJustReturn: 0)
                .emit(to: self.toggleButtonTap)
                .disposed(by: cell.disposeBag)

            cell.baseCardView.sesacCommentView.moreButton.rx.tap.map { indexPath.item }
                .asSignal(onErrorJustReturn: 0)
                .emit(to: self.commentButtonTap)
                .disposed(by: cell.disposeBag)
            return cell
        }
        
        output.queueItems
            .asDriver(onErrorJustReturn: [])
            .drive(queueTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
//        output.queueItems
//            .map {
//                guard let first = $0.first else { return [] }
//                return first.items
//            }
//            .asDriver(onErrorJustReturn: [])
//            .drive(queueTableView.rx.items(cellIdentifier: QueueTableViewCell.identifier, cellType: QueueTableViewCell.self)) { row, item, cell in
//                cell.configure(with: item)
//            }.disposed(by: disposeBag)
        
        output.isQueueExist
            .bind(to: changeHobbyButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isQueueExist
            .bind(to: refreshButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isQueueExist
            .bind(to: queueTableView.backgroundView!.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.selectedTap
            .map { $0 ? TopTabButtonStatus.selected : TopTabButtonStatus.unselected }
            .asDriver(onErrorJustReturn: .selected)
            .drive(aroundButton.rx.status)
            .disposed(by: disposeBag)
        
        output.selectedTap
            .map { $0 ? TopTabButtonStatus.unselected : TopTabButtonStatus.selected }
            .asDriver(onErrorJustReturn: .unselected)
            .drive(requestedButton.rx.status)
            .disposed(by: disposeBag)
        
        output.selectedTap
            .map { $0 ? EmptyListCase.around : EmptyListCase.requested }
            .asDriver(onErrorJustReturn: .around)
            .drive((queueTableView.backgroundView as? EmptyUserListView ?? EmptyUserListView()).rx.listCase)
            .disposed(by: disposeBag)            
    }
}
