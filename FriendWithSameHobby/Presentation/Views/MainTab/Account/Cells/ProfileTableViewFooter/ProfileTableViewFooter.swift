//
//  ProfileTableViewFooter.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/31.
//

import UIKit
import SnapKit

class ProfileTableViewFooter: UITableViewHeaderFooterView {
    
    let genderView = ProfileGenderView()
    let hobbyView = ProfileHobbyView()
    let allowSearchingView = ProfileAllowSearchingView()
    let ageView = ProfileAgeView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        backgroundColor = .systemBackground
        [genderView, hobbyView, allowSearchingView, ageView]
            .forEach { addSubview($0) }
        
        genderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(50)
        }
        
        hobbyView.snp.makeConstraints { make in
            make.top.equalTo(genderView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(50)
        }
        
        allowSearchingView.snp.makeConstraints { make in
            make.top.equalTo(hobbyView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(50)
        }
        
        ageView.snp.makeConstraints { make in
            make.top.equalTo(allowSearchingView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(self)            
            make.bottom.equalTo(self).priority(.low)
        }
    }
}
