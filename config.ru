require 'rubygems'
require 'sinatra'
require 'sinatra/jsonp'
require 'typhoeus'
require 'json'

require './lib/typhoeus-paralleldsl'
require './lib/typhoeus-paralleldsl/sinatra'

class Test < Sinatra::Base
  helpers Sinatra::Jsonp
  get "/" do
    whois, ip = parallel do
      get('http://jsonifyit.herokuapp.com/whois/google.com')
      get('http://jsonifyit.herokuapp.com/ip')
    end

    JSONP({
      ip:    JSON.parse(ip)['ip'],
      whois: JSON.parse(whois)
    })
  end
end

run Test
