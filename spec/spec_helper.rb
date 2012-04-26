$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'placebo'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

  Placebo.name = ENV['PLACEBO_NAME']
  Placebo.token = ENV['PLACEBO_TOKEN']

  unless (Placebo.name and Placebo.token) then

    # TODO: vcr this.
    raise Exception 'We need a name & token to run integration tests'

  end

end
