require 'cucumber/rest_api'
require 'rest-client'

require 'minke'
logger = Minke::Logging.create_logger(false)
discovery = Minke::Docker::ServiceDiscovery.new(
  ENV['DOCKER_PROJECT'],
  Minke::Docker::DockerRunner.new(logger),
  ENV['DOCKER_NETWORK']
)
$SERVER_PATH = "http://#{discovery.bridge_address_for 'configservice', '8090'}"

Before do |scenario|

end

After do |scenario|

end
