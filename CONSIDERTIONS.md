# Considerations, Work in progress.
This document is stored here and might deleted<br/>
<br/>
It should be easy to configure and use the *LoggablActivity* without having to collect and format data all over the system.<br/>
It should also be possible to delete a data owner and then all data related to that data owner should be inaccessible.  


### Protection of data that belongs to a data owner
One way to protect data in a field is to encrypt it, when requested it can then be decrypted.<br/>
If the data is required permanently deleted all there is to do is to throw away the key.<br/>
Another way is to delete the content in all fields for a given data owner on request.<br/>

### Composition of data in a log entry
Lets consider an example with a user, the user has som personal information directly on the users DB Record.
The user also has a relation to an address and the user might have a couple relations to other users, friends family members etc.<br/> 
All this is created from one form and when it is submitted we want to log it. 
One way of do it is to collect all the data from the DB and pack it into a json payload and submit it to the log, but then we have no control of<br/>
What data is confidential and who it belongs to. So instead lets make some configurations for how data are handled.
<br/>*Example*
```
┌──────────────────────┐      ┌──────────────────────┐
│         User         │  ┌──▶│       Address        │
├──────────────────────┤  │   ├──────────────────────┤
│name: String          │  │   │street: String        │
├──────────────────────┤  │   ├──────────────────────┤
│date_of_birth: Date   │  │   │city: String          │
├──────────────────────┤  │   └──────────────────────┘
│address_id: Reference │──┘                           
├──────────────────────┤                              
│system_task_uuid: UUID│                              
└──────────────────────┘                              
            ┼                                         
            │                                         
           ╱│╲                                        
┌──────────────────────┐                              
│       Friend         │                              
├──────────────────────┤                              
│user_a_id: Reference  │                              
├──────────────────────┤                              
│user_b_id: Reference  │                              
└──────────────────────┘    
```
Then a payload could look like this
```

{
  user: {
    name: Sting
    date_of_birth "October 2, 1951"
    address: {
      street: "some street",
      city: "London"
    },
    friend: [
      user: {
        name: "Bob"
        date_of_birth: "September 01, 1991
      }
    ]
  }
}
```
But what about Bob, he is in the system and want to have control of his own data.<br/> 
To achieve this we need to organize the way we store log entries so owners can be identified even within a payload.
```
        ┌────────────────────────┐
        │        Activity        │
        ├────────────────────────┤
        │key: String             │
        ├────────────────────────┤
        │who_did_it_type: String │
        ├────────────────────────┤
        │who_did_it_id: UUID     │
        ├────────────────────────┤
        │time: DateTime          │
        └────────────────────────┘
                    ┼            
                    │            
                    │            
                   ╱│╲           
        ┌────────────────────────┐
        │        Payload         │
        ├────────────────────────┤
        │data: Json              │
        ├────────────────────────┤
        │owner_id: UUID          │
        ├────────────────────────┤
        │owner_type: String      │
        └────────────────────────┘
```
So now we can control access to Bobs data in the Logging DB

### example of how a `Loggable::Activity` is formatted for the view 
```
activity = Loggable::Activity.lastest.last
activity.attrs ==>

payloads: [
  primary: {
    name: "User",
    changes: {
      attrs: {
        first_name: {
          from: "Bob",
          to: "Rob"
        }
      }
    }
  }
  relations: [
    name: "Demo::Address
    changes: {
      street: {
        from: "5th Avenue",
        to: "Broadway"
      } 
    }
  ]
]


```







