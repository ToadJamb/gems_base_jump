module BaseJump
  module Application
    include Environment

    def configure(&block)
      yield Backpack.configuration if block_given?
    end
  end
end
