module BaseJump
  module System
    extend self

    def dir_glob(*args)
      Dir.glob(*args)
    end
  end
end
