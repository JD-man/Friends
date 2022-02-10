//
//  SceneDelegate.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Tabbar Appearance Config
        tabbarConfig()
        // Nav Appearance Config
        navigationConfig()
        
        window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController()
        appCoordinator = AppCoordinator(nav: nav)
        appCoordinator?.start()
        window?.rootViewController = nav
        
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    private func tabbarConfig() {
        if #available(iOS 15.0, *) {
            let tabbarAppearance = UITabBarAppearance()
            tabbarAppearance.configureWithOpaqueBackground()
            tabbarAppearance.backgroundColor = .systemBackground
            
            let tabbarItemAppearance = UITabBarItemAppearance()
            tabbarItemAppearance.normal.titleTextAttributes = [.font : AssetsFonts.NotoSansKR.regular.font(size: 12)]
            tabbarItemAppearance.selected.titleTextAttributes = [.font : AssetsFonts.NotoSansKR.regular.font(size: 12)]
            
            UITabBar.appearance().standardAppearance = tabbarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabbarAppearance
            tabbarAppearance.stackedLayoutAppearance = tabbarItemAppearance
        }
        else {
            UITabBar.appearance().barTintColor = .systemBackground
        }
        
        UITabBar.appearance().tintColor = AssetsColors.green.color
        UITabBar.appearance().unselectedItemTintColor = AssetsColors.gray6.color
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [.font : AssetsFonts.NotoSansKR.regular.font(size: 12)], for: .normal
        )
        UITabBarItem.appearance().setTitleTextAttributes(
            [.font : AssetsFonts.NotoSansKR.regular.font(size: 12)], for: .selected
        )
    }
    
    private func navigationConfig() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.setBackIndicatorImage(AssetsImages.arrow.image, transitionMaskImage: AssetsImages.arrow.image)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = AssetsColors.black.color        
    }
    
    private func tableViewConfig() {
        if #available(iOS 15.0, *) { UITableView.appearance().sectionHeaderTopPadding = 1 }
    }
}
