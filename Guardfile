group :green_red_refactor, halt_on_fail: true do
  guard :rspec, cmd: 'rspec --format documentation --color' do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/.+\.rb$})       { "spec" }
    watch('spec/spec_helper.rb')  { "spec" }
  end

  guard :rubocop, cmd: "rubocop", cli: 'lib' do
  end
end
