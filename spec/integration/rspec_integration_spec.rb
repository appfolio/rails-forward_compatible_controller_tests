require "rails_helper"

# Rspec tests are provided to ensure that the logic handling controller vs request specs
# works with rspec.
# We do this by testing the flash assigns, as this should only be present for controller tests.
# Also see spec/controllers

RSpec.describe KwargsController, type: :request do
  it "handles a rspec test marked as type 'request' as a rails request spec" do
    path = "/kwargs/test_kwargs"
    params = { params: "params" }
    headers = { headers: "session"}

    expect_any_instance_of(ActionDispatch::Integration::Runner).to receive(:get).with(path, params, headers)

    get path, params: params, headers: headers
  end
end