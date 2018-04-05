require_relative 'modules/config'
require_relative 'modules/user_iface'
require_relative 'modules/yass_tcp'
require_relative 'modules/survey'
require 'socket'

$survey = Survey.new

Thread.fork do 
  my_server = YassTcpServer.new $survey  
end

server_iface = ServerIface.new $survey