// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum AssetsImages {
  internal static let accountIcon = ImageAsset(name: "AccountIcon")
  internal static let friendsIcon = ImageAsset(name: "FriendsIcon")
  internal static let homeIcon = ImageAsset(name: "HomeIcon")
  internal static let matchAntenna = ImageAsset(name: "MatchAntenna")
  internal static let matchMessage = ImageAsset(name: "MatchMessage")
  internal static let matchSearch = ImageAsset(name: "MatchSearch")
  internal static let shopIcon = ImageAsset(name: "ShopIcon")
  internal static let socialLifeCuate = ImageAsset(name: "Social life-cuate")
  internal static let arrow = ImageAsset(name: "arrow")
  internal static let cancelMatch = ImageAsset(name: "cancel_match")
  internal static let closeBig = ImageAsset(name: "close_big")
  internal static let faq = ImageAsset(name: "faq")
  internal static let femaleButton = ImageAsset(name: "femaleButton")
  internal static let filterControl = ImageAsset(name: "filter_control")
  internal static let friendsPlus = ImageAsset(name: "friends_plus")
  internal static let logout = ImageAsset(name: "logout")
  internal static let maleButton = ImageAsset(name: "maleButton")
  internal static let mapMarker = ImageAsset(name: "map_marker")
  internal static let message = ImageAsset(name: "message")
  internal static let more = ImageAsset(name: "more")
  internal static let moreArrow = ImageAsset(name: "more_arrow")
  internal static let notice = ImageAsset(name: "notice")
  internal static let onboardingImg1 = ImageAsset(name: "onboarding_img1")
  internal static let onboardingImg2 = ImageAsset(name: "onboarding_img2")
  internal static let permit = ImageAsset(name: "permit")
  internal static let place = ImageAsset(name: "place")
  internal static let plus = ImageAsset(name: "plus")
  internal static let profileImg = ImageAsset(name: "profile_img")
  internal static let qna = ImageAsset(name: "qna")
  internal static let search = ImageAsset(name: "search")
  internal static let sesacBg01 = ImageAsset(name: "sesac_bg_01")
  internal static let sesacFace1 = ImageAsset(name: "sesac_face_1")
  internal static let sesacFace2 = ImageAsset(name: "sesac_face_2")
  internal static let sesacFace3 = ImageAsset(name: "sesac_face_3")
  internal static let sesacFace4 = ImageAsset(name: "sesac_face_4")
  internal static let sesacFace5 = ImageAsset(name: "sesac_face_5")
  internal static let settingAlarm = ImageAsset(name: "setting_alarm")
  internal static let siren = ImageAsset(name: "siren")
  internal static let write = ImageAsset(name: "write")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
