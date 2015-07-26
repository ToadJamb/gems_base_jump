module BaseJump
  module Backpack
    extend self

    attr_reader :app
    attr_reader :env_var

    def init(app)
      @app = app
      set_env_var
      @app.environment = ENV[@env_var]
    end

    private

    def set_env_var
      app_name = app.to_s
      index    = app_name.index(':') || 0
      app_name = app_name[0..index - 1].upcase

      @env_var = "#{app_name}_ENV"
    end
  end
end
