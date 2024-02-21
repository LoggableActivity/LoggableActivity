# Getting started 
This document should you getting started with `LoggableActivity`

## Prerequisite
1 A running Rails Application<br/>
2 An authorization system where there is a current user available.

## Demo Application
You can download a demo application from<br/>
[https://github.com/maxgronlund/LoggableActivityDemoApp](https://github.com/maxgronlund/LoggableActivityDemoApp)
<br/>
You can try a demo here<br/>
[https://loggableactivity-efe7b931c886.herokuapp.com/](https://loggableactivity-efe7b931c886.herokuapp.com/)

## Getting started
First we add the loggable_activity gem to the Gemfile `gem 'loggable_activity', '~> x.x.xx'` and then `$ bundle install`<br/>
Then we have to generate some migrations and additionals files<br/>
`rails generate loggable_activity:install Activity`<br/>

## Configuration
You need a configuration file inside the `config/loggable_activity.yaml`
This file defines:
- What tables to log
- What fields in a table to log
- How data is aggregated.
- What should happen to the aggregation if a record is deleted.
- What actions to log.

*Here is an example*
```
Demo::Club: 
  record_display_name: name 
  loggable_attrs: 
    - name
  auto_log:
    - create
    - update
    - destroy
  relations:
    - belongs_to: :address
      model: Demo::Address
      loggable_attrs:
        - street
        - city
```

Lets break this down.
- First we can se that we are logging a model named Demo::Club.
- `record_display_name:` is the field/method on the on the model we want to display as a headline in the log
- Then we can se that we are logging the **name** of the club, in this example that's all there is to log.
- Then we can se that we are **logging create, update, and destroy** automatically.
- Then there are some relations: that we want to collect and add to the log, in this example we are logging the address as well.

Next we have to include some hooks to the model we want to log.

```
class User < ApplicationRecord
  include LoggableActivity::Hooks
```

And then we have to add a this to the application_controller.rb
```
class ApplicationController < ActionController::Base
  include LoggableActivity::CurrentUser
```
This will give us access to the current_user.

And then we have to add this to `config/application.rb`
```
  config.loggable_activity = ActiveSupport::OrderedOptions.new
  config.loggable_activity.actor_display_name = :full_name
  config.loggable_activity.current_user_model_name = 'User'
  LoggableActivity::Configuration.load_config_file('config/loggable_activity.yaml')
```
actor_display_name: this is a method on the User model we want to use when presenting the actor.
current_user_model: This is the name of the model we use for current_user
load_config_file: this is the configuration file from above.


Then you HAVE TO to add `LogggableActivity::Hooks` to the `User Model` like this

```
class User < ApplicationRecord
  include LoggableActivity::Hooks
  ...
  resto of your code here.

```

### Log the show action
If you want to log the show action you can add this to your controllers show method
```
def show
  @user.log(:show)
```



### For developers
If you want to contribute to the development and try it out in the process
- 1 Down the demo project from [demo project on github](https://github.com/maxgronlund/LoggableActivityDemoApp)
- 2 Update the Gemfile in the demo project so it points to your localhost.
- 3 you can now build and test you version of the gem `$ gem build loggable_activity.gemspec`

### Relations
Supported relations at the moment is 
- belongs_to
- has_one
- has_many