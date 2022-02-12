//
//  SeSACHobbyTagView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/13.
//
import UIKit
import RxSwift

final class SeSACHobbyTagView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "하고 싶은 취미"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 12)
    }
}
