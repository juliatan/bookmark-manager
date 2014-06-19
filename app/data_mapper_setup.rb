env = ENV["RACK_ENV"] || "development"

# we are telling DataMapper to use a postgres database on localhost.
# The name will be bookmark_manager_test or bookmark_manager_development depening
# on the environment.
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
# default here is the default adaptor for this type of database (postgres)
# the URL shown is the URL for the database

# After declaring your models, you should finalise them (when they are checked
# for consistency)
DataMapper.finalize

# However, the database tables don't exist yet. Let's tell DataMapper to
# create them.
# DataMapper.auto_upgrade! # uncomment as necessary!
# auto_upgrade makes non-destructive changes. If your tables don't exist, they will be created
# but if they do and you changed your schema (e.g. changed the type of one of the properties)
# they will not be upgraded because that'd lead to data loss.
# To force the creation of all tables as they are described in your models, even if this
# leads to data loss, use auto_migrate:
# DataMapper.auto_migrate!
# Finally, don't forget that before you do any of that stuff, you need to create a database first.
