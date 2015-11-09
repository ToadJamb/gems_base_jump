module BaseJump
  class CustomLogFormatter < Logger::Formatter
    # This format was taken from ::Logger::Formatter
    Format = "%s, [%s#%d] %5s -- %s: %s\n"

    SeverityColor = {
      'DEBUG' => :light_black,
      'INFO'  => :blue,
      'WARN'  => :yellow,
      'ERROR' => :red,
      'FATAL' => :light_red,
    }

    def call(sev, time, progname, msg)
      severity = severity_for(sev)

      Format % [
        severity[0],
        format_datetime(time),
        $$,
        severity[1],
        progname,
        msg2str(msg),
      ]
    end

    private

    def severity_for(severity)
      color =
        if Backpack.configuration.color_log?
          SeverityColor[severity]
        end

      sev = []

      sev << ColorHelper.colorize(severity[0..0], color)
      sev << ColorHelper.colorize(severity, color)

      sev
    end
  end
end
