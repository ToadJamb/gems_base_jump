module BaseJump
  module Core
    extend self

    def init(app)
      raise ApplicationInitializedError.new(Config.app) if Config.app

      app.extend Environment

      Config.init app

      load_environment
    end

    private

    def load_environment
      System.dir_glob('config/environments/*.rb').each do |file|
        environment = File.basename(file, '.rb')

        add_environment_method "#{environment}?", environment.to_sym

        require_environment file, environment
      end
    end

    def add_environment_method(method_name, environment)
      Env.module_eval do
        remove_method method_name if respond_to?(method_name)
        define_method method_name do
          Config.app.environment == environment
        end
      end
    end

    def require_environment(file, environment)
      full_path = File.expand_path(file)
      if File.exist?(full_path) && Config.app.env.send("#{environment}?")
        require full_path
      end
    end
  end

  extend Core
end
