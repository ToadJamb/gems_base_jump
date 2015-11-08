module BaseJump
  module Application
    include Environment

    def configure(&block)
      yield configuration if block_given?
    end

    def logger
      configuration.logger
    end

    private

    def configuration
      Backpack.configuration
    end
  end
end
