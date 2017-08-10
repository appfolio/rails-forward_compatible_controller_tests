require "rails/forward_compatible_controller_tests/version"
require "rails/test_help"

module Rails
  module ForwardCompatibleControllerTests
    ERROR_MESSAGE = 'Please use Rails 5 syntax. See: https://github.com/appfolio/rails-forward_compatible_controller_tests'

    class <<self
      @old_syntax_strategy = :deprecation_warning

      attr_reader :old_syntax_strategy

      def deprecate
        @old_syntax_strategy = :deprecation_warning
      end

      def deprecated?
        @old_syntax_strategy == :deprecation_warning
      end

      def ignore
        @old_syntax_strategy = nil
      end

      def raise_exception
        @old_syntax_strategy = :raise_exception
      end

      def raise_exception?
        @old_syntax_strategy == :raise_exception
      end

      private

      def with_ignore
        previous_strategy = @old_syntax_strategy
        @old_syntax_strategy = nil
        begin
          yield
        ensure
          @old_syntax_strategy = previous_strategy
        end
      end
    end

    %i[get post patch put head delete].each do |method|
      define_method(method) do |action, *args|
        request_params = args[0]&.dup
        request_headers = args[1]&.dup

        old_method = false
        xhr = false
        if request_params && request_params.is_a?(Hash)
          xhr = request_params.delete(:xhr)
          if request_params[:params].is_a?(Hash)
            request_params.merge!(request_params.delete(:params) || {})
            request_headers = request_params.delete(:headers) || request_headers
          elsif request_params.key?(:params)
            request_headers = request_params[:headers]
            request_params = request_params[:params]
          elsif request_params.key?(:headers)
            request_headers = request_params[:headers]
            request_params = nil
          elsif !xhr
            old_method = true
          end
        elsif request_headers.is_a?(Hash)
          old_method = true
        end

        raise Exception, ERROR_MESSAGE if ForwardCompatibleControllerTests.raise_exception? && old_method
        ActiveSupport::Deprecation.warn(ERROR_MESSAGE) if ForwardCompatibleControllerTests.deprecated? && old_method

        ForwardCompatibleControllerTests.send(:with_ignore) do
          return xhr(method, action, request_params, request_headers)
        end if xhr
        super(action, request_params, request_headers)
      end
    end

    def xhr(request_method, action, parameters = nil, *args)
      raise Exception, ERROR_MESSAGE if ForwardCompatibleControllerTests.raise_exception?
      ActiveSupport::Deprecation.warn(ERROR_MESSAGE) if ForwardCompatibleControllerTests.deprecated?
      super(request_method, action, parameters, *args)
    end
  end
end

ActionController::TestCase.prepend(Rails::ForwardCompatibleControllerTests)
ActionDispatch::IntegrationTest.prepend(Rails::ForwardCompatibleControllerTests)
