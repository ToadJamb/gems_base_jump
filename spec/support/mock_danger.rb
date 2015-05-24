module SpecHelpers
  module MockDanger
    def mock_system(method)
      allow(BaseJump::System).to receive(method)
    end

    def system_expects(method)
      expect(BaseJump::System).to receive(method)
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelpers::MockDanger
end
