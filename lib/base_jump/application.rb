module BaseJump
  module Application
    extend self

    def init(app)
      raise ApplicationInitializedError.new(Config.app) if Config.app

      Config.init app

      BaseJump.load_environment

      Config.app.extend Environment
    end
  end
end
