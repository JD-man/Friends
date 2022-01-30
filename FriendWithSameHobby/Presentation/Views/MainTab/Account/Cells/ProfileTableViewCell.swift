//
//  ProfileTableViewCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/30.
//

import UIKit
import SnapKit
import RxSwift

class ProfileTableViewCell: UITableViewCell {
    deinit {
        print("cell deinit")
    }
    
    var baseCardView = BaseCardView()
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        selectionStyle = .none
        contentView.addSubview(baseCardView)
        baseCardView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    func expand(_ isExpanding: Bool) {
        baseCardView.expanding(isExpanding: isExpanding)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
