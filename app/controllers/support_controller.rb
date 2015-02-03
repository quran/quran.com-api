class SupportController < ApplicationController
  def zendesk
    Rails.logger.ap params[:support].to_json
    auth = {username: 'mmahalwy@gmail.com', password: 'qwer1234!@#$'}
    response = HTTParty.post(
      'https://quran.zendesk.com/api/v2/tickets.json', 
      body: {ticket: params[:support]}.to_json,
      basic_auth: auth, 
      headers: {
        'Content-Type' => 'application/json'
      }
    )
    render json: response
  end
end
