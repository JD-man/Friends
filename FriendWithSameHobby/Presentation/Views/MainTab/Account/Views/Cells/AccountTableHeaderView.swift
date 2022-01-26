//
//  AccountTableHeaderView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/26.
//

import UIKit

class AccountTableHeaderView: UITableViewHeaderFooterView {
    
    private let accountImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        
    }
        
}
