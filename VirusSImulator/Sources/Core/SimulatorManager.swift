//
//  SimulatorManager.swift
//  VirusSimulator
//
//  Created by Egor SAUSHKIN on 06.05.2023.
//

import UIKit

/// Протокол для передачи бизнес-модели приложения в UI.
protocol SimulatorProtocol {
	/// Метод заражения человека вирусом.
	/// - Parameter cellID: Принимает параметр ячейки, выбранной в которой находится человек.
	func makeHumanSick(by cellID: Int)
	
	/// Показывает количество группы людей в зависимости от заданных параметров groupSize.
	/// - Returns: Возвращает количество людей в группе , заданной пользователем.
	func showGroupOfHumans() -> Int
	
	/// Метод для запуска симулятора распространения вируса.
	/// - Parameters:
	///   - cellID: Входящий параметр с номером ячейки.
	///   - closure: Замыкание по завершению расчета инфицированных.
	func virusInfectionStart(by cellID: Int, _ closure: @escaping () -> ())
	
	/// Метод показывает количество больных людей.
	/// - Returns: Возвращает количество больных людей.
	func showSickPeople() -> Int
	
	/// Метод показывает количество здоровых людей.
	/// - Returns: Возвращает количество здоровых людей.
	func showHealthyPeople() -> Int
	
	/// Метод для выгрузки актуальной информации о заболевших и здоровых.
	/// - Returns: Возвращает массив моделей людей с актуальным статусом о заболеваемости.
	func sickStatus() -> [HumanModel]
	
	/// Создает группу людей в зависимости от заданных параметров groupSize.
	func createGroupOfHumans()
	
	/// Удаляет группу людей.
	func deleteGroupOfHumans()
}

/// Класс-менеджер для построения расчета для симулятора заражения людей.
final class SimulatorManager: SimulatorProtocol {
	/// Количество людей в моделируемой группе.
	private var groupSize: Int
	/// Количество людей, которые будут заражены 1 человеком при контакте.
	private var infectionFactor: Int
	/// Период перерасчета количества зараженных людей.
	private var recalculationPeriod: Int
	/// Поле содержит актуальную информацию о больных и здоровых людях всей группы.
	private var infectionStatistics = [HumanModel]()
	
	/// Создание класса-менеджера для построения расчета.
	/// - Parameters:
	///   - groupSize: Количество людей в моделируемой группе.
	///   - infectionFactor: Количество людей, которые будут заражены 1 человеком при контакте.
	///   - recalculationPeriod: Период перерасчета количества зараженных людей.
	init(groupSize: Int, infectionFactor: Int, recalculationPeriod: Int) {
		self.groupSize = groupSize
		self.infectionFactor = infectionFactor
		self.recalculationPeriod = recalculationPeriod
	}
	
	/// Метод для запуска симулятора распространения вируса.
	/// - Parameters:
	///   - cellID: Принимает параметр ячейки, выбранной в которой находится человек.
	///   - closure: Замыкание по завершению расчета инфицированных.
	func virusInfectionStart(by cellID: Int, _ closure: @escaping () -> ()) {
		var virusAffectedCells = [Int]()
		DispatchQueue.global().asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(recalculationPeriod)) { [weak self] in
			// Формируем зону подверженную вирусному заражению.
			let one = cellID - 1
			let two = cellID - 5
			let three = cellID - 6
			let four = cellID - 7
			let five = cellID + 1
			let six = cellID + 5
			let seven = cellID + 6
			let eight = cellID + 7
			let fullVirusAffectedArea = [one, two, three, four, five, six, seven, eight]
			guard let groupSize = self?.groupSize else { return }
			
			// Делаем проверки:
			// Чтобы зона поражения не выходила за пределы экрана в минус.
			let areaNoNegative = fullVirusAffectedArea.filter({$0 > 0})
			
			// Чтобы зона поражения не выходила за пределы экрана в плюс.
			var areaNoMaxPositive = areaNoNegative.filter({$0 < groupSize})
			
			// Проверяем заражены ли элементы "соседи".
			areaNoMaxPositive.enumerated().forEach { index, cell in
				if self?.infectionStatistics[cell].isSick == true {
					areaNoMaxPositive.removeAll(where: {$0 == cell})
				}
			}
			
			// Вычисляем согласно условиям случайное количество зараженных в зависимости от infectionFactor.
			guard let infectionFactor = self?.infectionFactor else { return }
			let maximumVirusAffectedNumberOfPeople = Int.random(in: 1...infectionFactor)
			if maximumVirusAffectedNumberOfPeople >= 8 {
				// Максимальная зона поражения.
				for _ in 1...8 {
					guard let randomCell = areaNoMaxPositive.randomElement() else { return }
					if !virusAffectedCells.contains(randomCell) {
						virusAffectedCells.append(randomCell)
					}
					self?.virusStatisticsUpdate(virusAffectedCells)
				}
			} else {
				// Минимальная зона поражения.
				for _ in 1...maximumVirusAffectedNumberOfPeople {
					guard let randomCell = areaNoMaxPositive.randomElement() else { return }
					if !virusAffectedCells.contains(randomCell) {
						virusAffectedCells.append(randomCell)
					}
					self?.virusStatisticsUpdate(virusAffectedCells)
				}
			}
			closure()
		}
	}
	
	// MARK: - Public methods
	
	/// Показывает количество группы людей в зависимости от заданных параметров groupSize.
	/// - Returns: Возвращает количество людей в группе , заданной пользователем.
	func showGroupOfHumans() -> Int {
		infectionStatistics.count
	}
	
	/// Метод показывает количество больных людей.
	/// - Returns: Возвращает количество больных людей.
	func showSickPeople() -> Int {
		infectionStatistics.filter({ $0.isSick }).count
	}
	
	/// Метод показывает количество здоровых людей.
	/// - Returns: Возвращает количество здоровых людей.
	func showHealthyPeople() -> Int {
		infectionStatistics.filter({ $0.isSick == false }).count
	}
	
	/// Метод заражения человека вирусом.
	/// - Parameter cellID: Принимает параметр ячейки, выбранной в которой находится человек.
	func makeHumanSick(by cellID: Int) {
		infectionStatistics[cellID].isSick = true
	}
	
	/// Метод для выгрузки актуальной информации о заболевших и здоровых.
	/// - Returns: Возвращает массив моделей людей с актуальным статусом о заболеваемости.
	func sickStatus() -> [HumanModel] {
		infectionStatistics
	}
	
	/// Удаляет группу людей.
	func deleteGroupOfHumans() {
		if !infectionStatistics.isEmpty {
			infectionStatistics.removeAll()
		}
	}
	
	/// Создает группу людей в зависимости от заданных параметров groupSize.
	func createGroupOfHumans() {
		for _ in 1...groupSize {
			infectionStatistics.append(HumanModel())
		}
	}
	
	// MARK: - Internal methods
	
	/// Метод для обновления статуса о заболевании всей группы людей.
	/// - Parameter sickGroup: Параметр для ввода группы людей с обновленным статусом о заболевании.
	internal func virusStatisticsUpdate(_ sickGroup: [Int]) {
		var tempStatistics = infectionStatistics
		sickGroup.forEach { id in
			tempStatistics[id].isSick = true
		}
		infectionStatistics = tempStatistics
	}
}
