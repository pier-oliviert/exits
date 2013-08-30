module Exits
  class Rules
    class Controller
      def initialize
        @models = {}
      end

      def []=(model_class, actions)
        @models[model_class] ||= Exits::Rules::Model.new
        @models[model_class].allow actions
      end

      def [](model_class)
        @models[model_class]
      end

      def authorized?(klass, action)
        model = self[klass]
        return false if model.nil?
        model.authorized? action
      end
    end
  end
end
