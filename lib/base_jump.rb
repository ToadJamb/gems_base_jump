require 'logger' # Not required for development, but consumers will fail.

lib = File.expand_path('../base_jump', __FILE__)

require File.join(lib, 'errors')
require File.join(lib, 'system')
require File.join(lib, 'color_helper')
require File.join(lib, 'configuration')
require File.join(lib, 'backpack')
require File.join(lib, 'custom_log_formatter')
require File.join(lib, 'environment')
require File.join(lib, 'core')
require File.join(lib, 'application')
