# Getting started 
This document should you getting started with `LoggableActivity`

## Prerequisite
1 A running Rails Application<br/>
2 An authorization system where there is a current available.

## Demo Application
You can download a demo application from<br/>
[https://github.com/maxgronlund/LoggableActivityDemoApp](https://github.com/maxgronlund/LoggableActivityDemoApp)

## Configuration
First you have to create a configuration file named `loggable_activity.yml` and locate it in the config folder.<br/>
It has the following tags
- record_display_name: <br>
You CAN define a method on the **User** model called full name, this will be a part of the json payload related to the **User** model

- loggable_attrs:<br/>
This are the fields in the database you HAS to define

- auto_log:<br/>
This are the actions that will be logged automatically, although you can log manually at any time.
Note there is no hook for `Show` in Rails so you would have to log that manually like this `log(:how)`, more about that later.

- relations:<br/>
If a model has `belongs_to` and `has_one` relations you can log them as well<br>
<br/>
*Example confuguration for logging of the user model*
```
User: 
  record_display_name: full_name
  loggable_attrs: 
    - first_name
    - last_name 
  auto_log:
    - create
    - update
    - destroy
  relations:
    - belongs_to: :demo_address
      model: Demo::Address
      loggable_attrs:
        - street
        - city
Demo::Address: 
  record_display_name: full_address
  actor_display_name: email
  loggable_attrs:
    - street
    - city
    - country
    - postal_code
```
Then you HAVE TO to add `LogggableActivity::Hooks` to the `User Model` like this

```
class User < ApplicationRecord
  include LoggableActivity::Hooks
  ...
```

And finally you have to add this to the `ApplicationController`
```
class ApplicationController < ActionController::Base
  include LoggableActivity::CurrentUser
```

Now when you create a model like this:
```
$ rails c
$ User.create(first_name: 'John', last_name: 'Doe')
```

Then an `LoggableActivity::Activity` is created. You can inspect it from the terminal like this.
```
puts activity = Loggable::Activity.all.latest.first
puts activity.activity_type
puts activity.payloads
puts activity.payload_attrs
```
