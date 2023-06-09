//
//  ParameterScreenViewController.swift
//  VirusSimulator
//
//  Created by Egor SAUSHKIN on 06.05.2023.
//

import UIKit

/// Класс для отображения экрана ввода Параметров симулятора.
final class ParameterScreenViewController: UIViewController {
	
	// MARK: - Parameters
	
	/// Презентер экрана с параметрами пользователя.
	var presenter: ParameterScreenPresenterProtocol?
	/// Роутер экрана с параметрами пользователя.
	var router: RouterProtocol?
	private var dictionary: [String : Any] = [
		NotificationStrings.group: Int(),
		NotificationStrings.factor: Int(),
		NotificationStrings.period: Int()
	]
	
	private lazy var contentView: UIView = {
		var contentView = UIView()
		contentView.translatesAutoresizingMaskIntoConstraints = false
		return contentView
	}()
	
	private lazy var stack: UIStackView = {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		stack.distribution = .fillEqually
		stack.spacing = Sizes.spacing
		return stack
	}()
	
	private lazy var logo: UIImageView = {
		var logo = UIImageView()
		logo.image = UIImage(named: TitleStrings.parametersImage)
		logo.translatesAutoresizingMaskIntoConstraints = false
		return logo
	}()
	
	private lazy var button: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = Sizes.cornerRadius
		button.backgroundColor = .systemRed
		button.setTitle(TitleStrings.parametersButton, for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.addTarget(.none, action: #selector(buttonPressed), for: .touchUpInside)
		return button
	}()
	
	/// Cкрол вью класса ParameterScreenViewController.
	lazy var scrollView: UIScrollView = {
		var scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}()
	
	/// Текстовое поле для ввода группы зараженных людей класса ParameterScreenViewController.
	lazy var groupTextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.layer.borderColor = UIColor.lightGray.cgColor
		textField.layer.cornerRadius = Sizes.cornerRadius
		textField.layer.borderWidth = Sizes.borderWidth
		textField.textColor = .systemRed
		textField.font = .systemFont(ofSize: Sizes.fontSize, weight: .regular)
		textField.tintColor = UIColor.systemRed
		textField.autocapitalizationType = .none
		textField.placeholder = TitleStrings.groupTextFieldPlaceholder
		return textField
	}()
	
	/// Текстовое поле для ввода фактора заражения класса ParameterScreenViewController.
	lazy var infectionFactorTextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.layer.borderColor = UIColor.lightGray.cgColor
		textField.layer.cornerRadius = Sizes.cornerRadius
		textField.layer.borderWidth = Sizes.borderWidth
		textField.textColor = .systemRed
		textField.font = .systemFont(ofSize: Sizes.fontSize, weight: .regular)
		textField.tintColor = UIColor.systemRed
		textField.autocapitalizationType = .none
		textField.placeholder = TitleStrings.infectionFactorTextFieldPlaceholder
		return textField
	}()
	
	/// Текстовое поле для ввода скорости распространения вируса класса ParameterScreenViewController.
	lazy var recalculationPeriodTextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.layer.borderColor = UIColor.lightGray.cgColor
		textField.layer.cornerRadius = Sizes.cornerRadius
		textField.layer.borderWidth = Sizes.borderWidth
		textField.textColor = .systemRed
		textField.font = .systemFont(ofSize: Sizes.fontSize, weight: .regular)
		textField.tintColor = UIColor.systemRed
		textField.autocapitalizationType = .none
		textField.placeholder = TitleStrings.recalculationPeriodTextFieldPlaceholder
		return textField
	}()
	
	// MARK: - Deinit
	
	deinit {
		presenter?.KbdNotificatorRemove()
	}
	
	// MARK: - Override methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupScrollView()
		setupContentView()
		setupLogo()
		setupStack()
		setupButton()
		presenter?.KbdNotificatorAppearance()
		presenter?.setupKbdRemoveByTapGesture()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		logo.bounds.size.width = Sizes.logoWidth
		logo.bounds.size.height = Sizes.logoHeight
	}
	
	// MARK: Layout setup private methods
	
	private func setupView(){
		view.backgroundColor = .white
	}
	
	private func setupScrollView() {
		view.addSubview(scrollView)
		
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	private func setupContentView() {
		scrollView.addSubview(contentView)
		
		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
			contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
		])
	}
	
	private func setupLogo() {
		contentView.addSubview(logo)
		
		let topConstraint = logo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 200)
		topConstraint.priority = UILayoutPriority(999)
		
		NSLayoutConstraint.activate([
			topConstraint,
			logo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			logo.widthAnchor.constraint(equalToConstant: Sizes.logoWidth),
			logo.heightAnchor.constraint(equalToConstant: Sizes.logoHeight),
		])
	}
	
	private func setupStack(){
		contentView.addSubview(stack)
		stack.addArrangedSubview(groupTextField)
		stack.addArrangedSubview(infectionFactorTextField)
		stack.addArrangedSubview(recalculationPeriodTextField)
		
		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 40),
			stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			stack.heightAnchor.constraint(equalToConstant: (40 + 8) * 3)
		])
	}
	
	private func setupButton(){
		contentView.addSubview(button)
		
		NSLayoutConstraint.activate([
			button.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 16),
			button.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
			button.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
			button.heightAnchor.constraint(equalToConstant: 50)
		])
	}
	
	@objc private func buttonPressed(){
		guard groupTextField.text != "" || infectionFactorTextField.text != "" || recalculationPeriodTextField.text != "" else { return }
		
		groupTextField.resignFirstResponder()
		infectionFactorTextField.resignFirstResponder()
		recalculationPeriodTextField.resignFirstResponder()
		
		guard let group = Int(groupTextField.text!) else { return }
		guard let factor = Int(infectionFactorTextField.text!) else { return }
		guard let period = Int(recalculationPeriodTextField.text!) else { return }
		dictionary[NotificationStrings.group] = group
		dictionary[NotificationStrings.factor] = factor
		dictionary[NotificationStrings.period] = period
		
		NotificationCenter.default.post(
			name: Notification.Name(rawValue: NotificationStrings.parameterScreenNotificationName),
			object: nil,
			userInfo: dictionary
		)
		
		router?.routeToSimulator()	
	}
}
