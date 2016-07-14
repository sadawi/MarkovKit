Pod::Spec.new do |s|
    s.name             = "MarkovKit"
    s.version          = "1.0.0"
    s.summary          = "Tools for working with Markov models"
    s.homepage         = "https://github.com/sadawi/MarkovKit"
    s.license          = 'MIT'
    s.author           = { "Sam Williams" => "samuel.williams@gmail.com" }
    s.source           = { :git => "https://github.com/sadawi/MarkovKit.git", :tag => s.version.to_s }

    s.platform     = :ios, '10.0'
    s.requires_arc = true

    s.source_files = 'MarkovKit/**/*'
    s.resource_bundles = {
    'MarkovKit' => ['MarkovKit/*.png']
    }
end
