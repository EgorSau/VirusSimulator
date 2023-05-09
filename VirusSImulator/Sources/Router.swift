//
//  Router.swift
//  VirusSimulator
//
//  Created by Egor SAUSHKIN on 08.05.2023.
//

import UIKit

/// Протокол для роутера приложения
protocol RouterProtocol {
	/// Метод для построения маршрута во ВьюКонтроллер Симулятора
	func routeToSimulator()
}

/// Класс для роутера и навигации по приложению
final class Router: RouterProtocol {
	
	private var parameterViewController: UIViewController
	private var simulatorViewController: UIViewController
	
	/// Инициализатор роутера приложения
	/// - Parameters:
	///   - parameterViewController: ВьюКонтроллер с Параметрами
	///   - simulatorViewController: ВьюКонтроллер Симулятора
	init(parameterViewController: UIViewController, simulatorViewController: UIViewController) {
		self.parameterViewController = parameterViewController
		self.simulatorViewController = simulatorViewController
	}
	
	/// Метод для построения маршрута во ВьюКонтроллер Симулятора
	func routeToSimulator() {
		parameterViewController.navigationController?.pushViewController(simulatorViewController, animated: true)
	}
}
