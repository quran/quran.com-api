# setup

## create the test db like this:

```
RAILS_ENV=test rake db:setup
```

# testing

## testing the search controller

```
rake test test/controllers/search_controller_test.rb
```


## guidance for other to-be-written tests

visit http://guides.rubyonrails.org/testing.html


If you want to use the development database, use:
```
RAILS_ENV=development rake test test/controllers/search_controller_test.rb
```

