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

    def colorize(text, color = nil)
      ColorHelper.colorize text, color
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

    def log_with_time(description, level = :info, &block)
      return unless block_given?

      color   = nil
      started = nil

      logger.send(level) do
        color       = next_color_for(description)
        description = ColorHelper.colorize(description, color)
        started     = Time.now

        "#{starting} #{description}"
      end

      finish_block_for description, level, started, &block
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

    def next_color_for(description)
      ColorHelper.next_color unless ColorHelper.colored?(description)
    end

    def starting
      @starting ||= ColorHelper.colorize('Starting', :green)
    end

    def finished
      @finished ||= ColorHelper.colorize('Finished', :red)
    end

    def finish_block_for(description, level, started, &block)
      yield

      logger.send(level) do
        "#{finished} #{description} in #{elapsed_from(started)}"
      end
    end

    def elapsed_from(started)
      seconds = Time.now - started
      hash = interval_for(seconds)
      format_elapsed hash[:interval], hash[:descriptor]
    end

    def interval_for(seconds)
      hash = {}

      if seconds >= 60 * 60
        hash[:interval] = seconds / (60 * 60.0)
        hash[:descriptor] = 'hour'
      elsif seconds >= 60
        hash[:interval] = seconds / 60.0
        hash[:descriptor] = 'minute'
      else
        hash[:interval] = seconds
        hash[:descriptor] = 'second'
      end

      hash
    end

    def format_elapsed(interval, descriptor)
      descriptor = descriptor.pluralize(interval)
      interval   = '%.2f' % interval

      ColorHelper.colorize "#{interval} #{descriptor}", :light_magenta
    end
  end
end
