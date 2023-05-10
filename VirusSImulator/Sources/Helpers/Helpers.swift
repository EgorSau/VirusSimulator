//
//  Helpers.swift
//  VirusSimulator
//
//  Created by Egor SAUSHKIN on 09.05.2023.
//

import UIKit

enum NotificationStrings {
	static let parameterScreenNotificationName = "getData"
	static let group = "group"
	static let factor = "factor"
	static let period = "period"
}

enum TitleStrings {
	static let parametersButton = "Запустить моделирование"
	static let parametersImage = "umbrella"
	static let groupTextFieldPlaceholder = " Введите размер группы людей"
	static let infectionFactorTextFieldPlaceholder = " Введите фактор заражения"
	static let recalculationPeriodTextFieldPlaceholder = " Введите скорость заражения (секунды)"
	static let simulatorCellName = "SimulatorCell"
	static let defaultCellName = "DefaultCell"
	static let navigationNameSick = "Больных: "
	static let navigationNameHealthy = " / Здоровых: "
}

enum AnimationStrings {
	static let animationKeyPath = "position.x"
	static let shakeHealthyAnimationName = "shakeHealthy"
	static let shakeSickAnimationName = "shakeSick"
}

enum Sizes {
	//Общие.
	static let spacing: CGFloat = 8
	static let logoWidth: CGFloat = 200
	static let logoHeight: CGFloat = 200
	// TextField.
	static let cornerRadius: CGFloat = 10
	static let borderWidth: CGFloat = 0.5
	static let fontSize: CGFloat = 16
}
