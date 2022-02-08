//
//  HobbyViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/04.
//
import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import RxKeyboard
import RxGesture
import RxDataSources

final class HobbyViewController: UIViewController {
    
    private let hobbyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: HobbyCollectionViewFlowLayout()).then {
        $0.register(HobbyCollectionViewCell.self, forCellWithReuseIdentifier: HobbyCollectionViewCell.identifier)
    }
    private let searchBar = UISearchBar().then {        
        $0.searchTextField.attributedPlaceholder = NSAttributedString(string: "띄어쓰기로 복수 입력이 가능해요", attributes: [.font : AssetsFonts.NotoSansKR.regular.font(size: 14)])
    }
    private let findButton = BaseButton(title: "새싹 찾기", status: .fill, type: .h48)
        
    private var viewModel: HobbyViewModel?
    private var disposeBag = DisposeBag()
    
    init(viewModel: HobbyViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        binding()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        [hobbyCollectionView, findButton]
            .forEach { view.addSubview($0) }
        findButton.snp.makeConstraints { make in
            make.height.equalTo(findButton.frame.height)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        hobbyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(findButton.snp.top).offset(-32)
        }
        // search bar config
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func binding() {
        
        let input = HobbyViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map { _ in () }.asDriver(onErrorJustReturn: ()),
            searchBarText: searchBar.rx.searchButtonClicked.withLatestFrom(searchBar.rx.text.orEmpty).asDriver(onErrorJustReturn: "")
        )
        let output = viewModel?.transform(input, disposeBag: disposeBag)
        
        // Collection View Config
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<SectionOfHobbyCellModel> {
            datasource, cv, indexPath, item in
            guard let cell = cv.dequeueReusableCell(
                withReuseIdentifier: HobbyCollectionViewCell.identifier,
                for: indexPath) as? HobbyCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: item)
            return cell
        }
        
        output?.aroundHobby
            .asDriver(onErrorJustReturn: [])
            .drive(hobbyCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // MARK: - Keyboard handling
        RxKeyboard.instance.willShowVisibleHeight
            .drive { [weak self] in
                let safeAreaBottom = self?.view.safeAreaInsets.bottom ?? 0
                self?.keyboardHandling(of: .show(height: $0, safeAreaBottom: safeAreaBottom))
            }.disposed(by: disposeBag)
        
        view.rx
            .tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.searchBar.resignFirstResponder()
                self?.keyboardHandling(of: .hide)
            }).disposed(by: disposeBag)
    }
    
    private func keyboardHandling(of status: KeyboardStatus) {
        findButton.snp.updateConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(status.sideInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16 + status.height - status.safeAreaBottom)
        }
        findButton.addCorner(rad: status.cornerRadius, borderColor: nil)
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
