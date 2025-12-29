require 'xcodeproj'
require 'rexml/document'

if ARGV.length != 2
  puts 'We need exactly two arguments'
  exit
end

project_path = ARGV[0]
scheme_name = ARGV[1]

project = Xcodeproj::Project.open(project_path)
target = project.targets.first

# Try to read existing scheme to preserve custom attributes
scheme_path = File.join(project_path, 'xcshareddata', 'xcschemes', "#{scheme_name}.xcscheme")
existing_custom_attrs = {}

if File.exist?(scheme_path)
  begin
    doc = REXML::Document.new(File.read(scheme_path))
    
    # Preserve custom attributes from LaunchAction
    launch_action = doc.elements['Scheme/LaunchAction']
    if launch_action
      existing_custom_attrs[:launch] = {}
      launch_action.attributes.each do |key, value|
        # Preserve custom attributes (not the standard ones we'll set)
        unless ['buildConfiguration', 'selectedDebuggerIdentifier', 'selectedLauncherIdentifier', 
                'launchStyle', 'useCustomWorkingDirectory', 'ignoresPersistentStateOnLaunch',
                'debugDocumentVersioning', 'debugServiceExtension', 'allowLocationSimulation'].include?(key)
          existing_custom_attrs[:launch][key] = value
        end
      end
    end
    
    # Preserve custom attributes from TestAction
    test_action = doc.elements['Scheme/TestAction']
    if test_action
      existing_custom_attrs[:test] = {}
      test_action.attributes.each do |key, value|
        unless ['buildConfiguration', 'selectedDebuggerIdentifier', 'selectedLauncherIdentifier',
                'shouldUseLaunchSchemeArgsEnv'].include?(key)
          existing_custom_attrs[:test][key] = value
        end
      end
    end
  rescue => e
    puts "Warning: Could not parse existing scheme file: #{e.message}"
  end
end

# Create new scheme with flavor-specific configurations
scheme = Xcodeproj::XCScheme.new
scheme.launch_action.build_configuration = "Debug-#{scheme_name}"
scheme.set_launch_target(target)
scheme.test_action.build_configuration = "Debug-#{scheme_name}"
scheme.profile_action.build_configuration = "Profile-#{scheme_name}"
scheme.analyze_action.build_configuration = "Debug-#{scheme_name}"
scheme.archive_action.build_configuration = "Release-#{scheme_name}"
scheme.save_as(project_path, scheme_name)

# Now merge back the preserved custom attributes
if existing_custom_attrs.any?
  begin
    doc = REXML::Document.new(File.read(scheme_path))
    
    # Restore LaunchAction custom attributes
    if existing_custom_attrs[:launch]&.any?
      launch_action = doc.elements['Scheme/LaunchAction']
      if launch_action
        existing_custom_attrs[:launch].each do |key, value|
          launch_action.attributes[key] = value
        end
      end
    end
    
    # Restore TestAction custom attributes
    if existing_custom_attrs[:test]&.any?
      test_action = doc.elements['Scheme/TestAction']
      if test_action
        existing_custom_attrs[:test].each do |key, value|
          test_action.attributes[key] = value
        end
      end
    end
    
    # Write back the modified scheme
    File.open(scheme_path, 'w') do |file|
      formatter = REXML::Formatters::Pretty.new(2)
      formatter.compact = true
      formatter.write(doc, file)
    end
  rescue => e
    puts "Warning: Could not restore custom attributes: #{e.message}"
  end
end
