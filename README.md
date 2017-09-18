# Databranch

Databranch implements database branching in development and test by cloning the database automatically, supplementing Git branching workflow. This prevents situations where the database becomes stale due to schema or data inconsistencies between git branches. It automates the process of creating and deleting branch database copies by hooking into git.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'databranch'
```

And then execute:

    $ bundle

Run the databranch install rake task to install the initializer and git hooks:

    $ rake databranch:install

Finally, update your database.yml file to point your development and test databases to databranch environment variables: 

```yaml
development:
  <<: *default
  database: <%= ENV['DATABRANCH_DEVELOPMENT'] %>

test:
  <<: *default
  database: <%= ENV['DATABRANCH_TEST'] %>
```

Note:  Databranch currently only works with Rails and PostgreSQL.  It's developed for Rails 5 but will probably work with some older versions as well (untested).


## Usage

Databranch does the rest for you.  When you checkout a new branch it will automatically copy the schema and data of the database corresponding to your existing branch to a new database that corresponds to the newly created branch for development and test.  

When you git commit, databranch checks to find databases that correspond to deleted branches and asks you if you'd like to delete them.


## TODO

Add tests.

Persist user preferences regarding specific database deletion.  Perhaps add them to a file (investigate using PStore), then when running the post commit hook check to see whether or not the database itself has been deleted.  If it has, remove the name.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/GuruKhalsa/databranch.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

