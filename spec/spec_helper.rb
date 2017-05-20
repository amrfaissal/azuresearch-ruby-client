$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
Dir['azure_search/*.rb'].each { |file| require file }
