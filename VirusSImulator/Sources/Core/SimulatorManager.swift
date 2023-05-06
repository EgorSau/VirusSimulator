//
//  SimulatorManager.swift
//  VirusSImulator
//
//  Created by Egor SAUSHKIN on 06.05.2023.
//

import UIKit

/// Протокол для передачи бизнес-модели приложения в UI
protocol SimulatorProtocol {
	/// Метод заражения человека вирусом
	func makeHumanSick(by cellID: Int)
	/// Создает группу людей в зависимости от заданных параметров groupSize
	func createGroupOfHumans()
	/// Метод для запуска симулятора распространения вируса
	func virusInfectionStart(by cellID: Int)
	/// Метод показывает количество больных людей
	func showSickPeople() -> Int
	/// Метод показывает количество здоровых людей
	func showHealthyPeople() -> Int
}

/// Класс-менеджер для построения расчета для симулятора заражения людей
final class SimulatorManager {
	/// Количество людей в моделируемой группе
	var groupSize: Int
	/// Количество людей, которые будут заражены 1 человеком при контакте
	var infectionFactor: Int
	/// Период перерасчета количества зараженных людей
	var recalculationPeriod: Int
	/// Поле содержит актуальную информацию о больных и здоровых людях всей группы
	private var infectionStatistics = [HumanModel]()
	
	/// Создание класса-менеджера для построения расчета
	/// - Parameters:
	///   - groupSize: Количество людей в моделируемой группе
	///   - infectionFactor: Количество людей, которые будут заражены 1 человеком при контакте
	///   - recalculationPeriod: Период перерасчета количества зараженных людей
	init(groupSize: Int, infectionFactor: Int, recalculationPeriod: Int) {
		self.groupSize = groupSize
		self.infectionFactor = infectionFactor
		self.recalculationPeriod = recalculationPeriod
	}
	
	/// Метод для запуска симулятора распространения вируса
	/// - Parameters:
	///   - cellID: Принимает параметр ячейки, выбранной в которой находится человек
	/// - Returns: Возвращает номера ячеек в которых люди заражены от выбранного человека
	func virusInfectionStart(by cellID: Int) -> [Int] {
		var virusAffectedCells = [Int]()
		DispatchQueue.main.async {
			// Формируем зону подверженную вирусному заражению
			let one = cellID - 1
			let two = cellID - 5
			let three = cellID - 6
			let four = cellID - 7
			let five = cellID + 1
			let six = cellID + 5
			let seven = cellID + 6
			let eight = cellID + 7
			var fullVirusAffectedArea = [one, two, three, four, five, six, seven, eight]
			// Делаем проверки:
			fullVirusAffectedArea.enumerated().forEach { index, cell in
				// Чтобы зона поражения не выходила за пределы экрана
				if cell > self.groupSize || cell <= 0 {
					fullVirusAffectedArea.remove(at: index)
				}
				// Проверяем заражены ли элементы "соседи"
				if self.infectionStatistics[cell].isSick {
					fullVirusAffectedArea.remove(at: index)
				}
			}
			// Вычисляем согласно условиям случайное количество зараженных в зависимости от infectionFactor
			let maximumVirusAffectedNumberOfPeople = Int.random(in: 0...self.infectionFactor)
			if maximumVirusAffectedNumberOfPeople >= 8 {
				// Максимальная зона поражения
				virusAffectedCells = fullVirusAffectedArea
			} else {
				// Минимальная зона поражения
				for _ in 1...maximumVirusAffectedNumberOfPeople {
					guard let randomCell = fullVirusAffectedArea.randomElement() else { return }
					virusAffectedCells.append(randomCell)
				}
			}

		}
		return virusAffectedCells
	}
	
	/// Создает группу людей в зависимости от заданных параметров groupSize
	func createGroupOfHumans() -> [HumanModel] {
		for _ in 1...groupSize {
			infectionStatistics.append(HumanModel())
		}
		return infectionStatistics
	}
	
	/// Метод показывает количество больных людей
	func showSickPeople() -> Int {
		infectionStatistics.filter({ $0.isSick }).count
	}
	
	/// Метод показывает количество здоровых людей
	func showHealthyPeople() -> Int {
		infectionStatistics.filter({ $0.isSick == false }).count
	}
	
	/// Метод заражения человека вирусом
	/// - Parameter cellID: Принимает параметр ячейки, выбранной в которой находится человек
	func makeHumanSick(by cellID: Int) {
		infectionStatistics[cellID].isSick = true
	}
}
