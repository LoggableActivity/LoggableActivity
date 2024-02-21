# Loggable Activity 🌟
Secure protect data and log how it is handled
- Keep an activity log of how data in the db are handled.
- Protect and secure the privacy of data stored in Activity Logs
- Prepare for General Data Protection Regulation (GDPR) compliance.
- Handles activities that involves more than one table in the DB.

### Important!
This project is under development and not ready for production. There might be breaking changes, so please consult the CHANGELOG.md
### What it is not
- An error logging system
- A paper trails system with rollback.
- A backup system

### Applications
Most organizations needs to keep a log of how users interact with data stored in the DB
- Finance
- Healthcare
- Sales and Support

*Super simplified example from the healthcare.*
- Each patient has a journal, that is updated on a regular basis.
- Supervisor needs to follow the journal, how was it updated, who read it, did it get deleted.
- Security personnel needs to know how the journal is handled, who did what when.
- Patients has the right to know how their journal is handled and that their data will be removed when required.

Beside the journal in the db, an activity log is kept so it is possible to track how the journal is used.<br/>
At some point in time the patients data from the DB and the activity log has to be removed according to GDPR.<br/>

### Contribute
👉 Join the Slack channel here: [LoggableActivity Slack Workspace](https://join.slack.com/t/loggableactivity/shared_invite/zt-2a3tvgv37-mGwjHJTrBXBH2srXFRRSXQ)
<br/>
👉 Want to play around with an online version: [Show Demo](https://loggableactivity-efe7b931c886.herokuapp.com/)
<br/>
We value each contribution and believe in the power of community. Looking forward to seeing you there!


### Test
We embrace the philosophy of black-box testing, where we focus on the input and output of the public interface without worrying about internal implementation details.<br/>
This approach aligns with the principle of testing behavior rather than implementation.