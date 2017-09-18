require 'databranch'
require 'rails'
module Databranch
  class Railtie < Rails::Railtie
    railtie_name :databranch

    rake_tasks do
      load File.join(File.dirname(__FILE__),'../tasks/databranch.rake')
    end
  end
end
