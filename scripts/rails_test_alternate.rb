def in_spec file
  file =~ /^spec\//
end

def in_models file
  file =~ /\bmodels\b/
end

def in_controllers file
  file =~ /\bcontrollers\b/
end

def in_views file
  file =~ /\bviews\b/
end

def in_helpers file
  file =~ /\bhelpers\b/
end

current_file = ARGV.first

def in_rails_app file
  in_models(file) ||
  in_controllers(file) ||
  in_views(file) ||
  in_helpers(file)
end

def alternate current_file
  new_file = current_file
  if in_spec current_file
    new_file = current_file.gsub(/^spec\//,"").gsub(/_spec\.rb$/, ".rb")

    if in_rails_app current_file
      new_file = "app/#{new_file}"
    end
  else # in app
    if in_rails_app current_file
      new_file = current_file.gsub(/^app\//,"")
    end
    new_file = new_file.gsub(/\.rb$/, "_spec.rb")
    new_file = "spec/#{new_file}"
  end
  new_file
end

puts alternate current_file
