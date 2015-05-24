module BaseJump
  # This module holds the `test?`, `development?`, etc. methods.
  module Env
    extend self
  end

  module Environment
    def env
      Env
    end
  end
end
