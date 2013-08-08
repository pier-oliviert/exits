require 'active_support'

module Exits
  module ActionController
    module Helpers
      extend ActiveSupport::Concern

      included do
        rescue_from Exits::Rules::Unauthorized do |exception|
          unauthorized exception
        end
      end

      module ClassMethods

        def allow(kls, *actions)
          rules.add self, kls, actions
        end

        def rules
          @rules ||= ::Exits::Rules.new
        end

      end

      def restrict_routes!
        unless self.class.rules.authorized?(self.class, current_user.class, action_name)
          restricted!
        end
      end

      protected

      def unauthorized(exception)
        flash.alert = t("exits.unauthorized")
        redirect_to :root
      end

      def allow!(kls, &block)
        return unless current_user.instance_of?(kls)
        unless yield
          restricted!
        end
      end

      def restricted!
        raise Exits::Rules::Unauthorized
      end

    end
  end
end
