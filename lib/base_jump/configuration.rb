module BaseJump
  class Configuration
    attr_writer :log_destination
    attr_writer :log_path
    attr_writer :log_level
    attr_writer :custom_log_formatter
    attr_writer :color_log

    attr_accessor :initializers

    def initialize
      @log_file = "#{Backpack.app.environment}.log"
      @log_path = 'log'

      @color_log = false
      @color_log = true if Backpack.app.environment == :development

      init_log_level

      @colorize = false

      @initializers = []
    end

    def log_destination
      return @log_destination if defined?(@log_destination)

      log_path = File.expand_path(File.join(@log_path, @log_file))
      FileUtils.mkdir_p File.dirname(log_path)
      @log_destination = File.open(log_path, 'a+')

      @log_destination
    end

    def logger
      return @logger if defined?(@logger)

      self.logger = ::Logger.new(log_destination)

      @logger
    end

    def custom_log_formatter
      return @custom_log_formatter if defined?(@custom_log_formatter)
      @custom_log_formatter = CustomLogFormatter.new
    end

    def logger=(new_logger)
      new_logger.level = @log_level
      new_logger.formatter = custom_log_formatter
      ActiveRecord::Base.logger = new_logger if defined?(ActiveRecord)
      @logger = new_logger
    end

    def color_log?
      !!@color_log && colorize?
    end

    def colorize?
      @colorize
    end

    def colorize!
      require 'colorize'
      String.disable_colorization = false
      @colorize = true
    end

    private

    def init_log_level
      @log_level = Logger::INFO
      if [:test, :development].include?(Backpack.app.environment)
        @log_level = Logger::DEBUG
      end
    end
  end
end
