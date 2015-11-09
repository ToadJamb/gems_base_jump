module BaseJump
  module Application
    include Environment

    def configure(&block)
      yield configuration if block_given?
    end

    def logger
      configuration.logger
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
