//
//  EarningsController.swift
//  GoJekProvider
//
//  Created by CSS on 11/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class EarningsController: UIViewController {

    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var earningCollectionView: UICollectionView!
    
    var earningData: EarningResponseData?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initalLoads()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide show tabbar
        hideTabBar()
        navigationController?.isNavigationBarHidden = false
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension EarningsController {
    
    private func initalLoads(){
        setLeftBarButtonWith(color: .blackColor)
        title = MyAccountConstant.Earning.localized
        
        earningCollectionView?.register(UINib(nibName: MyAccountConstant.EarningsCell, bundle: nil), forCellWithReuseIdentifier: MyAccountConstant.EarningsCell)
        earningCollectionView.delegate = self
        earningCollectionView.dataSource = self
        
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.8, height: earningCollectionView.frame.size.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 0.8
        flowLayout.sideItemAlpha = 1.0
        flowLayout.spacingMode = .fixed(spacing: 5.0)
        flowLayout.minimumLineSpacing = 5
        earningCollectionView.collectionViewLayout = flowLayout
        view.backgroundColor = .backgroundColor
        myAccountPresenter?.EarningDetail(providerId: AppManager.share.getUserDetails()?.id?.toString() ?? String.Empty)
        todayButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x16)
        weekButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x16)
        monthButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x16)

        monthButton.setTitle(MyAccountConstant.thisMonth.localized, for: .normal)
        weekButton.setTitle(MyAccountConstant.thisWeek.localized, for: .normal)
        todayButton.setTitle(MyAccountConstant.today.localized, for: .normal)
        monthButton.addTarget(self, action: #selector(tapEarning(_:)), for: .touchUpInside)
        weekButton.addTarget(self, action: #selector(tapEarning(_:)), for: .touchUpInside)
        todayButton.addTarget(self, action: #selector(tapEarning(_:)), for: .touchUpInside)

        monthButton.setTitleColor(.lightGray, for: .normal)
        weekButton.setTitleColor(.lightGray, for: .normal)
        todayButton.setTitleColor(.white, for: .normal)
        monthButton.backgroundColor = .boxColor
        weekButton.backgroundColor = .boxColor
        todayButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        monthButton.setCornerRadiuswithValue(value: 8)
        weekButton.setCornerRadiuswithValue(value: 8)
        todayButton.setCornerRadiuswithValue(value: 8)

    }
    @objc func tapEarning(_ sender:UIButton) {
        if sender.tag == 0 {

            monthButton.setTitleColor(.lightGray, for: .normal)
            weekButton.setTitleColor(.lightGray, for: .normal)
            todayButton.setTitleColor(.white, for: .normal)
            monthButton.backgroundColor = .boxColor
            weekButton.backgroundColor = .boxColor
            todayButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
            earningCollectionView.scrollToItem(at: [0,0], at: .centeredHorizontally, animated: true)
            let cell = earningCollectionView.cellForItem(at: [0,0]) as? EarningsCell
            cell?.pointsLabel.text = Double(earningData?.today ?? "0")?.setCurrency()
            cell?.targetLabel.text = MyAccountConstant.todayTask.localized

        }else if sender.tag == 1 {

            monthButton.setTitleColor(.lightGray, for: .normal)
            weekButton.setTitleColor(.white, for: .normal)
            todayButton.setTitleColor(.lightGray, for: .normal)
            monthButton.backgroundColor = .boxColor
            weekButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
            todayButton.backgroundColor = .boxColor
            earningCollectionView.scrollToItem(at: [0,1], at: .centeredHorizontally, animated: true)
            let cell = earningCollectionView.cellForItem(at: [0,1]) as? EarningsCell
            cell?.targetLabel.text = MyAccountConstant.weekTask.localized
            cell?.pointsLabel.text = Double(earningData?.week ?? "0")?.setCurrency()

        }else{

            monthButton.setTitleColor(.white, for: .normal)
            weekButton.setTitleColor(.lightGray, for: .normal)
            todayButton.setTitleColor(.lightGray, for: .normal)
            monthButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
            weekButton.backgroundColor = .boxColor
            todayButton.backgroundColor = .boxColor
            earningCollectionView.scrollToItem(at: [0,2], at: .centeredHorizontally, animated: true)
            let cell = earningCollectionView.cellForItem(at: [0,2]) as? EarningsCell
            cell?.targetLabel.text = MyAccountConstant.monthTask.localized
            cell?.pointsLabel.text = Double(earningData?.month ?? "0")?.setCurrency()

        }
    }
}
extension EarningsController: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyAccountConstant.EarningsCell, for: indexPath) as! EarningsCell
        
        if indexPath.section == 0 {
            cell.pointsLabel.text = Double(earningData?.today ?? "0")?.setCurrency()
            cell.targetLabel.text = MyAccountConstant.todayTask.localized
          
        }else if indexPath.section == 1 {
            
            cell.targetLabel.text = MyAccountConstant.weekTask.localized
            cell.pointsLabel.text = Double(earningData?.week ?? "0")?.setCurrency()
        }else{
            cell.targetLabel.text = MyAccountConstant.monthTask.localized
            cell.pointsLabel.text = Double(earningData?.month ?? "0")?.setCurrency()
            
        }
        
        return cell
    }
}

extension EarningsController: MyAccountPresenterToMyAccountViewProtocol{
    func getEarningsSuccess(earningEntity: EarningEntity) {
        earningData = earningEntity.responseData
        earningCollectionView.reloadData()
    }
}
extension EarningsController:UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let visibleRect = CGRect(origin: earningCollectionView.contentOffset, size: earningCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = earningCollectionView.indexPathForItem(at: visiblePoint)
        if visibleIndexPath?.row == 0 {
            DispatchQueue.main.async {
                
                self.monthButton.setTitleColor(.lightGray, for: .normal)
                self.weekButton.setTitleColor(.lightGray, for: .normal)
                self.todayButton.setTitleColor(.white, for: .normal)
                self.monthButton.backgroundColor = .white
                self.weekButton.backgroundColor = .white
                self.todayButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
                self.earningCollectionView.scrollToItem(at: [0,0], at: .centeredHorizontally, animated: true)
                let cell = self.earningCollectionView.cellForItem(at: [0,0]) as? EarningsCell
                cell?.pointsLabel.text = Double(self.earningData?.today ?? "0")?.setCurrency()
                cell?.targetLabel.text = MyAccountConstant.todayTask.localized
            }
        }else if visibleIndexPath?.row == 1 {
            DispatchQueue.main.async {
                
                self.monthButton.setTitleColor(.lightGray, for: .normal)
                self.weekButton.setTitleColor(.white, for: .normal)
                self.todayButton.setTitleColor(.lightGray, for: .normal)
                self.monthButton.backgroundColor = .white
                self.weekButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
                self.todayButton.backgroundColor = .white
                self.earningCollectionView.scrollToItem(at: [0,1], at: .centeredHorizontally, animated: true)
                let cell = self.earningCollectionView.cellForItem(at: [0,1]) as? EarningsCell
                cell?.targetLabel.text = MyAccountConstant.weekTask.localized
                cell?.pointsLabel.text = Double(self.earningData?.week ?? "0")?.setCurrency()
            }
        }else if visibleIndexPath?.row == 2 {
            DispatchQueue.main.async {
                
                self.monthButton.setTitleColor(.white, for: .normal)
                self.weekButton.setTitleColor(.lightGray, for: .normal)
                self.todayButton.setTitleColor(.lightGray, for: .normal)
                self.monthButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
                self.weekButton.backgroundColor = .white
                self.todayButton.backgroundColor = .white
                self.earningCollectionView.scrollToItem(at: [0,2], at: .centeredHorizontally, animated: true)
                let cell = self.earningCollectionView.cellForItem(at: [0,2]) as? EarningsCell
                cell?.targetLabel.text = MyAccountConstant.monthTask.localized
                cell?.pointsLabel.text = Double(self.earningData?.month ?? "0")?.setCurrency()
            }
        }
        
    }

}
