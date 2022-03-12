require "spec_helper"

describe 'Ping API' , :type => :api do
  it "making a request without cookie token " do
    get "/api/v1/items/1",:format =>:json
    last_response.status.should eql(401)
    error = {:error=>'You need to sign in or sign up before continuing.'}
    last_response.body.should  eql(error.to_json)
  end
end
