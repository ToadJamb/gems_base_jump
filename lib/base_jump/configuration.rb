module BaseJump
  class Configuration
    attr_writer :logger
    attr_writer :log_destination
    attr_writer :log_path

    def initialize
      @log_file = "#{Backpack.app.environment}.log"
      @log_path = 'log'
    end

    def log_destination
      return @log_destination if defined?(@log_destination)

      log_path = File.expand_path(File.join(@log_path, @log_file))
      FileUtils.mkdir_p File.dirname(log_path)
      @log_destination = File.open(log_path, 'a+')

      @log_destination
    end

    def logger
      @logger ||= ::Logger.new(log_destination)
    end
  end
end
