//
//  SimulatorCollectionViewCell.swift
//  VirusSimulator
//
//  Created by Egor SAUSHKIN on 07.05.2023.
//

import UIKit

/// Класс для отображения Вью ячейки симулятора вируса.
final class SimulatorCollectionViewCell: UICollectionViewCell {
	
	// MARK: - Parameters
	
	/// Вью для изображения симулятора человека.
	lazy var humanView: UIView = {
		var view = UIView()
		view.backgroundColor = .systemGreen
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	// MARK: - Init
	
	/// Инициализатор ячейки с симулятором человека.
	/// - Parameter frame: Параметры фрейма.
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.contentView.addSubview(humanView)
		
		NSLayoutConstraint.activate([
			humanView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
			humanView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
			humanView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
			humanView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Override methods
	
	override func prepareForReuse() {
		super.prepareForReuse()
		humanView.backgroundColor = .systemGreen
	}
	
	/// Метод для анимации ячейки с симулятором здорового человека.
	func shakeHealthy() {
		let animation = CAKeyframeAnimation()
		animation.keyPath = AnimationStrings.animationKeyPath
		animation.values = [0, 10, -10, 10, -10, 0]
		animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
		animation.speed = 7
		animation.duration = 60
		animation.repeatCount = 20
		
		animation.isAdditive = true
		humanView.layer.add(animation, forKey: AnimationStrings.shakeHealthyAnimationName)
	}
	
	/// Метод для анимации ячейки с симулятором больного человека.
	func shakeSick() {
		humanView.backgroundColor = .systemRed
		let animation = CAKeyframeAnimation()
		animation.keyPath = AnimationStrings.animationKeyPath
		animation.values = [0, 25, -25, 25, -25, 0]
		animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
		animation.speed = 20
		animation.duration = 60
		animation.repeatCount = 20
		
		animation.isAdditive = true
		humanView.layer.add(animation, forKey: AnimationStrings.shakeSickAnimationName)
	}
}
