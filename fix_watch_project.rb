require 'xcodeproj'
project_path = 'ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

runner_target = project.targets.find { |t| t.name == 'Runner' }
watch_target = project.targets.find { |t| t.name == 'NeverSkipWatch Watch App' }

if runner_target && watch_target
  unless runner_target.dependencies.any? { |dep| dep.target == watch_target }
    runner_target.add_dependency(watch_target)
    puts "Added Target Dependency"
  end

  embed_phase = runner_target.build_phases.find { |bp| bp.respond_to?(:name) && bp.name == 'Embed Watch Content' }
  if embed_phase
    unless embed_phase.files_references.include?(watch_target.product_reference)
      build_file = embed_phase.add_file_reference(watch_target.product_reference)
      build_file.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }
      puts "Added to Embed Watch Content"
    end
  end

  project.save
  puts "Project saved."
else
  puts "Targets not found."
end
