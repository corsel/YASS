require_relative './survey'
require 'Base64'
require 'IO/console'

class BaseIface
  :state

  def initialize
      display_page 'splash'
      sleep 3
  end 

  def display_page arg_page_name, arg_prompt = false
    file_name = "data/" + arg_page_name + ".page"
    page_file = File.new file_name, "r"
    page_str = page_file.gets nil
    system 'cls'
    printf page_str
    response = ""
    if arg_prompt then
      printf "\n   # "
      response = gets
    end
    response
  end

  def bye_handler
    
  end
  
end 

class ServerIface < BaseIface
  :current_page
  attr_accessor :survey

  def initialize arg_survey
    @current_page = :server_main
    @survey = arg_survey
    super()
    while @current_page != :bye
      @current_page = send "#{@current_page}_handler".to_sym
    end
  end

  def bind_survey arg_survey
    @survey = arg_survey
  end

  def server_main_handler
    return_page = :server_main
    response = display_page 'server_main', true
    case response.strip
    when '1'
      return_page = :gen_token
    when '2'
      return_page = :get_info
    when '3'
      return_page = :peek_results
    when '4'
      return_page = :bye
    else
      printf "\n\n   Bad input.\n"
      sleep 1
    end
    return_page
  end

  def gen_token_handler
    system 'cls'
    printf "\n\n    Please select network interface:\n\n"
    iface_list = Array.new
    flag = false
    Socket.getifaddrs.each do |nw_iface|
      if nw_iface.addr != nil 
        if flag then
          iface_list.push nw_iface.addr.inspect_sockaddr
          printf " #{iface_list.length}) #{iface_list.last}\n"
        end
        flag = !flag
      end
    end
    printf " #{iface_list.length + 1}) Go back\n\n # "
    prompt = gets.to_i + 1
    if prompt > 0 and prompt <= iface_list.length then
      token = ""
      token += @survey.get_token.to_s + ":"
      token += iface_list[prompt - 2]
      printf "\n\n Debug - #{token}"
      printf "\n\n Your token is: " + (Base64.encode64 token)
      STDIN.getch
    elsif prompt.to_i != (iface_list.length + 1) then
      printf "\n\n   Bad input.\n"
      STDIN.getch
    end
    :server_main
  end

  def get_info_handler
    @survey.print_info
    STDIN.getch
    :server_main
  end

  def peek_results_handler
  end

end

class ClientIface < BaseIface
  def initialize
    super()
    display_page 'client_main', true
  end
end