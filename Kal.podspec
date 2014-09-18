Pod::Spec.new do |s|
  s.name         = 'Kal'
  s.version      = '1.0.0'
  s.summary      = 'Calendar'
  s.author = {
    'Rory O\'Connor' => 'rory@ovuline.com'
  }
  s.source = {
    :git => 'https://github.com/ovuline /Kal.git',
    :tag => '1.0.0'
  }
  s.source_files = 'Source/*.{h,m}'
end
