require 'exits/rules/controller'
require 'exits/rules/user'

module Exits
  class Rules
    class Unauthorized < StandardError; end;

    def initialize
      @controllers = Hash.new
    end

    def add(controller_class, klass, *actions)
      @controllers[controller_class] ||= Exits::Rules::Controller.new
      @controllers[controller_class][klass] = actions.flatten
    end

    def authorized?(controller_class, klass, action)
      controller = @controllers.fetch(controller_class, {})
      return false if controller.nil?
      controller.authorized? klass, action
    end
  end
end
