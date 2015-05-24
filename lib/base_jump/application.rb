module BaseJump
  module Application
    extend self

    def init(app)
      raise ApplicationInitializedError.new(Config.app) if Config.app

      app.extend Environment

      Config.init app

      BaseJump.load_environment
    end
  end
end
