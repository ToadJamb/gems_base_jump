module BaseJump
  module Core
    extend self

    def load_environment
      System.dir_glob('config/environments/*.rb').each do |file|
        environment = File.basename(file, '.rb')
        add_environment_method "#{environment}?", environment.to_sym
      end
    end

    private

    def add_environment_method(method_name, environment)
      Env.module_eval do
        remove_method method_name if respond_to?(method_name)
        define_method method_name do
          Config.app.environment == environment
        end
      end
    end
  end

  extend Core
end
