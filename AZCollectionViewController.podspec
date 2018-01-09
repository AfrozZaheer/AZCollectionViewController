
Pod::Spec.new do |s|


  s.name         = "AZCollectionViewController"
  s.version      = "0.1.1"
  s.summary      = "Automatic pagination handling and loading views"

  s.description  = <<-DESC
        Automatic pagination handling
        No more awkward empty CollectionView. can make Instagram like Discover within minutes.
    DESC

  s.homepage     = "https://github.com/AfrozZaheer/AZCollectionViewController"

  s.platform         = :ios, "9.3"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }


  s.author       = { "AfrozZaheer" => "afrozezaheer@gmail.com" }

  s.source       = { :git => "https://github.com/AfrozZaheer/AZCollectionViewController.git" }

  s.resource_bundles = {
     'AZCollectionViewElements' => ['Source/**/*.{xib}']
  }

 
  s.source_files = 'Source/**/*.{swift}'

end
