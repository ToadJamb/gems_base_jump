module BaseJump
  module Core
    extend self

    def init(app)
      raise ApplicationInitializedError.new(Backpack.app) if Backpack.app

      app.extend Application

      add_environment_methods

      Backpack.init app

      require_environment
    end

    private

    def add_environment_methods
      System.dir_glob('config/environments/*.rb').each do |file|
        environment = File.basename(file, '.rb')
        add_environment_method "#{environment}?", environment.to_sym
      end
    end

    def add_environment_method(method_name, environment)
      Env.module_eval do
        remove_method method_name if respond_to?(method_name)
        define_method method_name do
          Backpack.app.environment == environment
        end
      end
    end

    def require_environment
      path = File
        .expand_path("config/environments/#{Backpack.app.environment}.rb")
      require path if File.exist?(path)
    end
  end

  extend Core
end
