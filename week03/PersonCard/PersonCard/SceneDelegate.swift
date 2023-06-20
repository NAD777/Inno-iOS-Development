//
//  SceneDelegate.swift
//  PersonCard
//
//  Created by Антон Нехаев on 19.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let vc = ViewController()
        window.rootViewController = vc
        self.window = window
        window.makeKeyAndVisible()
        print(#function, "Called when a new scene is about to connect to your app. It is invoked shortly after the scene object is created and associated with its session.")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        print(#function, "Called when scene is about to be disconnected from your app. It is invoked when the user dismisses or closes the scene, or when the system terminates the scene due to memory pressure or other reasons.")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print(#function, "Called when a scene transitions from an inactive state to an active state.  It is invoked when the user brings a scene to the foreground or when the scene is initially launched.")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print(#function, "Called when a scene is about to transition from an active state to an inactive state. It is invoked when the user navigates away from the scene or when the scene is about to be backgrounded.")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print(#function, "Called when a scene is about to transition from the background to the foreground. It is invoked when the user brings the app to the foreground after it has been backgrounded or when the scene is initially launched.")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print(#function, "Called when a scene transitions from the foreground to the background. It is invoked when the user backgrounds the app or switches to another app.")
    }


}

