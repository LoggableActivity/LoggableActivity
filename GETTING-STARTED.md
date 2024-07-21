# Getting started 
This document should you getting started with `LoggableActivity`

## Prerequisite
1 A running Rails Application<br/>
2 An authorization system where a current user or similar is available.

## Installation
Add the loggable_activity gem to the Gemfile `gem 'loggable_activity', '~> 0.5.4` and then<br/>
Remember to check for the latest version number
```
$ bundle install
```
Then we have to generate some migrations and execute them<br/>
```
$ bin/rails generate loggable_activity:install
$ bin/rails db:migrate
```

## Add hoks to models
```
class User < ApplicationRecord
  include LoggableActivity::Hooks
```

## Configuration
Update `config/initializers/loggable_activity.rb` documentation is in the file.

## loggable_activity.yaml
You have to update the configuration file installed inside the `config/loggable_activity.yaml`
This file defines how data are logged.

## Automatically log show from controllers
This assumes that there is a current_user. E.g provided by the Devise gem</br>
Add a this to the application_controller.rb if you want automatically log show
```
class ApplicationController < ActionController::Base
  include LoggableActivity::CurrentUser
```
Otherwise you might create `app/controllers/concerns/current_user.rb` and alter it . 

## Manually log show from controllers
If you want to log the show action you can add this to your controllers show method
```
def show
  @user.log(:show)
```

## For developers and contributors 
You can download and play around with a demo app
- 1 Download the project from [github](https://github.com/LoggableActivity/LoggableActivity) 
- 1 Download the demo application from [github](https://github.com/LoggableActivity/LoggableActivityDemoApp)
- 2 Update the Gemfile in the demo project so it points to your localhost.
```
Gemfile

gem 'loggable_activity', '~> VERSION', path: '/PATH_TO_PROJECT/LoggableActivityEngine/LoggableActivityEngine'
# gem 'loggable_activity', '~> VERSION'
```
*VERSION is the version number found in the gemfile*<br/>
*PATH_TO_PROJECT* is where you have stored the project on your local drive