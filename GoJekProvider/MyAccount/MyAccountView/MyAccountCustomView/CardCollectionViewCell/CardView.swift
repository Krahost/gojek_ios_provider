//
//  CardView.swift
//  GoJekProvider
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

protocol CardViewDelegate: class {
    
    func addAmountToWallet()
    func deleteButtonClick()
    func addNewCardButtonClick()
}

class CardView: UIView {
    
    //MARK: - IBOutlet
    @IBOutlet weak var paymentCardCollectionView: UICollectionView!
    @IBOutlet weak var paymentHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var cardCancelButton: UIButton!
    @IBOutlet weak var cardDeleteButton: UIButton!
    
    @IBOutlet weak var cancelButtonView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var cardOuterView: UIView!
    @IBOutlet weak var savedCardsLabel: UILabel!
    
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var cancelImageView: UIImageView!
    
    //MARK: - LocalVariable
    var selectedCardIndex = -1
    var selectedCardId = 0
    var selectedCard_token = String.Empty
    var cardsList: CardEntityResponse?
    
    weak var delegate: CardViewDelegate?
    
    var isDeleteCancelShow:Bool = true {
        didSet {
            cancelButtonView.isHidden = isDeleteCancelShow
            deleteView.isHidden = isDeleteCancelShow
            selectedCardIndex = -1
            paymentCardCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialViewLoad()
    }
    
    override func layoutIfNeeded() {
        addCardButton.setCornorRadius()
    }
}

extension CardView {
    
    private func initialViewLoad() {
        
        cancelImageView.image = UIImage(named: MyAccountConstant.cancelImage)
        cancelImageView.imageTintColor(color1: .appPrimaryColor)
        
        deleteImageView.image = UIImage(named: MyAccountConstant.deleteImage)
        deleteImageView.imageTintColor(color1: .appPrimaryColor)
        
        paymentCardCollectionView.register(nibName: MyAccountConstant.PaymentCardCell)
        cardOuterView.backgroundColor = .white
        
        savedCardsLabel.text = Constant.savedCards.localized
        savedCardsLabel.font = .setCustomFont(name: .medium, size: .x18)

        cancelButtonView.setCornerRadiuswithValue(value: 5.0)
        deleteView.setCornerRadiuswithValue(value: 5.0)
        addCardButton.setCornerRadiuswithValue(value: 5.0)
        
        isDeleteCancelShow = true
        
        addCardButton.setTitleColor(.appPrimaryColor, for: .normal)
        addCardButton.setTitle(Constant.addCard.localized, for: .normal)
        addCardButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x16)
        
        cardCancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        addCardButton.addTarget(self, action: #selector(addCardButtonAction), for: .touchUpInside)
        cardDeleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        self.backgroundColor = .backgroundColor
        self.cardOuterView.backgroundColor = .boxColor
        self.paymentCardCollectionView.backgroundColor = .boxColor
    }
    
    @objc func cancelButtonAction() {
        isDeleteCancelShow = true
    }
    
    @objc func addCardButtonAction() {
        delegate?.addNewCardButtonClick()
    }
    
    @objc func deleteButtonAction() {
        delegate?.deleteButtonClick()
    }
}

//MARK: - UICollectionViewDataSource

extension CardView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cardsList?.responseData?.count == 0 {
            paymentCardCollectionView.setBackView(imageName: Constant.ic_empty_card, message: "test")
        }
        else {
            paymentCardCollectionView.backgroundView = nil
        }
        return cardsList?.responseData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PaymentCardCell = paymentCardCollectionView.dequeueReusableCell(withReuseIdentifier: MyAccountConstant.PaymentCardCell, for: indexPath) as! PaymentCardCell
        let cards = cardsList?.responseData?[indexPath.row]
        cell.cardLabel.text = "\("**** **** ") \(cards?.last_four ?? String.Empty)"
        cell.cardNameLabel.text = cards?.brand
        cell.isSelectedItem = indexPath.row == selectedCardIndex
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension CardView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        isDeleteCancelShow = false
        selectedCardIndex = indexPath.row
        selectedCardId = cardsList?.responseData?[indexPath.row].id! ?? 0
        selectedCard_token = cardsList?.responseData?[indexPath.row].card_id ?? String.Empty
        paymentCardCollectionView.reloadInMainThread()
        delegate?.addAmountToWallet()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CardView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(3 - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(2.0))
        return CGSize(width: CGFloat(size), height: collectionView.bounds.height)
    }
}


