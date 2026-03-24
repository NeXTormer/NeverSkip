require 'xcodeproj'
project = Xcodeproj::Project.open('ios/Runner.xcodeproj')
project.targets.each do |target|
  target.source_build_phase.files.each do |file|
    if file.file_ref && file.file_ref.path =~ /ContentView/
      puts "#{target.name} compiles #{file.file_ref.path}"
    end
    if file.file_ref && file.file_ref.path =~ /WatchViewModel/
      puts "#{target.name} compiles #{file.file_ref.path}"
    end
  end
end
