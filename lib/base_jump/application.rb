module BaseJump
  module Application
    include Environment

    def configure(&block)
      yield configuration if block_given?
    end

    def logger
      configuration.logger
    end

    def database_connect!(config = database_config)
      ActiveRecord::Base.establish_connection config
    end

    def database_config(env = nil)
      require 'yaml' unless defined?(YAML)

      env ||= environment

      conf = nil

      database_url = ENV['DATABASE_URL']

      if database_url && database_url.strip != ''
        conf = database_url
      else
        conf = YAML.load(File.open('config/database.yml'))
        conf = conf[env.to_s]
      end

      conf
    end

    def run_quietly(&block)
      return unless block_given?

      verbose = $VERBOSE
      $VERBOSE = nil

      begin
        yield
      ensure
        $VERBOSE = verbose
      end
    end

    def require_quietly(file)
      run_quietly { require file }
    end

    private

    def configuration
      Backpack.configuration
    end
  end
end
