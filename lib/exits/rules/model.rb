module Exits
  class Rules
    class Model
      class Exits::Rules::ConfusingRulesError < StandardError; end;
      def initialize
        @actions = []
        @resources = [:index, :new, :show, :edit, :destroy, :update, :create].freeze
      end

      def allow(*actions)
        @actions = @actions | actions.flatten

        if @actions.size > 1 && @actions.include?(:all)
          raise Exits::Rules::ConfusingRulesError, "You have :all and specific actions within the same controller/model rule."
        end
      end

      def authorized?(action)
        return true if @actions.include?(:all)
        return true if @actions.include?(:resources) && @resources.include?(action)
        return @actions.include?(action)
      end
    end
  end
end

