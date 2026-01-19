# frozen_string_literal: true

module RuboCop
  module Committee
    module RequestMethod
      METHODS = %i[get post put patch delete head options].freeze

      def self.call?(send_node)
        send_node.receiver.nil? && METHODS.include?(send_node.method_name)
      end
    end
  end
end
