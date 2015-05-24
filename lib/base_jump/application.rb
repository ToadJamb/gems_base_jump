module BaseJump
  module Application
    extend self

    def set(app)
      @app = app
    end

    def app
      @app
    end
  end
end
