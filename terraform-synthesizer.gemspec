# frozen_string_literal: true

lib = File.expand_path(%(lib), __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative %(./lib/terraform-synthesizer/version)

Gem::Specification.new do |spec|
  spec.name                  = %(terraform-synthesizer)
  spec.version               = TerraformSynthesizer::VERSION
  spec.authors               = [%(drzthslnt@gmail.com)]
  spec.email                 = [%(drzthslnt@gmail.com)]
  spec.description           = %(create terraform resources)
  spec.summary               = %(create terraform resources)
  spec.homepage              = %(https://github.com/drzln/#{spec.name})
  spec.license               = %(IPA)
  spec.files                 = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  spec.require_paths         = [%(lib)]
  spec.required_ruby_version = %(>= #{`cat .ruby-version`})

  %i[abstract-synthesizer].each do |gem|
    spec.add_runtime_dependency(gem)
  end

  spec.metadata[%(rubygems_mfa_required)] = %(true)
end
