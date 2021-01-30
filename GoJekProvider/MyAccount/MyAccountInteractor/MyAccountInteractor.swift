//
//  MyAccountInteractor.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK: - MyAccountPresenterToMyAccountInteractorProtocol

class MyAccountInteractor: MyAccountPresenterToMyAccountInteractorProtocol {
    func providerStatusUpdate(id: Int, param: Parameters) {
        let url = "\(URLConstant.KProviderStatusUpdate)\(id)"
        WebServices.shared.requestToApi(type: ProfileEntity.self, with: url, urlMethod: .get, showLoader: true, params: param, encode: URLEncoding.default, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.myAccountPresenter?.providerStatusUpdate(profileEntity: responseValue)
            }
        })
    }
    
    var myAccountPresenter: MyAccountInteractorToMyAccountPresenterProtocol?
    
    //Get profile detail
    func getProfileDetail() {
        WebServices.shared.requestToApi(type: ProfileEntity.self, with: URLConstant.KProfiledetail, urlMethod: .get, showLoader: true, params: nil, encode: URLEncoding.default, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.myAccountPresenter?.viewProfileDetail(profileEntity: responseValue)
            }
        })
    }
    
    //Update profile detail
    func updateProfileDetail(param: Parameters, imageData: [String : Data]?) {
        WebServices.shared.requestToImageUpload(type: ProfileEntity.self, with: URLConstant.KProfiledetail, uploadData: imageData, showLoader: true, params: param, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.myAccountPresenter?.updateProfileDetail(profileEntity: responseValue)
            }
        })
    }
    
    func changePassword(param: Parameters) {
        WebServices.shared.requestToApi(type: ProfileEntity.self, with: URLConstant.KChangePassword, urlMethod: .post, showLoader: true, params: param, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.myAccountPresenter?.changePasswordResponse(profileEntity: responseValue)
            }
        })
    }
    
    // Add Document
    func addDocumentDetail(param: Parameters, uploadData: [String : Data]?, isTypePDF: Bool) {
        WebServices.shared.requestToImageUpload(type: SuccessEntity.self, with: URLConstant.KAddDocument, uploadData: uploadData, isTypePDF: isTypePDF,  showLoader: true, params: param, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.myAccountPresenter?.updateAddDocumentSuccess(documentEntity: responseValue)
            }
        })
    }
    
    //Get country list
    func countryListDetail(param: Parameters) {
        WebServices.shared.requestToApi(type: CountryEntity.self, with: URLConstant.KCountry, urlMethod: .post, showLoader: false, params: param, accessTokenAdd: false, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.myAccountPresenter?.updateCountryListSuccess(countryEntity: responseValue)
            }
        })
    }
    
    // Reset Password
    func resetPasswordDetail(param: Parameters) {
        WebServices.shared.requestToApi(type: ResetPasswordEntity.self, with: URLConstant.KResetPassword, urlMethod: .post, showLoader: true, params: param, accessTokenAdd: false, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.myAccountPresenter?.updateResetPasswordSuccess(resetPasswordEntity: responseValue)
            }
        })
    }
    
    //AddCard
    func addCard(param: Parameters) {
        
        WebServices.shared.requestToApi(type: CardEntityResponse.self, with: URLConstant.KAddCard, urlMethod: .post, showLoader: true,params: param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.addCardSuccess(addCardResponse: response)
            }
        }
    }
    
    //GetCard
    func getCard() {
        
        WebServices.shared.requestToApi(type: CardEntityResponse.self, with: URLConstant.KGetCard, urlMethod: .get, showLoader: true, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.getCardResponse(getCardResponse: response)
            }
        }
    }
    
    // delete card
    func deleteCard(cardID: Int) {
        
        WebServices.shared.requestToApi(type: CardEntityResponse.self, with: "\(URLConstant.KDeleteCard)/\(cardID)", urlMethod: .delete, showLoader: true, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.deleteCardSuccess(deleteCardResponse: response)
            }
        }
    }
    
    //wallet
    func addMoneyToWallet(param: Parameters) {
        
        WebServices.shared.requestToApi(type: AddAmountEntity.self, with: URLConstant.KAddMoney, urlMethod: .post, showLoader: true,params: param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.addMoneyToWalletSuccess(walletSuccessResponse: response)
            }
        }
        
    }
    //get service
    func getServiceDetail() {
        WebServices.shared.requestToApi(type: GetServiceEntity.self, with: URLConstant.KGetService, urlMethod: .get, showLoader: true,params: nil, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.getServiceSuccess(getServiceEntity: response)
            }
        }
    }
    //get RideType
    func getRideTypeDetail() {
        WebServices.shared.requestToApi(type: GetRideTypeEntity.self, with: URLConstant.KRideType, urlMethod: .get, showLoader: true,params: nil, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.getRideTypeSuccess(getRideTypeEntity: response)
            }
        }
    }
    
    func getDeliveryTypeDetail() {
        //CourierTypeEntity
        WebServices.shared.requestToApi(type: CourierTypeEntity.self, with: URLConstant.KDeliveryType, urlMethod: .get, showLoader: true,params: nil, accessTokenAdd: true) { [weak self] (response) in
                   guard let self = self else {
                       return
                   }
                   if let response = response?.value {
                       self.myAccountPresenter?.getDeliveryTypeSuccess(getCourierTypeEntity: response)
                   }
        }
        
    }

    
    
    //get Admin Service
    
    func getAdminServiceDetail() {
        WebServices.shared.requestToApi(type: GetAdminServiceEntity.self, with: URLConstant.KAdminService, urlMethod: .get, showLoader: true,params: nil, accessTokenAdd: true) { [weak self](response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.getAdminServiceSuccess(getAdminServiceEntity: response)
            }
        }
    }
    // add vehicle
    func AddVehicleDetail(param: Parameters, imageData: [String : Data]?) {
        WebServices.shared.requestToImageUpload(type: AddVehicleEntity.self, with: URLConstant.KAddVehicle, uploadData: imageData, showLoader: true, params: param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.myAccountPresenter?.getAddVehicleSuccess(getAddVehicleEntity: responseValue)
            }
        }
    }
    
    // edit vehicle
    func EditVehicleDetail(param: Parameters, imageData: [String : Data]?) {
        WebServices.shared.requestToImageUpload(type: AddVehicleEntity.self, with: URLConstant.KEditVehicle, uploadData: imageData, showLoader: true, params: param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.myAccountPresenter?.getAddVehicleSuccess(getAddVehicleEntity: responseValue)
            }
        }
    }
    
    
    func getShopTypeDetail() {
        WebServices.shared.requestToApi(type: ShopTypeEntity.self, with: URLConstant.KFoodieType, urlMethod: .get, showLoader: true,params: nil, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.getShopTypeSuccess(getShopTypeEntity: response)
            }
        }
    }
    
    // earning api
    func EarningDetail(providerId: String) {
        let earningUrl = URLConstant.KEarnings + "/" + providerId
        WebServices.shared.requestToApi(type: EarningEntity.self, with: earningUrl, urlMethod: .get, showLoader: true,params: nil, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.getEarningsSuccess(earningEntity: response)
            }
        }
    }
    
    
    func getCategoryDetail() {
        WebServices.shared.requestToApi(type: GetCategoryEntity.self, with: URLConstant.KGetCategory, urlMethod: .get, showLoader: true,params: nil, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.getCategorySuccess(getCategoryEntity: response)
            }
        }
    }
    
    func getSubCategoryDetail(param: Parameters) {
        WebServices.shared.requestToApi(type: GetSubCategoryEntity.self, with: URLConstant.KGetSubCategory, urlMethod: .post, showLoader: true,params: param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.getSubCategorySuccess(getSubCategoryEntity: response)
            }
        }
    }
    func getXuberServiceDetail(param: Parameters) {
        WebServices.shared.requestToApi(type: GetXuberServiceEntity.self, with: URLConstant.KGetxuberService, urlMethod: .post, showLoader: true,params: param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.getXuberServiceSuccess(getXuberServiceEntity: response)
            }
        }
    }
    
    
    func getLogoutDetail() {
        WebServices.shared.requestToApi(type: LogoutEntity.self, with: URLConstant.KLogout, urlMethod: .post, showLoader: true,params: nil, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.getLogoutServiceSuccess(getLogoutServiceEntity: response)
            }
        }
    }
    
    func updateLanguageDetail(param: Parameters) {
        WebServices.shared.requestToApi(type: LogoutEntity.self, with: URLConstant.KUpdateLanguage, urlMethod: .post, showLoader: true,params: param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.updateLanguageServiceSuccess(updateLanguageEntity: response)
            }
        }
    }
    func getTransactionList(param: Parameters,ishideLoader: Bool) {
        
        WebServices.shared.requestToApi(type: TransactionEntity.self, with: URLConstant.KTransaction, urlMethod: .get, showLoader: ishideLoader, params: param, accessTokenAdd: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.getTransactionList(transactionEntity: response)
            }
        }
    }
    func getBankTemplateList() {
        WebServices.shared.requestToApi(type: BankTemplateEntity.self, with: URLConstant.KBankTemplate, urlMethod: .get, showLoader: true,params: nil, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.getBankTemplateList(bankTemplateEntity: response)
            }
        }
    }
    
    func addBankDetailList(param: Parameters) {
        WebServices.shared.requestToApi(type: LogoutEntity.self, with: URLConstant.KAddBankDetails, urlMethod: .post, showLoader: true,params: param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.addBankDetailList(addBankEntity: response)
            }
        }
    }
    
    func editBankDetailList(param: Parameters) {
        WebServices.shared.requestToApi(type: LogoutEntity.self, with: URLConstant.KEditBankDetails, urlMethod: .post, showLoader: true,params: param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.editBankDetailList(editBankEntity: response)
            }
        }
    }
    
    func postAppSettings(param: Parameters) {
        WebServices.shared.requestToApi(type: BaseEntity.self, with: URLConstant.kAppSettings, urlMethod: .post, showLoader: true, params: param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.postAppSettingsResponse(baseEntity: response)
            }
        }
    }
    func sendOtp(param: Parameters) {
        
        WebServices.shared.requestToApi(type: sendOtpEntity.self, with: URLConstant.sendOtp, urlMethod: .post,showLoader: true,params: param,accessTokenAdd: false) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.myAccountPresenter?.sendOtpSuccess(sendOtpEntity: response)
            }
        }
    }
    
    func verifyOtp(param: Parameters) {
        
        WebServices.shared.requestToApi(type: VerifyOtpEntity.self, with: URLConstant.verifyOtp, urlMethod: .post,showLoader: true,params: param,accessTokenAdd: false) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.myAccountPresenter?.verifyOtpSuccess(verifyOtpEntity: response)
            }
        }
    }
    
    func qrCodeWalletTransfer(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: URLConstant.KQRCodeTransfer, urlMethod: .post, showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.myAccountPresenter?.qrCodeWalletTransferSuccess(successEntity: response)
            }
        }
    }
}

