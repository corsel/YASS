$TOKEN_MAX = 999
$SURVEY_ID_MAX = 9999999
$CONFIG_FILE = 'config/server.conf'

class Survey  
  attr_reader :id
  attr_reader :config
  attr_reader :expired_token_arr
  attr_reader :generated_token_arr
  attr_reader :choice_arr

  def initialize
    @random = Random.new
	@id = @random.rand $SURVEY_ID_MAX
	@config = Configuration.new $CONFIG_FILE
	@choice_arr = Array.new
	@generated_token_arr = Array.new
	@expired_token_arr = Array.new
    
    puts "\nSurvey id is " + id.to_s + "\n"	
  end
  
  def add_choice arg_choice
    if not @choice_arr.member? arg_choice then
      @choice_arr.push arg_choice
	  p choice_arr
	end
  end
  
  def get_token
    return_tok = 0
    if !@config.config[:global_token] then
      token = @random.rand $TOKEN_MAX
	  while @generated_token_arr.member? token or @expired_token_arr.member? token or token == 0
	    token = @random.rand $TOKEN_MAX
	  end
	  @generated_token_arr.push token
	  return_tok = token
	end
	return_tok
  end

  def print_info
    system 'cls'
    printf "\n\n             Survey info:\n\n\n   Survey id: #{@id}\n\n"
  end

end