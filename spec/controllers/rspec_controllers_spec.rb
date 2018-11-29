require "rails_helper"

# Rspec tests are provided to ensure that the logic handling controller vs request specs
# works with rspec.
# We do this by testing the flash assigns, as this should only be present for controller tests.
# Also see spec/integration

RSpec.describe KwargsController, type: :controller do
  it "handles a rspec test marked as type 'controller' as a rails controller spec" do
    action = :test_kwargs
    params = { params: "params" }
    flash = { flash: "flash" }
    session = { session: "session"}

    expect_any_instance_of(ActionController::TestCase::Behavior).to receive(:get).with(action, params, session, flash)

    get action, params: params, session: session, flash: flash
  end
end