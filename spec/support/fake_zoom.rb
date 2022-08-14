require 'sinatra/base'

class FakeZoom < Sinatra::Base
  post '/v2/meetings/:id/registrants' do
    json_response 200, 'registration.json'
  end

  post '/v2/meetings/:id/batch_registrants' do
    json_response 200, 'batch_registration.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open('spec/fixtures/' + file_name, 'rb').read
  end
end
