//
//  SimulatorViewController.swift
//  VirusSimulator
//
//  Created by Egor SAUSHKIN on 07.05.2023.
//

import UIKit

/// Класс для отображения экрана симулятора вируса.
final class SimulatorViewController: UIViewController {
	
	// MARK: - Parameters
	
	/// Презентер для экрана симулятора вируса.
	var presenter: SimulatorScreenPresenterProtocol?
	var cornerRadiusMultiplier: CGFloat = 4
	private var viewModel = SimulatorScreenModel(
		groupNumber: Int(),
		healthyNumber: Int(),
		sickNumber: Int(),
		isSick: [Bool]()
	)
	
	private lazy var layout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumInteritemSpacing = Sizes.spacing
		layout.minimumLineSpacing = Sizes.spacing
		layout.sectionInset = UIEdgeInsets(
			top: Sizes.spacing,
			left: Sizes.spacing,
			bottom: Sizes.spacing,
			right: Sizes.spacing
		)
		return layout
	}()
	
	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(SimulatorCollectionViewCell.self, forCellWithReuseIdentifier: TitleStrings.simulatorCellName)
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: TitleStrings.defaultCellName)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()
	
	// MARK: - Override methods
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewSetup()
		collectionView.reloadData()
		navigationItem.title = TitleStrings.navigationNameSick + "\(viewModel.sickNumber)" + TitleStrings.navigationNameHealthy + "\(viewModel.healthyNumber)"
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupCollectionView()
		addGesture()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		presenter?.clearView()
		viewModel = SimulatorScreenModel(
			groupNumber: Int(),
			healthyNumber: Int(),
			sickNumber: Int(),
			isSick: [Bool]()
		)
	}
	
	// MARK: Layout setup private methods
	
	private func viewSetup() {
		view.backgroundColor = .white
		guard let model = presenter?.present() else { return }
		viewModel = model
	}
	
	private func setupCollectionView(){
		view.addSubview(collectionView)
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}

// MARK: - SimulatorViewController Extention - UICollectionViewDataSource

extension SimulatorViewController: UICollectionViewDataSource {
	
	/// Метод для отображения количества ячеек коллекции симулятора вируса.
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.groupNumber
	}
	
	/// Метод для настройки отображения ячеек внутри коллекции.
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleStrings.simulatorCellName, for: indexPath) as? SimulatorCollectionViewCell else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleStrings.defaultCellName, for: indexPath)
			return cell
		}
		let cellData = viewModel.isSick[indexPath.row]
		cell.humanView.layer.cornerRadius = cell.frame.height/cornerRadiusMultiplier
		switch cellData {
		case true:
			cell.shakeSick()
			return cell
		case false:
			cell.shakeHealthy()
			return cell
		}
	}
	
	/// Метод для настройки отображения по нажатию на ячейку.
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let selectedModel = presenter?.sickStatusUpdate(cellID: indexPath.row) else { return }
		viewModel = selectedModel
		collectionView.reloadItems(at: [indexPath])
		guard let areaModel = presenter?.areaStatusUpdate(cellID: indexPath.row, collection: collectionView) else { return }
		viewModel = areaModel
		navigationItem.title = TitleStrings.navigationNameSick + "\(viewModel.sickNumber)" + TitleStrings.navigationNameHealthy + "\(viewModel.healthyNumber)"
	}
	
	/// Метод для расчета размера количества ячеек и размера ячейки коллекции.
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing
		guard let itemSize = presenter?.itemSize(
			for: collectionView.frame.width,
			with: spacing ?? 0
		) else { return CGSize() }
		return itemSize
	}
}

// MARK: - SimulatorViewController Extention - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension SimulatorViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {}

// MARK: - Zoom gestures setup

extension SimulatorViewController {
	private func addGesture() {
		let pinchGesture = UIPinchGestureRecognizer(
			target: self,
			action: #selector(didPinch)
		)
		collectionView.addGestureRecognizer(pinchGesture)
	}
	
	@objc private func didPinch(_ gesture: UIPinchGestureRecognizer) {
		if gesture.state == .changed {
			let scale = gesture.scale
			switch scale {
			case 1...2:
				presenter?.cellNumber = 6
				presenter?.cellSpacing = 7
				cornerRadiusMultiplier = 4
				view.layoutSubviews()
				collectionView.reloadData()
			case 2...3:
				presenter?.cellNumber = 5
				presenter?.cellSpacing = 6
				cornerRadiusMultiplier = 3.5
				view.layoutSubviews()
				collectionView.reloadData()
			case 3...4:
				presenter?.cellNumber = 4
				presenter?.cellSpacing = 5
				cornerRadiusMultiplier = 3
				view.layoutSubviews()
				collectionView.reloadData()
			case 4...5:
				presenter?.cellNumber = 3
				presenter?.cellSpacing = 4
				cornerRadiusMultiplier = 2.8
				view.layoutSubviews()
				collectionView.reloadData()
			default:
				break
			}
		}
	}
}
