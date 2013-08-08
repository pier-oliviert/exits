module Exits
  class Rules
    class Controller
      def initialize
        @users = {}
      end

      def []=(user_class, actions)
        @users[user_class] ||= Exits::Rules::User.new
        @users[user_class].allow actions
      end

      def [](user_class)
        @users[user_class]
      end

      def authorized?(klass, action)
        user = self[klass]
        return false if user.nil?
        user.authorized? action
      end
    end
  end
end
