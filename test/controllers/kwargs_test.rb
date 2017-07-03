require 'test_helper'

class KwargsControllerTest < ActionController::TestCase
  %w[get post patch put head delete].each do |verb|
    define_method("test_#{verb}_old_params_only") do
      send(verb.to_sym, :test_kwargs, hello: 'world')
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_nil assigns(:hello_header)
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_new_params_only") do
      send(verb.to_sym, :test_kwargs, params: { hello: 'world' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_nil assigns(:hello_header)
      refute assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_only") do
      xhr verb.to_sym, :test_kwargs, hello: 'world'
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_new_params_only") do
      send(verb.to_sym, :test_kwargs, xhr: true, params: { hello: 'world' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_nil assigns(:hello_header)
      assert assigns(:xhr)
    end

    define_method("test_#{verb}_old_headers_only") do
      send(verb.to_sym, :test_kwargs, nil, 'Hello': 'world')
      assert_equal('world', assigns(:hello_header))
      assert_equal({}, assigns(:params))
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_new_headers_only") do
      send(verb.to_sym, :test_kwargs, headers: { 'Hello': 'world' })
      assert_equal('world', assigns(:hello_header))
      assert_equal({}, assigns(:params))
      refute assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_headers_only") do
      xhr(verb.to_sym, :test_kwargs, nil, 'Hello': 'world')
      assert_equal('world', assigns(:hello_header))
      assert_equal({}, assigns(:params))
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_new_headers_only") do
      send(verb.to_sym, :test_kwargs, xhr: true, headers: { 'Hello': 'world' })
      assert_equal('world', assigns(:hello_header))
      assert_equal({}, assigns(:params))
      assert assigns(:xhr)
    end

    define_method("test_#{verb}_old_params_and_headers") do
      send(verb.to_sym, :test_kwargs, { hello: 'world' }, { 'Hello': 'world' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('world', assigns(:hello_header))
      refute assigns(:xhr)
    end

    define_method("test_#{verb}_new_params_and_headers") do
      send(verb.to_sym, :test_kwargs, params: { hello: 'world' }, headers: { 'Hello': 'world' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('world', assigns(:hello_header))
      refute assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_old_params_and_headers") do
      xhr verb.to_sym, :test_kwargs, { hello: 'world' }, { 'Hello': 'world' }
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('world', assigns(:hello_header))
      assert assigns(:xhr)
    end

    define_method("test_xhr_#{verb}_new_params_and_headers") do
      send(verb.to_sym, :test_kwargs, xhr: true, params: { hello: 'world' }, headers: { 'Hello': 'world' })
      assert_equal({ 'hello' => 'world' }, assigns(:params))
      assert_equal('world', assigns(:hello_header))
      assert assigns(:xhr)
    end
  end
end
