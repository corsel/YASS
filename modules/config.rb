require 'yaml'

$DEFAULT_CONFIG = 
{
  :deadline          => 0,
  :enforce_unique_ip => true,
  :global_token      => true,
  :token_on_request  => false
}

class Configuration
  attr_reader :config

  def initialize arg_file_name
    @config = $DEFAULT_CONFIG
    parsed = YAML.load_file arg_file_name
	
	parsed.each do |key, value|
	  @config[key.to_sym] = value
	end
  end 
end