require_relative 'modules/user_iface'
require_relative 'modules/yass_tcp'
require 'socket'

Thread.fork do 
  my_server = YassTcpClient.new
end

client_iface = ClientIface.new