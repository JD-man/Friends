//
//  HomeMatchingButton.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/04.
//
import UIKit

enum MatchingStatus: String {
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

final class MapMatchingButton: UIButton {
    var matchingStatus: MatchingStatus = .normal {
        didSet {
            setImage(matchingStatus.matchingImage, for: .normal)
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
        addshadow(rad: 3, opacity: 0.3)        
        addCorner(rad: 32, borderColor: nil)
        backgroundColor = AssetsColors.black.color
        setImage(status.matchingImage, for: .normal)        
    }
    
    func setMatchingStatus() {
        //isUserInteractionEnabled = true
        let rawValue = UserMatchingStatus.matchingStatus ?? ""
        matchingStatus = MatchingStatus(rawValue: rawValue) ?? .normal
    }
}
