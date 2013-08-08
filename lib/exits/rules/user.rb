module Exits
  class Rules
    class User
      class Exits::Rules::ConfusingRulesError < StandardError; end;
      def initialize
        @actions = []
      end

      def allow(*actions)
        @actions = @actions | actions.flatten

        if @actions.size > 1 && @actions.include?(:all)
          raise Exits::Rules::ConfusingRulesError, "You have :all and specific actions within the same controller/user rule."
        end
      end

      def authorized?(action)
        return true if @actions.include?(:all)
        return @actions.include?(action)
      end
    end
  end
end

