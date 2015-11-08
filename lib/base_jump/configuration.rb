module BaseJump
  class Configuration
    attr_writer :log_destination
    attr_writer :log_path
    attr_writer :log_level

    attr_accessor :initializers

    def initialize
      @log_file = "#{Backpack.app.environment}.log"
      @log_path = 'log'

      if [:test, :development].include?(Backpack.app.environment)
        @log_level = Logger::DEBUG
      else
        @log_level = Logger::INFO
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

    def logger=(new_logger)
      new_logger.level = @log_level
      @logger = new_logger
    end
  end
end
