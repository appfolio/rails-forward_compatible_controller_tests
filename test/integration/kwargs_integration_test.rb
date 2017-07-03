require 'test_helper'

class KwargsIntegrationTest < ActionDispatch::IntegrationTest
  %w[get post patch put head delete].each do |verb|
    define_method("test_#{verb}_old_params_only") do
      send(verb.to_sym, '/kwargs/test_kwargs', hello: 'world')
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal({ 'hello' => 'world' }, response['params'])
        assert_nil response['hello_header']
        refute response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_#{verb}_new_params_only") do
      send(verb.to_sym, '/kwargs/test_kwargs', params: { hello: 'world' })
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal({ 'hello' => 'world' }, response['params'])
        assert_nil response['hello_header']
        refute response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_xhr_#{verb}_old_params_only") do
      xhr verb.to_sym, '/kwargs/test_kwargs', hello: 'world'
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal({ 'hello' => 'world' }, response['params'])
        assert_nil response['hello_header']
        assert response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_xhr_#{verb}_new_params_only") do
      send(verb.to_sym, '/kwargs/test_kwargs', xhr: true, params: { hello: 'world' })
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal({ 'hello' => 'world' }, response['params'])
        assert_nil response['hello_header']
        assert response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_#{verb}_old_headers_only") do
      send(verb.to_sym, '/kwargs/test_kwargs', nil, 'Hello': 'world')
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal('world', response['hello_header'])
        assert_equal({}, response['params'])
        refute response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_#{verb}_new_headers_only") do
      send(verb.to_sym, '/kwargs/test_kwargs', headers: { 'Hello': 'world' })
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal('world', response['hello_header'])
        assert_equal({}, response['params'])
        refute response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_xhr_#{verb}_old_headers_only") do
      xhr(verb.to_sym, '/kwargs/test_kwargs', nil, 'Hello': 'world')
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal('world', response['hello_header'])
        assert_equal({}, response['params'])
        assert response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_xhr_#{verb}_new_headers_only") do
      send(verb.to_sym, '/kwargs/test_kwargs', xhr: true, headers: { 'Hello': 'world' })
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal('world', response['hello_header'])
        assert_equal({}, response['params'])
        assert response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_#{verb}_old_params_and_headers") do
      send(verb.to_sym, '/kwargs/test_kwargs', { hello: 'world' }, { 'Hello': 'world' })
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal({ 'hello' => 'world' }, response['params'])
        assert_equal('world', response['hello_header'])
        refute response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_#{verb}_new_params_and_headers") do
      send(verb.to_sym, '/kwargs/test_kwargs', params: { hello: 'world' }, headers: { 'Hello': 'world' })
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal({ 'hello' => 'world' }, response['params'])
        assert_equal('world', response['hello_header'])
        refute response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_xhr_#{verb}_old_params_and_headers") do
      xhr verb.to_sym, '/kwargs/test_kwargs', { hello: 'world' }, { 'Hello': 'world' }
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal({ 'hello' => 'world' }, response['params'])
        assert_equal('world', response['hello_header'])
        assert response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_xhr_#{verb}_new_params_and_headers") do
      send(verb.to_sym, '/kwargs/test_kwargs', xhr: true, params: { hello: 'world' }, headers: { 'Hello': 'world' })
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal({ 'hello' => 'world' }, response['params'])
        assert_equal('world', response['hello_header'])
        assert response['xhr']
      else
        assert_equal 'head', verb
      end
    end
  end
end
