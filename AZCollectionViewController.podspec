
Pod::Spec.new do |s|


  s.name         = "AZCollectionViewController"
  s.version      = "0.1.0"
  s.summary      = "Automatic pagination handling and loading views"

  s.description  = <<-DESC
        Automatic pagination handling
        No more awkward empty CollectionView
    DESC

  s.homepage     = "https://github.com/AfrozZaheer/AZTableView"

  s.platform         = :ios, "9.3"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }


  s.author       = { "AfrozZ" => "afrozezaheer@gmail.com" }

  s.source       = { :git => "." }

  s.resource_bundles = {
     'AZCollectionViewElements' => ['Source/**/*.{xib}']
  }

 
  s.source_files = 'Source/**/*.{swift}'

end
