//
//  ProfileViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/26.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    let baseCardView = BaseCardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        view.addSubview(baseCardView)
        baseCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}
