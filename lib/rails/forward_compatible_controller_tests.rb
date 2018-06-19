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
        controller_test = self.class < ActionController::TestCase
        request_params = args[0]&.dup
        request_session = args[1]&.dup if controller_test
        request_headers = args[1]&.dup unless controller_test
        request_flash = args[2]&.dup if controller_test
        request_format = nil

        old_method = false
        xhr = false
        if request_params && request_params.is_a?(Hash)
          xhr = request_params.delete(:xhr)
          request_format = request_params.delete(:format)
          if request_params[:params].is_a?(Hash)
            request_params.merge!(request_params.delete(:params) || {})
            request_session = request_params.delete(:session) || request_session if controller_test
            request_headers = request_params.delete(:headers) || request_headers unless controller_test
            request_flash = request_params.delete(:flash) || request_flash if controller_test
          elsif request_params.key?(:headers) && !controller_test
            request_flash = nil
            request_session = nil
            request_headers = request_params[:headers]
            request_params = nil
          elsif request_params.key?(:session) && controller_test
            request_flash = request_params[:flash]
            request_session = request_params[:session]
            request_headers = nil
            request_params = nil
          elsif request_params.key?(:flash) && controller_test
            request_flash = request_params[:flash]
            request_session = nil
            request_headers = nil
            request_params = nil
          elsif !xhr && !request_format
            old_method = true
          end
        elsif request_headers.is_a?(Hash) || request_session.is_a?(Hash) ||
              request_flash.is_a?(Hash)
          old_method = true
        end

        raise Exception, ERROR_MESSAGE if ForwardCompatibleControllerTests.raise_exception? && old_method
        ActiveSupport::Deprecation.warn(ERROR_MESSAGE) if ForwardCompatibleControllerTests.deprecated? && old_method

        request_params[:format] = request_format if request_format

        if xhr
          ForwardCompatibleControllerTests.send(:with_ignore) do
            if controller_test
              return xhr(method, action, request_params, request_session, request_flash)
            else
              return xhr(method, action, request_params, request_headers)
            end
          end
        end
        if controller_test
          super(action, request_params, request_session, request_flash)
        else
          super(action, request_params, request_headers)
        end
      end
    end

    def xhr(request_method, action, parameters = nil, *args)
      raise Exception, ERROR_MESSAGE if ForwardCompatibleControllerTests.raise_exception?
      ActiveSupport::Deprecation.warn(ERROR_MESSAGE) if ForwardCompatibleControllerTests.deprecated?
      super(request_method, action, parameters, *args)
    end
  end
end

if ActionPack.gem_version < Gem::Version.new('5.0.0')
  ActionController::TestCase.prepend(Rails::ForwardCompatibleControllerTests)
  ActionDispatch::IntegrationTest.prepend(Rails::ForwardCompatibleControllerTests)
end
