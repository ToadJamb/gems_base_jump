module BaseJump
  module Application
    extend self

    def configure(&block)
      yield Config if block_given?
    end
  end
end
