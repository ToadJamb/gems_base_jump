module BaseJump
  module Application
    extend self

    def init(app)
      raise ApplicationInitializedError.new(@app) if defined?(@app)
      @app = app
    end

    def app
      @app
    end
  end
end
