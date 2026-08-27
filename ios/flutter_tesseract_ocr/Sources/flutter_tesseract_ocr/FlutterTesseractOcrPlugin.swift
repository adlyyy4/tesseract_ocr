import Flutter
import UIKit
import SwiftyTesseract

public class FlutterTesseractOcrPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_tesseract_ocr", binaryMessenger: registrar.messenger())
        let instance = FlutterTesseractOcrPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        initializeTessData()
        if call.method == "extractText" {
            
            guard let args = call.arguments else {
                result("iOS could not recognize flutter arguments in method: (sendParams)")
                return
            }
            
            let params: [String : Any] = args as! [String : Any]
            let language: String? = params["language"] as? String
            let imagePath = params["imagePath"] as! String
            guard let image = UIImage(contentsOfFile: imagePath) else { return }
            
            DispatchQueue.global(qos: .userInitiated).async {
                // SwiftyTesseract 4.x is the only version published as a Swift package, and it renamed
                // the engine to `Tesseract` with a synchronous, `Result`-returning `performOCR`. There is
                // no 4.x pod, so the CocoaPods path stays on 3.1.3. CocoaPods defines COCOAPODS for us.
                #if COCOAPODS
                var swiftyTesseract = SwiftyTesseract(language: .english)
                if let language = language {
                    swiftyTesseract = SwiftyTesseract(language: .custom(language))
                }
                
                swiftyTesseract.performOCR(on: image) { recognizedString in
                    DispatchQueue.main.async {
                        guard let extractText = recognizedString else { return }
                        result(extractText)
                    }
                }
                #else
                let tesseract = language.map { Tesseract(language: .custom($0)) } ?? Tesseract(language: .english)
                
                switch tesseract.performOCR(on: image) {
                case .success(let extractText):
                    DispatchQueue.main.async {
                        result(extractText)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        result(FlutterError(code: "OCR_FAILED",
                                            message: error.localizedDescription,
                                            details: nil))
                    }
                }
                #endif
            }
        }
    }
    
    func initializeTessData() {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destURL = documentsURL!.appendingPathComponent("tessdata")
        
        let sourceURL = Bundle.main.bundleURL.appendingPathComponent("tessdata")
        
        let fileManager = FileManager.default
        do {
            try fileManager.createSymbolicLink(at: sourceURL, withDestinationURL: destURL)
        } catch {
            print(error)
        }
    }
}
