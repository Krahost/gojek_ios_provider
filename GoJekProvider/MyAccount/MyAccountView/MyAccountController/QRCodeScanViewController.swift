//
//  QRCodeScanViewController.swift
//  GoJekProvider
//
//  Created by AppleMac on 27/02/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class QRCodeScanViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var payStackChargeView: PayStackView?
    var qrCodeFrameView: UIView?
    var amountStr: String?
    var isQRWallet: Bool = true
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationTitle()
        self.title = MyAccountConstant.scanQRCode.localized
        self.setLeftBarButtonWith(color: .blackColor)
        self.showAmountEnterView()
        self.view.backgroundColor = .backgroundColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let connection =  self.videoPreviewLayer?.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection
            if previewLayerConnection.isVideoOrientationSupported {
                
                switch (orientation) {
                case .portrait: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                    break
                case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                    break
                case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                    break
                case .portraitUpsideDown: updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                    break
                default: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                    break
                }
            }
        }
    }
}

extension QRCodeScanViewController {
    
    func showAmountEnterView() {
        
        if self.payStackChargeView == nil, let payStackChargeView = Bundle.main.loadNibNamed(MyAccountConstant.payStackView, owner: self, options: [:])?.first as? PayStackView {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            payStackChargeView.frame = CGRect(x: 0, y: 0, width: window!.frame.width, height: window!.frame.height)
            self.payStackChargeView = payStackChargeView
            self.view.addTransparent(with: payStackChargeView)
            payStackChargeView.show(with: .bottom, completion: nil)
        }
        
        self.payStackChargeView?.onClickSubmit = { (walletAmtCharge) in
            self.payStackChargeView?.superview?.removeFromSuperview()
            self.payStackChargeView?.dismissView(onCompletion: {
                self.payStackChargeView = nil
                if walletAmtCharge != nil {
                    self.amountStr = walletAmtCharge
                    self.scannerSetup()
                }else {
                    self.payStackChargeView?.superview?.removeFromSuperview()
                    self.isQRWallet = false
                }
            })
        }
        
        self.payStackChargeView?.onClickCancel = { (tollCharge) in
            self.payStackChargeView?.superview?.removeFromSuperview()
            self.payStackChargeView?.dismissView(onCompletion: {
                self.payStackChargeView = nil
            })
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func scannerSetup() {
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            print(error)
            return
        }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.startRunning()
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }
   
    func qrCodeWalletTransferAction(qrCode: String) {
        if self.isQRWallet == true {
            self.isQRWallet = false
            let qrCodeDic = qrCode.toDictionary()
            let qrCodeIDStr = qrCodeDic["id"] as? String
            if let qrCodeId = qrCodeIDStr?.fromBase64() {
                let param: Parameters = [MyAccountConstant.amount: amountStr ?? 0,
                                         MyAccountConstant.PId: qrCodeId ]
                self.myAccountPresenter?.qrCodeWalletTransfer(param: param)
            }
        }
    }
}

//MARK:- AVCaptureMetadataOutputObjectsDelegate

extension QRCodeScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            if let metaUrl = metadataObj.stringValue  {
                qrCodeWalletTransferAction(qrCode: metaUrl)
            }
        }
    }
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        videoPreviewLayer?.frame = self.view.bounds
    }
}

//MARK:- MyAccountPresenterToMyAccountViewProtocol

extension QRCodeScanViewController: MyAccountPresenterToMyAccountViewProtocol {
    
    func qrCodeWalletTransferSuccess(successEntity: SuccessEntity) {
        self.isQRWallet = false
        self.simpleAlert(view: self, title: "", message: successEntity.message ?? "", state: .success)
        self.navigationController?.popViewController(animated: true)
    }
}

