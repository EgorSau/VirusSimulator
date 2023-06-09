//
//  SimulatorScreenPresenter.swift
//  VirusSimulator
//
//  Created by Egor SAUSHKIN on 07.05.2023.
//

import UIKit

/// Протокол для использования методов Презентера экрана симулятора вируса.
protocol SimulatorScreenPresenterProtocol {
	/// Изменяемый параметр расстояния между ячейками коллекции.
	var cellSpacing: CGFloat { get set }
	
	/// Изменяемый параметр количества ячеек коллекции.
	var cellNumber: CGFloat { get set }
	
	/// Метод для отображения экрана и передачи модели во ВьюКонтроллер симулятора.
	/// - Returns: Возвращает модель для отображения экрана SimulatorScreenModel.
	func present() -> SimulatorScreenModel
	
	/// Метод для обновления экрана при перезапуске.
	func clearView()
	
	/// Метод для настройки размера ячейки коллекции симулятора и количества ячеек в строке.
	/// - Parameters:
	///   - width: Принимает вычисленной ширины фрейма коллекции.
	///   - spacing: Принимает параметр вычисленных расстояние между ячейками коллекции.
	/// - Returns: Возвращает размер ячейки (длину и ширину).
	func itemSize(for width: CGFloat, with spacing: CGFloat) -> CGSize
	
	/// Метод для обновления статуса о заболеваниях.
	/// - Parameters:
	///   - cellID: Принимает параметр ячейки, по которой было нажатие.
	///   - complition: Замыкание для передачи модели данных в UI.
	func sickStatusUpdate(cellID: Int, _ complition: @escaping (SimulatorScreenModel) -> ())
	
	/// Метод для обновления статуса о заболеваниях  вокруг зоны нажатия.
	/// - Parameters:
	///   - cellID: Принимает параметр ячейки, по которой было нажатие.
	///   - collection: Принимает коллекцию в которой было нажатие.
	///   - complition: Замыкание для передачи модели данных в UI.
	func areaStatusUpdate(cellID: Int, collection: UICollectionView, _ complition: @escaping (SimulatorScreenModel) -> ())
}

/// Класс для настройки презентации экрана с Симулатора вируса.
final class SimulatorScreenPresenter: SimulatorScreenPresenterProtocol {
	
	// MARK: - Parameters
	
	private var viewController: SimulatorViewController
	private var simulator: SimulatorProtocol
	private var status = [Bool]()
	private var isReloaded = [Int]()
	/// Изменяемый параметр расстояния между ячейками коллекции.
	var cellSpacing: CGFloat = 7
	/// Изменяемый параметр количества ячеек коллекции.
	var cellNumber: CGFloat = 6
	
	
	// MARK: - Init
	
	/// Инициализатор для класса презентации симулятора вируса.
	/// - Parameters:
	///   - viewController: Параметр ВьюКонтроллера класса SimulatorViewController.
	init(viewController: SimulatorViewController) {
		self.viewController = viewController
		simulator = SimulatorManager(
			groupSize: 1,
			infectionFactor: 1,
			recalculationPeriod: 1
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(getData),
			name: Notification.Name(rawValue: NotificationStrings.parameterScreenNotificationName),
			object: nil
		)
	}
	
	@objc private func getData(notification: Notification) {
		guard let userInfo = notification.userInfo else { return }
		guard let group = userInfo[NotificationStrings.group] as? Int else { return }
		guard let factor = userInfo[NotificationStrings.factor] as? Int else { return }
		guard let period = userInfo[NotificationStrings.period] as? Int else { return }
		simulator = SimulatorManager(
			groupSize: group,
			infectionFactor: factor,
			recalculationPeriod: period
		)
	}
	
	// MARK: - Public methods
	
	/// Метод для обновления экрана при перезапуске.
	func clearView() {
		simulator.deleteGroupOfHumans()
	}
	
	/// Метод для отображения экрана и передачи модели во ВьюКонтроллер симулятора.
	/// - Returns: Возвращает модель для отображения экрана SimulatorScreenModel.
	func present() -> SimulatorScreenModel {
		simulator.createGroupOfHumans()
		statusUpdate()
		return SimulatorScreenModel(
			groupNumber: simulator.showGroupOfHumans(),
			healthyNumber: simulator.showHealthyPeople(),
			sickNumber: simulator.showSickPeople(),
			isSick: status
		)
	}
	
	/// Метод для обновления статуса о заболеваниях.
	/// - Parameters:
	///   - cellID: Принимает параметр ячейки, по которой было нажатие.
	///   - complition: Замыкание для передачи модели данных в UI.
	func sickStatusUpdate(cellID: Int, _ complition: @escaping (SimulatorScreenModel) ->()) {
		simulator.makeHumanSick(by: cellID)
		statusUpdate()
		complition(
			SimulatorScreenModel(
				groupNumber: simulator.showGroupOfHumans(),
				healthyNumber: status.filter({$0 != true}).count,
				sickNumber: status.filter({$0 == true}).count,
				isSick: status
			)
		)
	}
	
	/// Метод для обновления статуса о заболеваниях  вокруг зоны нажатия.
	/// - Parameters:
	///   - cellID: Принимает параметр ячейки, по которой было нажатие.
	///   - collection: Принимает коллекцию в которой было нажатие.
	///   - complition: Замыкание для передачи модели данных в UI.
	func areaStatusUpdate(cellID: Int, collection: UICollectionView, _ complition: @escaping (SimulatorScreenModel) -> ()) {
		simulator.virusInfectionStart(by: cellID) {
			DispatchQueue.main.async {
				self.statusUpdate()
				complition(
					SimulatorScreenModel(
						groupNumber: self.simulator.showGroupOfHumans(),
						healthyNumber: self.status.filter({$0 != true}).count,
						sickNumber: self.status.filter({$0 == true}).count,
						isSick: self.status
					)
				)
				self.status.enumerated().forEach { index, isSick in
					if isSick && !self.isReloaded.contains(index) {
						self.isReloaded.append(index)
						collection.reloadItems(at: [IndexPath(row: index, section: 0)])
					}
				}
			}
		}
	}
	
	/// Метод для настройки размера ячейки коллекции симулятора и количества ячеек в строке.
	/// - Parameters:
	///   - width: Принимает вычисленной ширины фрейма коллекции.
	///   - spacing: Принимает параметр вычисленных расстояние между ячейками коллекции.
	/// - Returns: Возвращает размер ячейки (длину и ширину).
	func itemSize(for width: CGFloat, with spacing: CGFloat) -> CGSize {
		let neededWidth = width - cellSpacing * spacing
		let itemWidth = floor(neededWidth / cellNumber)
		return CGSize(width: itemWidth, height: itemWidth)
	}
	
	// MARK: - Private methods
	
	private func statusUpdate() {
		var tempStatus = [Bool]()
		simulator.sickStatus().forEach { sickStatus in
			tempStatus.append(sickStatus.isSick)
		}
		status = tempStatus
	}
}
