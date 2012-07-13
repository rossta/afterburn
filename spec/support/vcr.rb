require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir  = "#{File.dirname(File.expand_path(__FILE__))}/../vcr"
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :fakeweb
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.around(:each, :vcr) do |example|
    name = example.metadata.slice(:cassette)[:cassette]
    unless name
      namespace = example.metadata[:full_description].split.first.underscore
      spec_name = example.metadata[:description].split.join("_")
      name = [namespace, spec_name].join("/")
    end
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, options) { example.call }
  end
end
