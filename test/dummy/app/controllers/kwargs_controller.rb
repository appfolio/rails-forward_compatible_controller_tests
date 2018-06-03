class KwargsController < ActionController::Base
  def test_kwargs
    @params = params.to_unsafe_h.except('controller', 'action')
    @xhr = request.xhr?
    @hello_header = request.headers['HTTP_HELLO']
    @flash = flash['flashy']
    @session = session[:sesh]
    render json: { params: @params,
                   xhr: @xhr,
                   hello_header: @hello_header,
                   session: @session,
                   flash: @flash }
  end
end
