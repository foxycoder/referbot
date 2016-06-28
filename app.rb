require 'sinatra'
require 'httparty'
require 'json'

post '/refbot' do
  input = params[:text].to_s.split(' ')
  case input[0].downcase
  when 'hello'
    priv_postback "Hello " + params[:user_name], params[:channel_id], params[:user_name]
    break
  when 'list'
    getlist
    break
  when '1'
    userinput = 1
    postback userinput, params[:channel_id], params[:user_name]
    break
  when '2'
    postback userinput, params[:channel_id], params[:user_name]
    userinput = 2
    # postback userinput, params[:channel_id], params[:user_name]
    break
  end
  status 200
end

def getlist
  receivelist = HTTParty.get('https://api.recruitee.com/c/levelupventures/careers/offers').to_json

  test1 = JSON.parse(receivelist, symbolize_names: true)
  contents = test1[:offers]

  contents.each do |content|
    postback content[:title], params[:channel_id], params[:user_name]
  end
end


# def write_json
#   jsoncontent = {"text" => "refbot response", "username" => "refbot", "channel" => params[:channel_id]}
#   newjson = JSON.pretty_generate(jsoncontent)
#   File.open("userdata.json","w") do |f|
#     f.write(newjson)
#   end
#   newjson
# end


def postback message, channel, user
    slack_webhook = ENV['SLACK_WEBHOOK_URL']
    HTTParty.post slack_webhook, body: {"text" => message, "username" => "refbot", "channel" => params[:channel_id]}.to_json, headers: {'content-type' => 'application/json'}
end

def priv_postback message, channel, user
    slack_webhook = ENV['SLACK_WEBHOOK_URL']
    HTTParty.post slack_webhook, body: {"text" => message, "username" => "refbot", "channel" => params[:channel_id] }.to_json, headers: {'content-type' => 'application/json'}
end
