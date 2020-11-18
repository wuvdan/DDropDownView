
Pod::Spec.new do |s|
  s.name             = 'DDropDownView'
  s.version          = '0.1.0'
  s.summary          = 'A filter view from top.'
  s.description      = 'A filter view from top.'
  s.homepage         = 'https://github.com/wuvdan/DDropDownView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wuvdan' => 'wuvdan@163.com' }
  s.source           = { :git => 'https://github.com/wuvdan/DDropDownView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files = 'DDropDownView/Classes/**/*'
#  s.resource_bundles = {
#    'DDropDownView' => ['DDropDownView/Assets/*.png']
#  }
  s.resources     = "DDropDownView/DDropDownView.bundle"
end
