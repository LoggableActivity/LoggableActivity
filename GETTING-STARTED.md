# Getting started 
This document should you getting started with `LoggableActivity`

## Prerequisite
1 A running Rails Application<br/>
2 An authorization system where there is a current available.

## Configuration
First you have to create a configuration file named `loggable_activity.yml` and locate it in the config folder.<br/>
Then you can specify fields in the user table you want to log and what data base actions to log.<br/>
Note there is no hook for `Show` in Rails so you would have to log that manually, more about that later.
*Example logging the user model*
```
User: 
  loggable_attrs: 
    - first_name
    - last_name 
    - bio
    - email
  auto_log:
    - create
    - update
    - destroy
```
Then you have to add `LogggableActivity` to the `User Model` like this

```
class User < ApplicationRecord
  include ActivityLogger
```

And finally you have to add this to the `ApplicationController`
```
class ApplicationController < ActionController::Base
  include LoggableActivity::CurrentUser
```

Now when you create a model like this:
```
$ current_user = User.create(first_name: 'Admin', last_name: 'Amin', bio: 'Admin is a administrator', email: 'admin@example.com', password: "password")
$ user = User.create(first_name: 'John', last_name: 'Doe', bio: 'John is a great guy', email: 'john@example.com', password: "password")
$ user.log(create, actor: user)
```

Then an `Logggable::Activity` is created. You can inspect it from the terminal like this.
```
puts activity = Loggable::Activity.all.order(created_at: :asc).last
puts activity.activity_type
puts activity.payloads
puts activity.payload_attrs


```

###Payloads
A `Loggable::Activity` can have multiple payloads, each payload can have it's own data owner<br/>
Imagine this scenario, a user belongs to an address, and there can be multiple users on that address.<br/> 
Then it could be configured like this.
```
User: 
  loggable_attrs: 
    - first_name
    - last_name 
    - bio
    - email
  auto_log:
    - create
    - update
    - destroy
  relations:
    belongs_to:
      - model: Demo::Address
        delete: :nullify
        loggable_attrs:
          - street
          - city
          - country
          - postal_code

```
