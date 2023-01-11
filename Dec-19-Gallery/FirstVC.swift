//
//  ViewController.swift
//  Dec-19-Gallery
//
//  Created by Admin on 19/12/22.
//

import UIKit

class FirstVC: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var gridBtn: UIButton!
    
    @IBOutlet weak var listBtn: UIButton!
    
    var transitionState = 0
    
    var idxPath: IndexPath!
    
    var LAYOUT1: UICollectionViewCompositionalLayout!
    
    var LAYOUT2: UICollectionViewCompositionalLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    func setupCollectionView() {
        
        let inset = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        // layout - 1 START
        let item1Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        let item1 = NSCollectionLayoutItem(layoutSize: item1Size)
        item1.contentInsets = inset
        
        let group1Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3))
        let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: group1Size, subitems: [item1])
        
        let section1 = NSCollectionLayoutSection(group: group1)
        
        let layout1 = UICollectionViewCompositionalLayout(section: section1)
        LAYOUT1 = layout1
        // layout - 1 END
        
        
        // layout - 2 START
        let item2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item2 = NSCollectionLayoutItem(layoutSize: item2Size)
        item2.contentInsets = inset
        let group2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/2))
        let group2 = NSCollectionLayoutGroup.horizontal(layoutSize: group2Size, subitems: [item2])
        let section2 = NSCollectionLayoutSection(group: group2)
        let layout2 = UICollectionViewCompositionalLayout(section: section2)
        LAYOUT2 = layout2
        // layout - 2 END
        
        collectionView.collectionViewLayout = layout1
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let collectionNib = UINib(nibName: Constants.customCVCell, bundle: nil)
        collectionView.register(collectionNib, forCellWithReuseIdentifier: Constants.collectionNibCell)
    }
    
    

    
    @IBAction func gridBtnAction(_ sender: Any) {
        doTransition(btn: "gridBtn")
    }
    
    
    @IBAction func listBtnAction(_ sender: Any) {
        doTransition(btn: "listBtn")
    }
    
    func doTransition(btn: String) {
        gridBtn.isUserInteractionEnabled = false
        listBtn.isUserInteractionEnabled = false
        if(btn == "gridBtn") {
            collectionView.startInteractiveTransition(to: LAYOUT1) { [weak self] _,_ in
                guard let self = self else {
                    return
                }
                self.gridBtn.isUserInteractionEnabled = true
                self.listBtn.isUserInteractionEnabled = true
            }
        }
        else {
            collectionView.startInteractiveTransition(to: LAYOUT2) { [weak self] _,_ in
                guard let self = self else {
                    return
                }
                self.gridBtn.isUserInteractionEnabled = true
                self.listBtn.isUserInteractionEnabled = true
            }
        }
        collectionView.finishInteractiveTransition()
    }
    

}

extension FirstVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        idxPath = indexPath
        performSegue(withIdentifier: Constants.gotoDet, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Constants.gotoDet) {
            if let second = segue.destination as? SecondVC {
                second.loadViewIfNeeded()
                second.showImg.image = UIImage(named: ImgList.list[idxPath.row].imgName)
            }
        }
    }
    
}

extension FirstVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImgList.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionNibCell, for: indexPath) as! customCVCell
                
        cell.showImg.image = UIImage(named: ImgList.list[indexPath.row].imgName)
        
        return cell
        
    }
}

