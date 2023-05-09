//
//  ParameterScreenPresenter.swift
//  VirusSimulator
//
//  Created by Egor SAUSHKIN on 07.05.2023.
//

import UIKit

/// Протокол для использования методов Презентера экрана с параметрами.
protocol ParameterScreenPresenterProtocol {
	/// Метод для настройки жестов исчезновения клавиатуры по тапу на экран.
	func setupKbdRemoveByTapGesture()
	/// Метод для настройки появления клавиатуры на экране.
	func KbdNotificatorAppearance()
	/// Метод для настройки исчезновения клавиатуры с экрана.
	func KbdNotificatorRemove()
}

/// Класс для настройки презентации экрана с Параметрами.
final class ParameterScreenPresenter: ParameterScreenPresenterProtocol {
	
	// MARK: - Parameters
	
	private var viewController: ParameterScreenViewController
	private let tapGesture = UITapGestureRecognizer()
	
	// MARK: - Init
	
	/// Инициализатор для настройки презентации экрана с Параметров.
	/// - Parameter viewController: Принимает класс типа ParameterScreenViewController.
	init(viewController: ParameterScreenViewController) {
		self.viewController = viewController
	}
	
	// MARK: - Public methods
	
	/// Метод для настройки жестов исчезновения клавиатуры по тапу на экран.
	func setupKbdRemoveByTapGesture(){
		viewController.scrollView.addGestureRecognizer(tapGesture)
		tapGesture.addTarget(self, action: #selector(tapForKbd))
	}
	
	/// Метод для настройки появления клавиатуры на экране.
	func KbdNotificatorAppearance() {
		NotificationCenter.default.addObserver(self, selector: #selector(kbdShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(kbdHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	/// Метод для настройки исчезновения клавиатуры с экрана.
	func KbdNotificatorRemove() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	// MARK: - Private methods
	
	@objc private func kbdShow(notification: NSNotification) {
		if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			viewController.scrollView.contentOffset = CGPoint(x: 0, y: kbdSize.height/2)
			viewController.scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0,left: 0, bottom: kbdSize.height, right: 0)
		}
	}
	
	@objc private func adjustForKeyboard (notification: Notification){
		if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			viewController.scrollView.contentOffset = CGPoint(x: 0, y: kbdSize.height/2)
			viewController.scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0,left: 0, bottom: kbdSize.height, right: 0)
		}
	}
	
	@objc private func tapForKbd (_ gestureRecognizer: UITapGestureRecognizer) {
		guard tapGesture === gestureRecognizer else { return }
		viewController.groupTextField.resignFirstResponder()
		viewController.infectionFactorTextField.resignFirstResponder()
		viewController.recalculationPeriodTextField.resignFirstResponder()
		
	}
	
	@objc private func kbdHide(notification: NSNotification) {
		viewController.scrollView.contentOffset = .zero
		viewController.scrollView.verticalScrollIndicatorInsets = .zero
	}
}
