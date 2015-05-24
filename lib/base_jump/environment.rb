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
      @environment
    end

    def environment=(value)
      @environment = normalize(value)
      ENV[Config.env_var] = @environment.to_s
    end

    private

    def normalize(env)
      if env.nil? || env.to_s.strip == ''
        :development
      else
        env.to_s.strip.downcase.to_sym
      end
    end
  end
end
