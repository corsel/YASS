class YassTcpServer
  :survey
  :socket
  :term_flag
  
  def initialize arg_survey, arg_port = 6000
    @term_flag = true
    @survey = arg_survey
    @socket = Socket.new :INET, :SOCK_STREAM
    @socket.bind Addrinfo.tcp "127.0.0.1", arg_port
    # TODO: socket fail check?
    @socket.listen 2

    while @term_flag
      conn, addr = @socket.accept
      conn_open = true
      while conn_open
        if conn_open then
          msg, addr = conn.gets "\0"
        end
        if msg == 'x' then
          puts "\nConnection from " + addr.inspect + " closed.\n"
          conn.close
          conn_open = false
        else
          # parse_msg msg
          puts "\nMessage received from " + addr.inspect + ": " + msg + "\n"
          msg = ''
        end
      end
    end 
  end

  def generate_ticket
    
  end

  def parse_msg arg_msg
    parsed_msg = YAML.load arg_msg
    p parsed_msg
  end

end

class YassTcpClient
  :socket 
  
  def initialize arg_ip = '127.0.0.1', arg_port = '6000'
    begin
      @socket = Socket.new :INET, :SOCK_STREAM
      @term_flag = true
      if (@socket.connect Addrinfo.tcp arg_ip, arg_port) == 0 then
        while @term_flag
          msg = gets
          if msg == 'x' then
            terminate
          else
            @socket.send msg, 0
          end
        end
      end
    rescue Errno::EPIPE
      abort "\nSocket closed by server.\n\n"
    rescue Errno::ECONNREFUSED
      abort "\nConnection could not be established with server.\n\n"
    end
  end
  
  def terminate
    @term_flag = false
    @socket.send 'x', 0
    @socket.close
    puts "\nClosing connection to server.\n\n"
  end

end