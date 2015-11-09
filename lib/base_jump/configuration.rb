module BaseJump
  class Configuration
    attr_writer :log_destination
    attr_writer :log_path
    attr_writer :log_level
    attr_writer :custom_formatter

    attr_accessor :initializers
    attr_accessor :color_log

    def initialize
      @log_file = "#{Backpack.app.environment}.log"
      @log_path = 'log'

      @color_log = false
      @color_log = true if Backpack.app.environment == :development

      @log_level = Logger::INFO
      if [:test, :development].include?(Backpack.app.environment)
        @log_level = Logger::DEBUG
      end

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

    def custom_formatter
      return @custom_formatter if defined?(@custom_formatter)
    end

    def logger=(new_logger)
      new_logger.level = @log_level
      new_logger.custom_formatter = custom_formatter
      @logger = new_logger
    end
  end
end
