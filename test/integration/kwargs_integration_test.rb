require 'test_helper'

class DummyIntegrationTestClass; end

test_class = if ActionPack.gem_version < Gem::Version.new('5.0.0')
               ActionDispatch::IntegrationTest
             else
               DummyIntegrationTestClass
             end

class KwargsIntegrationTest < test_class
  def setup
    Rails::ForwardCompatibleControllerTests.raise_exception
  end

  %w[get post patch put head delete].each do |verb|
    define_method("test_#{verb}_old_params_only") do
      Rails::ForwardCompatibleControllerTests.ignore

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

    define_method("test_#{verb}_old_params_only__raises_exception") do
      assert_raise Exception do
        send(verb.to_sym, '/kwargs/test_kwargs', hello: 'world')
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

    define_method("test_#{verb}_new_string_params_only") do
      send(verb.to_sym, '/kwargs/test_kwargs', params: "string_params")
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal({ 'string_params' => nil }, response['params'])
        assert_nil response['hello_header']
        refute response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_#{verb}_new_blank_headers_only") do
      send(verb.to_sym, '/kwargs/test_kwargs', headers: nil)
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal({}, response['params'])
        assert_nil response['hello_header']
        refute response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_xhr_#{verb}_new_no_params_or_headers") do
      send(verb.to_sym, '/kwargs/test_kwargs', xhr: true)
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal({}, response['params'])
        assert_nil response['hello_header']
        assert response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_xhr_#{verb}_old_params_only") do
      Rails::ForwardCompatibleControllerTests.ignore

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

    define_method("test_xhr_#{verb}_old_params_only__raises_exception") do
      assert_raise Exception do
        xhr verb.to_sym, '/kwargs/test_kwargs', hello: 'world'
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
      Rails::ForwardCompatibleControllerTests.ignore

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

    define_method("test_#{verb}_old_headers_only__raises_exception") do
      assert_raise Exception do
        send(verb.to_sym, '/kwargs/test_kwargs', nil, 'Hello': 'world')
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
      Rails::ForwardCompatibleControllerTests.ignore

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

    define_method("test_xhr_#{verb}_old_headers_only__raises_exception") do
      assert_raise Exception do
        xhr(verb.to_sym, '/kwargs/test_kwargs', nil, 'Hello': 'world')
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
      Rails::ForwardCompatibleControllerTests.ignore

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

    define_method("test_#{verb}_old_params_and_headers__raises_exception") do
      assert_raise Exception do
        send(verb.to_sym, '/kwargs/test_kwargs', { hello: 'world' }, { 'Hello': 'world' })
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
      Rails::ForwardCompatibleControllerTests.ignore

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

    define_method("test_xhr_#{verb}_old_params_and_headers__outputs_deprecation") do
      Rails::ForwardCompatibleControllerTests.deprecate

      assert_deprecated do
        xhr verb.to_sym, '/kwargs/test_kwargs', { hello: 'world' }, { 'Hello': 'world' }
      end
      if @response.body.size > 0
        response = JSON.parse(@response.body)
        assert_equal({ 'hello' => 'world' }, response['params'])
        assert_equal('world', response['hello_header'])
        assert response['xhr']
      else
        assert_equal 'head', verb
      end
    end

    define_method("test_xhr_#{verb}_old_params_and_headers__raises_exception") do
      assert_raise Exception do
        xhr verb.to_sym, '/kwargs/test_kwargs', { hello: 'world' }, { 'Hello': 'world' }
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
