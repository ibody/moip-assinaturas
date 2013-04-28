# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :notification => true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/moip-assinaturas/(.+)\.rb$})     { |m| "spec/moip-assinaturas/#{m[1]}_spec.rb" }
  watch('lib/moip-assinaturas/client.rb')  { "spec" }
  watch('spec/spec_helper.rb')  { "spec" }
end

