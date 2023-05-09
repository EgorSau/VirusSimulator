//
//  SimulatorScreenModel.swift
//  VirusSimulator
//
//  Created by Egor SAUSHKIN on 07.05.2023.
//

/// Модель для отображения данных на экране симулятора вируса.
struct SimulatorScreenModel {
	/// Количество людей в группе.
	var groupNumber: Int
	/// Количество здоровых людей.
	var healthyNumber: Int
	/// Количество зараженных людей.
	var sickNumber: Int
	/// Общий статус о заболеваемости по всей группе людей.
	var isSick: [Bool]
}
