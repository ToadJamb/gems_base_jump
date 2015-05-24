module BaseJump
  module Application
    extend self

    def init(app)
      raise ApplicationInitializedError.new(@app) if defined?(@app)
      @app = app
      BaseJump.load_environment
      @app.extend Environment
    end

    def app
      @app
    end
  end
end
