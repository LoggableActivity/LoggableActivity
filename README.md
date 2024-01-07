# GDPR compliant logging
A system for logging of who did what when while complying to the Genera Data Protection Regulation.

### What is does
Given there is a web app with a backend with various features and personas with different roles and permissions, <br/>
Then there might also be a need to log, who did what when.<br/>
For example:
- A doctor is looking at a patients journal, it might be confidential.
- A user is sending a personal message to another user, the user might be spamming, phishing etc...
- An administrator is granting an other user some permissions.

### Who is it for?
The logging system is intended for those who are in charge of monitoring how users interact with the system.<br/>
For example:
- Users with responsibility for security and traceability at a hospital.
- Supporters who needs a log of what a customer did when.
- System administrators who needs to know who updated an other users permissions.

### What it is not
- An error logging system
- A paper trails system with rollback.

### What is a log entity?
A log entry is a corelation between a timestamp, an actor and some data that belongs to one or more data owner 

### Basic features
- Create a log entry when an actor performs an action.
- Categorize log entries based on actions
- Store a copy of relevant data involved
- Obfuscate data on request
- Download the log in a portable format for a given actor in a portable format.
<br/>
<br/>
<br/>

# Considerations
A log entry are created when an actor performs an action.<br/>
Actions can be categorized but not limited to CRUD (Create Read Update and Delete).<br/> 
Actions are performed on a subject, that can be a blog post, an user, an address, a purchase and so forth.<br/>
Data belongs to an owner, that can request the data in a portable format, and request it *deleted<br/>
A log entry is relatet to a subject that might involve data from multiple tables from one ore more databases.<br/>
Some of the field in a table might be confidential and some of them might have no relevancy.<br/>
Some of the tables and fields might relate to one ore more data owners.<br/>
When a log entry is created it should be unbreakable, modifying the original data logged should not change the log.<br/>
It should be possible to remove traceability for a given data owner.
It should be possible to present the data in a simple convenient form, with links to original data.
Some data might be to big to store in the log, eg sound and video and other media files.
Some of the data fields might need permission to present.


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
│       Relation       │                              
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
    relations: [
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









