Pod::Spec.new do |s|
  s.name             = 'Brotli'
  s.version          = '0.1.0'
  s.summary          = 'A Swift wrapper library for compressing and decompressing byte arrays.'

  s.homepage         = 'https://github.com/mvniekerk/libbrotli'
  s.license          = 'Apache version 2.0'
  s.author           = { 'Michael van Niekerk' => 'mike@agri-io.co.za' }
  s.source           = { :git => 'https://github.com/mvniekerk/libbrotli.git', :tag => "main" }

  s.swift_version    = '5'
  s.platform = :ios, '10'

  s.dependency 'CocoaLumberjack/Swift'

  s.source_files = [
    'swift/Sources/**/*.swift',
    'swift/Sources/**/*.m',
    # FIXME: We'd like to hide this from downstream clients at some point.
    # (Making this header accessible to both CocoaPods and SwiftPM is hard.)
    'swift/Sources/BrotliFfi/brotli_ffi.h'
  ]
  s.preserve_paths = [
    'bin/*',
    'Cargo.toml',
    'Cargo.lock',
    'ffi/*',
    'swift/*.sh',
  ]

  s.pod_target_xcconfig = {
      'CARGO_BUILD_TARGET_DIR' => '$(DERIVED_FILE_DIR)/libbrotli-ffi',
      'CARGO_PROFILE_RELEASE_DEBUG' => '1', # enable line tables
      'LIBBROTLI_FFI_DIR' => '$(CARGO_BUILD_TARGET_DIR)/$(CARGO_BUILD_TARGET)/release',

      'LIBBROTLI_FFI_LIB_IF_NEEDED' => '$(LIBBROTLI_FFI_DIR)/libbrotli_ffi.a',
      'OTHER_LDFLAGS' => '$(LIBBROTLI_FFI_LIB_IF_NEEDED)',

      # Some day this will have to be updated for arm64 Macs (and the corresponding arm64 iOS simulator)
      'CARGO_BUILD_TARGET[sdk=iphonesimulator*]' => 'x86_64-apple-ios',
      'CARGO_BUILD_TARGET[sdk=iphoneos*]' => 'aarch64-apple-ios',
      'CARGO_BUILD_TARGET[sdk=macosx*]' => 'x86_64-apple-darwin',
      'ARCHS[sdk=iphonesimulator*]' => 'x86_64',
      'ARCHS[sdk=iphoneos*]' => 'arm64',
  }

  s.script_phases = [
    { :name => 'Build libbrotli-ffi',
      :execution_position => :before_compile,
      :script => 'if [[ -n "${PRODUCT_TYPE}" ]]; then "${PODS_TARGET_SRCROOT}/swift/build_ffi.sh"; fi',
    }
  ]
end
