require "typhoeus-paralleldsl/version"

module Typhoeus
  class ParallelDSL
    def initialize
      @requests = []
      @hydra = Typhoeus::Hydra.new
    end

    def dsl(&blk)
      instance_eval &blk
      @hydra.run
      @requests.map(&:handled_response)
    end

    def head(url,options={})
      process(url,{method: :head }.merge(options))
    end

    def get(url,options={})
      process(url,{method: :get }.merge(options))
    end

    def post(url,body,options={})
      process(url,{method: :post, body: body }.merge(options))
    end

    def put(url,body,options={})
      process(url,{method: :post, body: body }.merge(options))
    end

    def delete(url,options={})
      process(url,{method: :delete }.merge(options))
    end

    def process(url,options={})
      request = Typhoeus::Request.new(url,options)
      request.on_complete do |response|
        response.body
      end
      @hydra.queue request
      @requests << request
    end

    def self.parallel(&blk)
      ParallelDSL.new.dsl(&blk)
    end
  end
end
