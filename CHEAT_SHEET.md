### Build gem on localhost
```
gem build loggable_activity.gemspec
```

### Release gem
- Catch DONT update VERSION, this is done by `gem bump --version x.x.x`
- Update the CHANGE_LOG.md

Make sure `gem install gem-release` is installed

```
$ gem bump --version 0.3.0
$ rake release
$ read terminal output and authorize release
```

### Heroku
```
$ heroku pg:backups:capture --app loggableactivity
$ heroku pg:backups:download --app loggableactivity
```
install on localhost
```
$ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U maxgronlund -d activity_logger_development latest.dump
```

## Build documentation
```
$ rdoc -o docs/ --all --main 
```