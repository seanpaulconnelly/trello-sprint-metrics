module TrelloHelper
  def self.call_trello(path, params)
    response = RestClient.get "https://api.trello.com/1/#{path}?key=#{trello_key}&token=#{trello_token}#{params}"
    Rails.logger.info "++++++++ CALLING TRELLO: path: #{path}, params: #{params}"
    JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
     Rails.logger.error "!!!!!!!! ERROR CALLING TRELLO: #{e}; #{e.response}, path: #{path}, params: #{params}"
  end

  def self.trello_key
    ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
  end

  def self.trello_token
    ENV['TRELLO_MEMBER_TOKEN']
  end

  def self.in_progress_board
    ENV['TRELLO_IN_PROGRESS_BOARD_ID']
  end

  def self.kanban_board
    ENV['TRELLO_INTEGRATIONS_KANBAN_ID']
  end
end
