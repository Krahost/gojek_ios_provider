//
//  MyAccountPresenter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK: - MyAccountViewToMyAccountPresenterProtocol

class MyAccountPresenter: MyAccountViewToMyAccountPresenterProtocol {
    func providerStatusUpdate(id: Int, param: Parameters) {
        myAccountInterector?.providerStatusUpdate(id: id, param: param)
    }
    var myAccountView: MyAccountPresenterToMyAccountViewProtocol?
    var myAccountInterector: MyAccountPresenterToMyAccountInteractorProtocol?
    var myAccountRouter: MyAccountPresenterToMyAccountRouterProtocol?
    
    //Get profile detail
    func getProfileDetail() {
        myAccountInterector?.getProfileDetail()
    }
    
    //update profile detail
    func updateProfileDetail(param: Parameters,imageData:  [String:Data]?) {
        myAccountInterector?.updateProfileDetail(param: param, imageData: imageData)
    }
    
    //Get country name list
    func countryListDetail(param: Parameters) {
        myAccountInterector?.countryListDetail(param: param)
    }
    
    //ChangePassword
    func changePassword(param: Parameters) {
        myAccountInterector?.changePassword(param: param)
    }
    
    func resetPasswordDetail(param: Parameters) {
        myAccountInterector?.resetPasswordDetail(param: param)
    }

    func addDocumentDetail(param: Parameters, uploadData: [String : Data]?, isTypePDF: Bool) {
        myAccountInterector?.addDocumentDetail(param: param, uploadData: uploadData, isTypePDF: isTypePDF)
    }
  
    //AddCard
    func addCard(param: Parameters) {
        myAccountInterector?.addCard(param: param)
    }
    
    //GetCard
    func getCard() {
        myAccountInterector?.getCard()
    }
    
    //delete card
    func deleteCard(cardID: Int) {
        myAccountInterector?.deleteCard(cardID: cardID)
    }
    
    //wallet
    func addMoneyToWallet(param: Parameters) {
        myAccountInterector?.addMoneyToWallet(param: param)
    }
    
    func getServiceDetail() {
        myAccountInterector?.getServiceDetail()
    }
    
    func getAdminServiceDetail() {
        myAccountInterector?.getAdminServiceDetail()
    }
    
    func getRideTypeDetail() {
        myAccountInterector?.getRideTypeDetail()
    }
    func AddVehicleDetail(param: Parameters,imageData:  [String:Data]?)  {
        myAccountInterector?.AddVehicleDetail(param: param, imageData: imageData)
    }
    
    func EditVehicleDetail(param: Parameters, imageData: [String : Data]?) {
        myAccountInterector?.EditVehicleDetail(param: param, imageData: imageData)
    }
    
    func EarningDetail(providerId: String) {
        myAccountInterector?.EarningDetail(providerId: providerId)
    }
    
    func getCategoryDetail() {
        myAccountInterector?.getCategoryDetail()
    }
    
    func getSubCategoryDetail(param: Parameters) {
        myAccountInterector?.getSubCategoryDetail(param: param)
    }
    
    func getShopTypeDetail() {
        myAccountInterector?.getShopTypeDetail()
    }
    
    func getXuberServiceDetail(param: Parameters) {
        myAccountInterector?.getXuberServiceDetail(param: param)
    }
    
    func getLogoutDetail() {
        myAccountInterector?.getLogoutDetail()
    }
    
    func updateLanguageDetail(param: Parameters) {
        myAccountInterector?.updateLanguageDetail(param: param)
    }
    
    func getTransactionList(param: Parameters,ishideLoader: Bool) {
        myAccountInterector?.getTransactionList(param: param,ishideLoader: ishideLoader)
    }
    
    func getBankTemplateList(){
        myAccountInterector?.getBankTemplateList()
    }
    
    func editBankDetailList(param: Parameters){
        myAccountInterector?.editBankDetailList(param: param)
    }
    
    func addBankDetailList(param: Parameters){
        myAccountInterector?.addBankDetailList(param: param)
    }
    
    func postAppSettings(param: Parameters) {
        myAccountInterector?.postAppSettings(param: param)
    }
    
    func sendOtp(param: Parameters){
        myAccountInterector?.sendOtp(param: param)
    }
    
    func verifyOtp(param: Parameters){
        myAccountInterector?.verifyOtp(param: param)
    }
    
    func qrCodeWalletTransfer(param: Parameters) {
        myAccountInterector?.qrCodeWalletTransfer(param: param)
    }
    
    func getDeliveryTypeDetail()
    {
        myAccountInterector?.getDeliveryTypeDetail()
       
    }
    
    
}

//MARK: - MyAccountInteractorToMyAccountPresenterProtocol

extension MyAccountPresenter: MyAccountInteractorToMyAccountPresenterProtocol {
    func providerStatusUpdate(profileEntity: ProfileEntity) {
        myAccountView?.providerStatusUpdate(profileEntity: profileEntity)
    }
    
    func getDeliveryTypeSuccess(getCourierTypeEntity: CourierTypeEntity) {
        
        myAccountView?.getDeliveryTypeSuccess(getCourierTypeEntity: getCourierTypeEntity)
        
    }
    
    func getEarningsSuccess(earningEntity: EarningEntity) {
        myAccountView?.getEarningsSuccess(earningEntity: earningEntity)
    }
    
    func getEditVehicleSuccess(editVehicleEntity: AddVehicleEntity) {
        myAccountView?.getEditVehicleSuccess(editVehicleEntity: editVehicleEntity)
    }
    
    func getBankTemplateList(bankTemplateEntity: BankTemplateEntity) {
        myAccountView?.getBankTemplateList(bankTemplateEntity: bankTemplateEntity)
        
    }
    
    func editBankDetailList(editBankEntity: LogoutEntity) {
        myAccountView?.editBankDetailList(editBankEntity: editBankEntity)
    }
    
    func addBankDetailList(addBankEntity: LogoutEntity) {
        myAccountView?.addBankDetailList(addBankEntity: addBankEntity)
    }
    
    func updateLanguageServiceSuccess(updateLanguageEntity: LogoutEntity) {
        myAccountView?.updateLanguageServiceSuccess(updateLanguageEntity: updateLanguageEntity)
    }
    
    func getLogoutServiceSuccess(getLogoutServiceEntity: LogoutEntity) {
        myAccountView?.getLogoutServiceSuccess(getLogoutServiceEntity: getLogoutServiceEntity)
    }
    
    func getXuberServiceSuccess(getXuberServiceEntity: GetXuberServiceEntity) {
        myAccountView?.getXuberServiceSuccess(getXuberServiceEntity: getXuberServiceEntity)
    }
    
    func getShopTypeSuccess(getShopTypeEntity: ShopTypeEntity) {
        myAccountView?.getShopTypeSuccess(getShopTypeEntity: getShopTypeEntity)
    }
    
    func getCategorySuccess(getCategoryEntity: GetCategoryEntity) {
        myAccountView?.getCategorySuccess(getCategoryEntity: getCategoryEntity)
    }
    
    func getSubCategorySuccess(getSubCategoryEntity: GetSubCategoryEntity) {
        myAccountView?.getSubCategorySuccess(getSubCategoryEntity: getSubCategoryEntity)
    }
    
    func getAddVehicleSuccess(getAddVehicleEntity: AddVehicleEntity) {
        myAccountView?.getAddVehicleSuccess(getAddVehicleEntity: getAddVehicleEntity)
    }
    func updateAddPdfDocumentSuccess(documentEntity: SuccessEntity){
        myAccountView?.updateAddPdfDocumentSuccess(documentEntity: documentEntity)
    }
    
    func getAdminServiceSuccess(getAdminServiceEntity: GetAdminServiceEntity) {
        myAccountView?.getAdminServiceSuccess(getAdminServiceEntity: getAdminServiceEntity)
    }
    
    func getRideTypeSuccess(getRideTypeEntity: GetRideTypeEntity) {
        myAccountView?.getRideTypeSuccess(getRideTypeEntity: getRideTypeEntity)
    }
    
    //Profile detail response
    func viewProfileDetail(profileEntity: ProfileEntity) {
        myAccountView?.viewProfileDetail(profileEntity: profileEntity)
    }
    
    //Update Profile detail response
    func updateProfileDetail(profileEntity: ProfileEntity) {
        myAccountView?.updateProfileDetail(profileEntity: profileEntity)
    }
    
    //Country name response
    func updateCountryListSuccess(countryEntity: CountryEntity) {
        myAccountView?.updateCountryListSuccess(countryEntity: countryEntity)
    }
    
    //Change password response
    func changePasswordResponse(profileEntity: ProfileEntity) {
        myAccountView?.changePasswordResponse(profileEntity: profileEntity)
    }
    
    func updateResetPasswordSuccess(resetPasswordEntity: ResetPasswordEntity) {
        myAccountView?.updateResetPasswordSuccess(resetPasswordEntity: resetPasswordEntity)
    }
    
    func updateAddDocumentSuccess(documentEntity: SuccessEntity) {
        myAccountView?.updateAddDocumentSuccess(documentEntity: documentEntity)
    }
    
    //AddCardSuccess
    func addCardSuccess(addCardResponse: CardEntityResponse) {
        
        myAccountView?.addCardSuccess(addCardResponse: addCardResponse)
    }
    
    //getCardResponse
    func getCardResponse(getCardResponse: CardEntityResponse) {
        
        myAccountView?.getCardResponse(getCardResponse: getCardResponse)
    }
    
    //delete card
    func deleteCardSuccess(deleteCardResponse: CardEntityResponse) {
        
        myAccountView?.deleteCardSuccess(deleteCardResponse: deleteCardResponse)
    }
    
    //walletResponse
    func addMoneyToWalletSuccess(walletSuccessResponse: AddAmountEntity) {
        myAccountView?.addMoneyToWalletSuccess(walletSuccessResponse: walletSuccessResponse)
    }
    
    //get Service
    func getServiceSuccess(getServiceEntity: GetServiceEntity) {
        myAccountView?.getServiceSuccess(getServiceEntity: getServiceEntity)
    }
    
    func getTransactionList(transactionEntity: TransactionEntity) {
        myAccountView?.getTransactionList(transactionEntity: transactionEntity)
    }
    
    func postAppSettingsResponse(baseEntity: BaseEntity) {
        myAccountView?.postAppSettingsResponse(baseEntity: baseEntity)
    }
    
    func sendOtpSuccess(sendOtpEntity: sendOtpEntity) {
        myAccountView?.sendOtpSuccess(sendOtpEntity: sendOtpEntity)
    }
    
    func verifyOtpSuccess(verifyOtpEntity: VerifyOtpEntity) {
        myAccountView?.verifyOtpSuccess(verifyOtpEntity: verifyOtpEntity)
    }
    
    func qrCodeWalletTransferSuccess(successEntity: SuccessEntity) {
        myAccountView?.qrCodeWalletTransferSuccess(successEntity: successEntity)
    }
}
