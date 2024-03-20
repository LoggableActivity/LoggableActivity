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
First we add the loggable_activity gem to the Gemfile `gem 'loggable_activity', '~> x.x.xx'` and then<br/>
```
$ bundle install
```
Then we have to generate some migrations and additionals files<br/>
```
$ rails generate loggable_activity:install
```
This will install the following files
- app/controllers/concerns/loggable_activity/current_user.rb
- config/loggable_activity.yml
- config/locales/loggable_activity.en.yml
- db/migrate/xxxxxxxxxxxxxx_create_loggable_activities


## Add hoks to models to be logged
```
class User < ApplicationRecord
  include LoggableActivity::Hooks
```

## Configuration
Update `config/application.rb`, you might do it differently in production
```
  config.loggable_activity = ActiveSupport::OrderedOptions.new
  config.loggable_activity.actor_display_name = :full_name
  config.loggable_activity.current_user_model_name = 'User'
  ::LoggableActivity::Configuration.load_config_file('config/loggable_activity.yaml')
```
- actor_display_name: this is a method on the User model we want to use when presenting the actor.
- current_user_model: This is the name of the model we use for current_user
- load_config_file: this is the configuration we will look at next.

## loggable_activity.yaml
You have to update the configuration file installed inside the `config/loggable_activity.yaml`
This file defines:
- What fields in a table to log
- What relations to include in a logged activity 
- What should happen to the aggregation if a record is deleted.
- What actions to log automatically

**!Catch**<br/>
`show` can not `auto_log` so it has to be handled manually, more about that later.<br/>
*Here is an example of content for the config/loggable_activity.yaml file*
```
Demo::Club: 
  record_display_name: email 
  route: show_demo_club
  loggable_attrs: 
    - email
    - name
  auto_log:
    - create
    - update
    - destroy
  relations:
    - belongs_to: :address
      model: Demo::Address
      route: show_address
      loggable_attrs:
        - street
        - city
```

Lets break this down.
- First we can se that we are logging a model named Demo::Club.
- `record_display_name:` is the field/method on the on the model we want to display as a headline in the log
- `route` is a flag used to generate a link to the model logged, more on that later.
- Then we can se that we are logging the `email` and `name`.
- Then we can se that we are logging `create`, `update`, and `destroy` automatically.
- Then there are some relations: that we want to collect and add to the log.<br/> 
In this example the club belongs to an address so we add the street and city from the address to the log.


## Set current user
Add a this to the application_controller.rb
```
class ApplicationController < ActionController::Base
  include LoggableActivity::CurrentUser
```
If there is not current_user nothing will be logged. <br/>
You can look inside `app/controllers/concerns/current_user.rb` and alter it with a default `current_user` if needed. 

## Log the show action
As mentioned earlier, show can not be logged automatically<br/>
If you want to log the show action you can add this to your controllers show method
```
def show
  @user.log(:show)
```

## Relations
Supported relations at the moment is 
- belongs_to
- has_one
- has_many

## Render templates
*Optional*
<br/>You can install all the files needed to render a list of activities<br/> 
The following command will generate all the files need for showing the activity log
```
$ rails g loggable_activity:install_templates
```
or for the slim template language. (don't run both)
```
$ rails g loggable_activity:install_templates --template=slim
```
Now you got the `loggable_activity_helper.rb' installed.<br/>
You can use the `render_activity` method from your view like this.
```
  <table>
    <thead>
      <tr>
        <th>Info</th>
        <th>Attributes</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <% @loggable_activities.each do |activity| %>
        <%= render_activity(activity) %>
      <% end %>
    </tbody>
  </table>
```
Create a route and a controller and fetch the `@loggable_activities` like this
```
class ActivityLogsController < ApplicationController
  def index
    @loggable_activities = ::LoggableActivity::Activity.latest(50)
  end
end
```
Or you can fetch all activities for a given actor like this
```
def show
  @loggable_activities = ::LoggableActivity::Activity.where(actor: @user)
end
```

## For developers and contributors 
If you can download and play around with a demo app
- 1 Down the demo project from [demo project on github](https://github.com/maxgronlund/LoggableActivityDemoApp)
- 2 Update the Gemfile in the demo project so it points to your localhost.
- 3 you can now build and test you version of the gem `$ gem build loggable_activity.gemspec`
