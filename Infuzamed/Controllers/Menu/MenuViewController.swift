//
//  MenuViewController.swift
//  Infuzamed
//
//  Created by Vazgen on 7/13/23.
//

import UIKit

final class MenuViewController: UIViewController {
    // MARK: - @IBOutlet
    private let menuItems = MenuItems.allCases

    @IBOutlet var menuCollectionView: UICollectionView!
    // MARK: - Base
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        let token = LoginManager.shared.retrieveTokenFromKeychain()
    }
}

// MARK: - Private
private extension MenuViewController {
    // MARK: - Setup
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 30
        layout.scrollDirection = .vertical
        layout.sectionInsetReference = .fromSafeArea
        layout.sectionInset = UIEdgeInsets(top: 16, left: 40, bottom: 0, right: 40)

        menuCollectionView.collectionViewLayout = layout
        layout.invalidateLayout()
        menuCollectionView.backgroundColor = .clear
        menuCollectionView.showsVerticalScrollIndicator = false
        menuCollectionView.showsHorizontalScrollIndicator = false
        menuCollectionView.contentInsetAdjustmentBehavior = .always
        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionViewCell")
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menuItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
        cell.configure(item: menuItems[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if menuItems[indexPath.row] == .bloodPressure {
            navigationController?.pushViewController(DeviceListViewController(), animated: true)
        } else {
            let vc = ScannerVc().getViewControllerFromStoryboard()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - CollectionView layout

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 130)
    }
}

enum MenuItems: String, CaseIterable {
    case infuzamed
    case ecg
    case sp02
    case bloodPressure
    case weight
    case bloodGlucose
    case temperature
    case profile
}
