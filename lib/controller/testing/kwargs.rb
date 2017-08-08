require "controller/testing/kwargs/version"
require "rails/test_help"

module Controller
  module Testing
    module Kwargs
      ERROR_MESSAGE = 'Please use Rails 5 syntax. See: https://github.com/appfolio/controller-testing-kwargs'

      class <<self
        @on_old = :ignore

        attr_reader :on_old

        def ignore
          @on_old = :ignore
        end

        def raise_exception
          @on_old = :raise
        end

        def raise_exception?
          @on_old == :raise
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
            elsif request_params[:params]
              request_headers = request_params[:headers]
              request_params = request_params[:params]
            elsif request_params[:headers]
              request_headers = request_params[:headers]
              request_params = nil
            else
              old_method = true
            end
          elsif request_headers.is_a?(Hash)
            old_method = true
          end

          raise Exception, ERROR_MESSAGE if Controller::Testing::Kwargs.raise_exception? && old_method

          if xhr
            previous_value = Controller::Testing::Kwargs.on_old
            Controller::Testing::Kwargs.ignore
            begin
              return xhr(method, action, request_params, request_headers)
            ensure
              Controller::Testing::Kwargs.instance_variable_set(:@on_old, previous_value)
            end
          end
          super(action, request_params, request_headers)
        end
      end
    end
  end
end

ActionController::TestCase.prepend(Controller::Testing::Kwargs)
ActionDispatch::IntegrationTest.prepend(Controller::Testing::Kwargs)
