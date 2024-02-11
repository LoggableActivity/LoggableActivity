# Loggable Activity - Work in progress 🌟
- We Protect and secure the privacy of data stored in an Activity Log
- You are dealing with confidential or personal data protected by the General Data Protection Regulation (GDPR)
- You want to protect users (data owners) by keeping a log of how data are used.
- You are in a danger zone, the log itself holds protected data!!!




### Examples
Healthcare
Keep a log of a users Journal, when it is created, read, updated, deleted or used in any other way.
Who are reading it, are they nosy, is it there buiseness. What should happen to the Log when the users journal is deleted.
this is 

Logging of who did what when while complying to the Genera Data Protection Regulation.<br>

### Roadmap
This is a demo project where everything is implemented directly in the project.<br/>
Very next on the TODO list is to convert the Loggable::Activity into a gem.<br/>
At the moment, it uses UUIDs as IDs on records and Postgres as the DB; this should be abstracted away.<br/>
There is a need for a sponsor to provide a host for showcasing the project in the wild.<br>

👉 Join the Slack channel here: [LoggableActivity Slack Workspace](https://join.slack.com/t/loggableactivity/shared_invite/zt-2a3tvgv37-mGwjHJTrBXBH2srXFRRSXQ)

We value each contribution and believe in the power of community. Looking forward to seeing you there!


### What LoggableActivity does
Given there is a web app with a backend with various features and personas with different roles and permissions, <br/>
Then there might also be a need to log, showing who did what when.<br/>
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
A log entry is a corelation between a timestamp, an actor and some records that belongs to one or more data owner 

### Basic features
- Create a log entry when an actor (that would mostly be current_user) performs an action.
- Categorize log entries based on actions
- Store a copy of relevant data involved
- Make log entries unavailable on the data owners request
- Download the log in a portable format for a given actor in a portable format.
- Anonymize the log for science projects if permission is granted by the data owner.
- Configure logging from a config.yaml file
<br/>
