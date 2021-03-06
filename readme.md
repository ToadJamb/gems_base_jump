[![Build Status](https://travis-ci.org/ToadJamb/gems_base_jump.svg?branch=master)](https://travis-ci.org/ToadJamb/gems_base_jump)

BaseJump
========

Jump start your application by base jumping your app.


Install
=======

	$ gem install base_jump


Gemfile
=======

	$ gem 'base_jump'


Require
=======

	$ require 'base_jump'


Example Usage
=============

Initialization
--------------

    module MyApp
      module App
      end
    end

    BaseJump.init MyApp::App

BaseJump will look for an environment variable named `MYAPP_ENV`
to determine the environment.


Configuration
-------------

BaseJump attempts to provide sensible defaults for all configuration options,
but any/all of the following may be overridden
in the individual environment files.

config/environments/development.rb:

    MyApp::App.configure do |config|
      config.log_destination = path_to_log
      config.logger          = my_logger
    end


Environment
-----------

`MyApp::App.env.test?` will exist
if there is a `config/environments/test.rb` file.

`MyApp::App.environment #=> :development`

`MyApp::App.environment = 'test'` will set the value
of the environment variable.
This value will be a lower case symbol.

    # Starting values
    MyApp::App.environment #=> :development
    ENV['MYAPP_ENV']  #=> 'development'

    # Set environment to test
    MyApp::App.environment = 'TeSt'

    MyApp::App.environment #=> :test
    ENV['MYAPP_ENV']  #=> 'test'
