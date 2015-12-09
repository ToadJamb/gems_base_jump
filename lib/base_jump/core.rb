module BaseJump
  module Core
    extend self

    def init(app)
      raise ApplicationInitializedError.new(Backpack.app) if Backpack.app

      app.extend Application

      add_environment_methods

      Backpack.init app

      require_environment
      load_dotenv if defined?(Dotenv)
      require_initializers
    end

    def load_tasks!
      path = File.expand_path('../tasks/**/*.rake', __FILE__)
      System.dir_glob(path).each do |file|
        load file
      end
    end

    private

    def load_dotenv
      dotenvs = []
      dotenvs <<  "config/dotenv/#{Backpack.app.environment}.env"
      dotenvs << '.env'

      Dotenv.load(*dotenvs)
    end

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
      app_path = File.expand_path('config/application.rb')
      require app_path if File.exist?(app_path)

      path = File
        .expand_path("config/environments/#{Backpack.app.environment}.rb")
      require path if File.exist?(path)
    end

    def require_initializers
      initializers = config.initializers.dup

      initializers.map! do |initializer|
        find_initializer_for initializer
      end

      initializers += find_initializers_without(initializers)

      initializers.each { |i| require i }
    end

    def find_initializers_without(initializers)
      globbed = []

      path = File.expand_path('config/initializers/**/*.rb')
      Dir[path].each do |initializer|
        globbed << initializer unless initializers.include?(initializer)
      end

      globbed
    end

    def find_initializer_for(initializer)
      return initializer if initializer[0] == '/'

      initializer += '.rb' if File.extname(initializer) == ''

      unless initializer.match(/^config\/initializers/)
        initializer = File.join('config', 'initializers', initializer)
      end

      File.expand_path initializer
    end

    def config
      Backpack.configuration
    end
  end

  extend Core
end
