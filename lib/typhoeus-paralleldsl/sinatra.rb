require 'sinatra'
module Sinatra
  module ParallelDSLHelper
    def parallel(&blk)
      ::Typhoeus::ParallelDSL.parallel(&blk)
    end
  end
  register ParallelDSLHelper
end
