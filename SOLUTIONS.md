# Solutions

- This is an entry guide listing some important information for reviewers regarding the [Tech lead prompts] project

[Tech lead prompts]: ./TECH_LEAD_PROMPTS.md

- There is also a [video](https://www.loom.com/share/237e1eff6d2f4797aa72b053fb89bff2) (~5 mins) if you want to see the complete solution in action.

- If you want to see the whole solution (all 3 tasks) in a single PR, then just change
  the base of this [PR](https://github.com/abhishekgupta5/inventory-management/pull/3) to `main`

### Issues and Solutions

| **Type**    | **Description**             | **Issue Link**                                                                                                                              | **PR Link**                                                              |
| ----------- | --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| Improvement | `on_shelf` counter cache    | [Issue link](https://github.com/abhishekgupta5/inventory-management/blob/main/TECH_LEAD_PROMPTS.md#on_shelf-counter-cache)                  | [PR link](https://github.com/abhishekgupta5/inventory-management/pull/1) |
| BugFix      | `Order#fulfillable?`        | [Issue link](https://github.com/abhishekgupta5/inventory-management/blob/main/TECH_LEAD_PROMPTS.md#orderfulfillable-needs-a-fix)            | [PR link](https://github.com/abhishekgupta5/inventory-management/pull/2) |
| Feature     | Handle Undeliverable Orders | [Issue link](https://github.com/abhishekgupta5/inventory-management/blob/main/TECH_LEAD_PROMPTS.md#new-feature-handle-undeliverable-orders) | [PR link](https://github.com/abhishekgupta5/inventory-management/pull/3) |

### General principles followed

1. I have tried to advocate the practices followed by the current
   developer at most of the times. For eg -
   - Most of the existing code focused more on feature specs. I have also
     tried to have more feature and service specs rather than
     each public method of every model/controller
   - The way the project is structured - services, enums, UI using tailwind, etc
2. There are new migrations at different stages.
   And size of the existing data and frequency of
   reads/writes to the DB can be a deciding factor
   for how we go about a DB migration.
   I have added the things which I'll do differently
   in different level of scale in the commit messages
   In general, I have assumed a mid-size eCommerce store.

### Instructions to try out the solution

```shell
asdf install # Install dependencies
```

Assuming that you have these installed -

1. Checkout the latest branch

```shell
git checkout abhishek/handle-undeliverable-order # It is rebased on other branches (contains all the code)
```

2. Make sure that you have run the migrations

```shell
bin/rake db:migrate # All the added migrations are rollback-friendly so you can migrate/rollback as you wish
```

3. Run `dev_seed` task

```shell
bin/rake dev_seed # There is some test data that we can use to see all our features in action
```

4. Ensure webpack and rails server is running

```shell
bin/webpack-dev-server
bin/rails s
# You can also use the way  mentioned in the README.md to run them in a single command
```

5. Visit the webpage on `localhost:3000`

6. Access codes for different roles.
   You can use access code from `WAREHOUSE_EMPLOYEES` or `CUSTOMER_SERVICE_EMPLOYEES`
   from `dev_seed.rb` to do whatever actions you want.

Example access codes -

```shell
Warehouse employee - 10001
Customer Service employee - 10006
```

_Note:_ It is important that you are aware of which employee you are signed
in as - `warehouse` or `customer service`. Doable actions depend upon which employee is signed in.
