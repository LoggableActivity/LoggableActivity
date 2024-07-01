# LoggableActivity overview
Loggable activit only has a few tables. In the following I will refer to a **hosting application** this is the<br/>
Rails application where the gem is used.<br/>
The diagram below shows the associations but not the fields in each table.
### Relations
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓     ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃      LoggableActivity::Activity       ┃     ┃    LoggableActivity::EncryptionKey    ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫     ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
│actor : belongs_to association         │     │record : belongs_to association        │
└───────────────────────────────────────┘     └───────────────────────────────────────┘
                    ┼                                             ┼                    
                    │                                             │                    
                    │                                             │                    
                    │                                             │                    
                    ┼                                             │                    
                   ╱│╲                                            │                    
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓                         │                    
┃       LoggableActivity::Payload       ┃┼────────────────────────┘                    
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫                                              
│record: belongs_to association         │                                              
└───────────────────────────────────────┘                                                                                       
```
### LoggableActivity::Activity
The activity class represents one activity performed by an actor in the hosting application.<br/>
An actor can be any model but will typically be a **User**, often `current_user` <br/>
One `Loggable::Activity` can have many `payloads`

### LoggableActivity::Payload
The payloads hold the data to store for an activity,<br/> 
each `payload` represent the data from one `record` in the hosting application.<br/>
What data to store is loaded from a yaml file by the `configuration.rb` class.<br/>
The record in the hosting application is also referred to as the `data owner`.<br/>
When the `data owner` is deleted the payload stays unaffected.<br/>
Payloads comes in different flavors. 
- primary_payload
- has_many_payload
- belongs_to_payload
- has_one_payload
- belongs_to_update_payload
- has_many_create_payload

Each flavor represent how a payload relates to an activity.


### LoggableActivity::EncryptionKey
The encryption key is used to encrypt the data stored by one payload.<br/>
The `record` association points to a record in the hosting application.<br/>
When the record in the hosting application is deleted, the `encryption key'

## Sequence
When a model in the hosting application includes `LoggableActivity::Hooks` it is provided with the following hooks.
```
after_create :log_create_activity
after_update :log_update_activity
before_destroy :log_destroy_activity
```
This will trigger the log() method in the hooks module, show is handled a little different but that is not important in this context,<br/>
The important thing is that logging happens automatically.<br/>
Below is a sequence diagram that shows how the different models are called.
```
   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓                                                                                           
   ┃       Model in hosting application        ┃                                                                                           
   ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫                                                                                           
   │Include LoggableActivity::Hooks            │                                                                                           
   └──────────────────┬┬───────────────────────┘                                                                                           
                      ││     ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓                                                                
                      ││     ┃LoggableActivity::Services::PayloadsBuilder ┃                                                                
create ──log()─────▶  ││     ┗━━━━━━━━━━━━━━━━━━━━━┳┳━━━━━━━━━━━━━━━━━━━━━┛                                                                
                      ││                           ││                                                                                      
                      ││──────────build()─────────▶││   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓                              
                      ││                           ││   ┃ LoggableActivity::Services::UpdatePayloadsBuilder ┃                              
read   ──log()─────▶  ││                           ││   ┗━━━━━━━━━━━━━━━━━━━━━━━━━┳┳━━━━━━━━━━━━━━━━━━━━━━━━┛                              
                      ││                           ││                             ││                                                       
                      ││──────────build()─────────▶└┘                             ││  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
                      ││                                                          ││  ┃LoggableActivity::Services::DestroyPayloadsBuilder ┃
update ──log()─────▶  ││                                                          ││  ┗━━━━━━━━━━━━━━━━━━━━━━━━━┳┳━━━━━━━━━━━━━━━━━━━━━━━━┛
                      ││──────────────────────────────────────────build()────────▶││                            ││                         
                      ││                                                          └┘                            ││                         
                      ││                                                                                        ││                         
destroy──log()─────▶  ││                                                                                        ││                         
                      ││──────────────────────────────────────────build()──────────────────────────────────────▶││                         
                      ││                                                                                        ││                         
                      └┘                                                                                        └┘                         

```

The hooks module orchestrate and provide the activity logging functionality.