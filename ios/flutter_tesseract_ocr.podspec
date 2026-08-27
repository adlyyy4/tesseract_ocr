#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_tesseract_ocr'
  s.version          = '0.4.31'
  s.summary          = 'Tesseract OCR 4 Flutter'
  s.description      = <<-DESC
Tesseract 4 adds a new neural net (LSTM) based OCR engine which is focused on line recognition. It has unicode (UTF-8) support, and can recognize more than 100 languages.
                       DESC
  s.homepage         = 'https://paratoner.io'
  s.license          = { :file => '../LICENSE',:type => 'BSD' }
  s.author           = { 'Ahmet Tok' => 'arny@paratoner.io' }
  s.source           = { :path => '.' }
  s.source_files = 'flutter_tesseract_ocr/Sources/flutter_tesseract_ocr/**/*.swift'
  s.dependency 'Flutter'
  # 4.x dropped CocoaPods support entirely, so the pod path is capped at the 3.x line.
  # The Swift package (see flutter_tesseract_ocr/Package.swift) uses 4.0.1 instead.
  s.dependency 'SwiftyTesseract', '~> 3.1'
  # Deliberately no s.platform: the pod must inherit the consuming Podfile's deployment
  # target. Pinning it lower builds this target below SwiftyTesseract (which does inherit),
  # and Swift then refuses to import a module built for a higher minimum.
  s.swift_version = '5.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  # s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
end

