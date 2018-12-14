//
//  SortController.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/6.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

let ScreenWidth  = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
let ItemWidth = (UIScreen.main.bounds.width - 20)/3
let Identify = "collection_cell"
let headerIdentifier = "CollectionHeaderView"
let footIdentifier   = "CollectionFootView"

class SortController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CellSortTitle.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identify, for: indexPath) as! SCell
        if indexPath.row == CellSortTitle.count {
            cell.title.text = "添加"
            cell.selectedBlock = {tag in
                CellSortTitle.append("图图图")
                collectionView.reloadData()
            }
        }else{
            cell.title.text = "\(indexPath.row+1).\(CellSortTitle[indexPath.row])"
            cell.selectedBlock = {tag in
                CellSortTitle.remove(at: tag)
                collectionView.reloadData()
            }
        }
        cell.row = indexPath.row
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ItemWidth, height: ItemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: ScreenWidth, height: 40)
    }
    //footer高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: ScreenWidth, height: 40)
    }
    
    //设定header和footer的方法，根据kind不同进行不同的判断即可
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            let headerView : CollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! CollectionHeaderView
            headerView.view.backgroundColor = UIColor.white
            headerView.label.text = "排序源"
            return headerView
        }else{
            let footView : CollectionFootView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footIdentifier, for: indexPath) as! CollectionFootView
            footView.view.backgroundColor = UIColor.orange
            return footView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: ItemWidth, height: ItemWidth)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        layout.headerReferenceSize = CGSize.init(width: ScreenWidth, height: 40)
        layout.footerReferenceSize = CGSize.init(width: ScreenWidth, height: 40)
        
        let collectionV = UICollectionView.init(frame: CGRect(x:0, y:64, width:ScreenWidth, height:ScreenHeight - 64), collectionViewLayout: layout)
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.backgroundColor = UIColor.white
        self.view.addSubview(collectionV)
        
        collectionV.register(SCell.self, forCellWithReuseIdentifier: Identify)
        collectionV.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionV.register(CollectionFootView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footIdentifier)

        self.view.backgroundColor = UIColor.white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
