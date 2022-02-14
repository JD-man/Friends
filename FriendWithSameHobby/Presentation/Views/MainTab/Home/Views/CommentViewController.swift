//
//  CommentViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/13.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Then
import SnapKit

class CommentViewController: UIViewController {

    private let reviewRelay = BehaviorRelay<[String]>(value: [])
    private var disposeBag = DisposeBag()
    
    private let reviewTableView = UITableView().then {
        $0.separatorInset.right = $0.separatorInset.left
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    init(review: [String]) {
        super.init(nibName: nil, bundle: nil)
        reviewRelay.accept(review)
        viewConfig()
        binding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "새싹 리뷰"
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func viewConfig() {
        view.addSubview(reviewTableView)
        reviewTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func binding() {
        reviewRelay
            .asDriver()
            .drive(reviewTableView.rx.items(
                cellIdentifier: CommentTableViewCell.identifier,
                cellType: CommentTableViewCell.self)) { row, item, cell in
                    cell.configure(with: item)
                }.disposed(by: disposeBag)
    }
}
