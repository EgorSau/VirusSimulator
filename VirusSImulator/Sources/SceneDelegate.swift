//
//  SceneDelegate.swift
//  VirusSimulator
//
//  Created by Egor SAUSHKIN on 06.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: scene)
		window?.rootViewController = UINavigationController(rootViewController: assembly())
		window?.makeKeyAndVisible()
	}
	
	private func assembly() -> UIViewController {
		let parameterViewController = ParameterScreenViewController()
		let simulatorViewController = SimulatorViewController()
		let router = Router(
			parameterViewController: parameterViewController,
			simulatorViewController: simulatorViewController
		)
		parameterViewController.router = router

		parameterViewController.presenter = ParameterScreenPresenter(viewController: parameterViewController)
		simulatorViewController.presenter = SimulatorScreenPresenter(viewController: simulatorViewController)
		
		return parameterViewController
	}
}

