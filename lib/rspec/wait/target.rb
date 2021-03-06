module RSpec
  module Wait
    class Target < RSpec::Expectations::ExpectationTarget
      # From: https://github.com/rspec/rspec-expectations/blob/v3.0.0/lib/rspec/expectations/expectation_target.rb#L22
      UndefinedValue = Module.new

      # From: https://github.com/rspec/rspec-expectations/blob/v3.0.0/lib/rspec/expectations/expectation_target.rb#L30-L41
      # rubocop:disable Metrics/MethodLength
      def self.for(value, block, options = {})
        if UndefinedValue.equal?(value)
          unless block
            raise ArgumentError, "You must pass either an argument or a block to `wait_for`." # rubocop:disable Metrics/LineLength
          end
          new(block, options)
        elsif block
          raise ArgumentError, "You cannot pass both an argument and a block to `wait_for`." # rubocop:disable Metrics/LineLength
        else
          warn "[DEPRECATION] As of rspec-wait version 1.0, neither wait_for nor wait.for will accept an argument, only a block." # rubocop:disable Metrics/LineLength
          new(value, options)
        end
      end
      # rubocop:enable Metrics/MethodLength

      # From: https://github.com/rspec/rspec-expectations/blob/v3.0.0/lib/rspec/expectations/expectation_target.rb#L25-L27
      def initialize(target, options)
        @wait_options = options
        super(target)
      end

      # From: https://github.com/rspec/rspec-expectations/blob/v3.0.0/lib/rspec/expectations/expectation_target.rb#L53-L54
      def to(matcher = nil, message = nil, &block)
        prevent_operator_matchers(:to) unless matcher
        with_wait do
          PositiveHandler.handle_matcher(@target, matcher, message, &block)
        end
      end

      # From: https://github.com/rspec/rspec-expectations/blob/v3.0.0/lib/rspec/expectations/expectation_target.rb#L66-L67
      def not_to(matcher = nil, message = nil, &block)
        prevent_operator_matchers(:not_to) unless matcher
        with_wait do
          NegativeHandler.handle_matcher(@target, matcher, message, &block)
        end
      end

      alias to_not not_to

      private

      def with_wait
        Wait.with_wait(@wait_options) { yield }
      end
    end
  end
end
