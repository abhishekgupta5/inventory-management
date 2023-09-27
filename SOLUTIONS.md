# Solutions

* This is a guide for reviewing or trying the solutions for [Tech lead prompts]
  
[Tech lead prompts]: ./TECH_LEAD_PROMPTS.md

* There is also a video (<5 mins) which shows the solution
  in action. It can make the reviewer's task easy
  
### [Improvement] - `on_shelf` counter cache
Associated PR:

### [BugFix] - `Order#fulfillable?`
Associated PR:

### [Feature] Handle Undeliverable Orders
Associated PR: 

### General principles

1) I have tried to advocate the practices followed by the current
  developer at most of the times. For eg -
   - Most of the existing code focused more on feature specs. I have also
    tried to have more feature and service specs rather than
     each public method of every model/controller 
   - The way the project is structured - services, enums, UI using tailwind, etc
     
2) There are new migrations at different stages.
   And size of the existing data and frequency of
   reads/writes to the DB can be a deciding factor
   for how we go about a DB migration.
   I have added the things which I'll do differently
   in different level of scale in the commit messages
   In general, I have assumed a mid-size eCommerce store
   
### Instructions to try out the solution

My local setup already had these so I used them. You can also
use these.
```
nodejs 19.1.0
ruby 3.2.2
yarn 1.22.17
postgres 14.4
```

Assuming that you have these installed -

1) Make sure that you have run the migrations
```shell
bin/rake db:migrate # All the added migrations are rollback-friendly so you can migrate/rollback as you wish
```

2) Run `dev_seed` task
```shell
bin/rake dev_seed # There is some test data that we can use to see all our features in action
```

3) Ensure webpack and rails server is running
```shell
bin/webpack-dev-server
bin/rails s
# You can also use the way  mentioned in the README.md to run them in a single command
```

4) Visit the webpage on `localhost:3000`


5) Access codes for different roles.
You can use access code from `WAREHOUSE_EMPLOYEES` or `CUSTOMER_SERVICE_EMPLOYEES`
from `dev_seed.rb` to do whatever actions you want.

*Note:* It is important that you are aware of which employee you are signed
in as - `warehouse` or `customer service`. Doable actions depend upon which employee is signed in.
