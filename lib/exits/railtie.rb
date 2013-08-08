require 'exits/action_controller/helpers'

module Exits
  class Railtie < ::Rails::Railtie
    initializer "exits.railties.initializer" do |app|
      ActiveSupport.on_load :action_controller do
        include Exits::ActionController::Helpers
      end
    end
  end
end
