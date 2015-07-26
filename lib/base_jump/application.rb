module BaseJump
  module Application
    extend self

    def configure(&block)
      yield Backpack if block_given?
    end
  end
end
