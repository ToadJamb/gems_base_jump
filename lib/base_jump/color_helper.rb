module BaseJump
  module ColorHelper
    extend self

    COLORS = [
      :cyan,
      :magenta,
      :blue,
    ]

    def colorize(text, color)
      if Backpack.configuration.colorize? && color
        text.to_s.colorize color
      else
        text
      end
    end

    def next_color
      COLORS[self.index += 1]
    end

    def colored?(text)
      !!text.match(/\e\[\d{1,2};/)
    end

    private

    def index
      @index ||= -1
    end

    def index=(value)
      value = -1 unless COLORS[value + 1]
      @index = value
    end
  end
end
