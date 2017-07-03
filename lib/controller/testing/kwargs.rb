require "controller/testing/kwargs/version"
require "rails/test_help"

module Controller
  module Testing
    module Kwargs
      %i[get post patch put head delete].each do |method|
        define_method(method) do |action, *args|
          request_params = args[0]&.dup
          request_headers = args[1]&.dup
          if request_params && request_params.is_a?(Hash)
            xhr = request_params.delete(:xhr) || false
            if request_params[:params].is_a?(Hash)
              request_params.merge!(request_params.delete(:params) || {})
              request_headers = request_params.delete(:headers) || request_headers
            elsif request_params[:params]
              request_headers = request_params[:headers]
              request_params = request_params[:params]
            elsif request_params[:headers]
              request_headers = request_params[:headers]
              request_params = nil
            end
            return xhr(method, action, request_params, request_headers) if xhr
          end
          super(action, request_params, request_headers)
        end
      end
    end
  end
end

ActionController::TestCase.prepend(Controller::Testing::Kwargs)
ActionDispatch::IntegrationTest.prepend(Controller::Testing::Kwargs)
