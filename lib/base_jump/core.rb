module BaseJump
  module Core
    extend self

    def load_environment
      System.dir_glob('config/environments/*.rb').each do |file|
        environment = File.basename(file, '.rb')
        add_environment_method "#{environment}?", environment
      end
    end

    private

    def add_environment_method(method_name, environment)
      Env.module_eval do
        remove_method method_name if respond_to?(method_name)
        define_method method_name do
          Environment.environment == environment
        end
      end
    end
  end

  extend Core
end
