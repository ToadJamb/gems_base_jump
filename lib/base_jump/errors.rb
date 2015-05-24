module BaseJump
  class ApplicationInitializedError < StandardError
    def initialize(namespace)
      @namespace = namespace
    end

    def message
      "Application already initialized using #{@namespace}."
    end
  end
end
