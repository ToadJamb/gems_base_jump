module BaseJump
  # This module holds the `test?`, `development?`, etc. methods.
  module Env
    extend self
  end

  module Environment
    extend self

    def env
      Env
    end

    def environment
    end
  end
end
