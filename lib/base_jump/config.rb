module BaseJump
  module Config
    extend self

    attr_accessor :app

    def init(app)
      @app = app
    end
  end
end
