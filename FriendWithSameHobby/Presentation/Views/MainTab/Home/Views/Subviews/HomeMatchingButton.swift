//
//  HomeMatchingButton.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/04.
//
import UIKit

enum MatchingStatus {
    case normal
    case waiting
    case matched
    
    var matchingImage: UIImage {
        switch self {
        case .normal:
            return AssetsImages.matchSearch.image
        case .waiting:
            return AssetsImages.matchAntenna.image
        case .matched:
            return AssetsImages.matchMessage.image
        }
    }
}

final class HomeMatchingButton: UIButton {
    var matchingStatus: MatchingStatus = .normal {
        didSet {
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(status: MatchingStatus) {
        self.init()        
        frame.size.width = 64
        frame.size.height = 64
        matchingStatus = status
        addCorner(rad: 32, borderColor: nil)
        addshadow(rad: 2.5)
        backgroundColor = AssetsColors.black.color
        setImage(status.matchingImage, for: .normal)
    }
}