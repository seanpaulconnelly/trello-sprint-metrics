namespace :trello do
  task get_board_info: :environment do
    json = call_trello("boards/#{trello_board}", "fields=id,name,idOrganization,dateLastActivity&lists=open&list_fields=id")
    puts json
  end

  def call_trello(path, params)
    response = RestClient.get "https://api.trello.com/1/#{path}?key=#{trello_key}&token=#{trello_token}&#{params}"
    JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
     Rails.logger.error "!!!!!!!!! ERROR CALLING TRELLO: #{e}; #{e.response}, path: #{path}, params: #{params}"
  end

  def trello_key
    ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
  end

  def trello_token
    ENV['TRELLO_MEMBER_TOKEN']
  end

  def trello_board
    ENV['TRELLO_IN_PROGRESS_BOARD_ID']
  end
end
