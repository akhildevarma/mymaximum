
[![codeship build status](https://codeship.com/projects/61b2c570-009d-0133-dbe7-06bb0e4efb99/status?branch=staging)](https://codeship.com/projects/88381)

InpharmD
===============

InpharmD is a drug information service sponsored by Mercer University.
Healthcare providers can use this application to ask a team of Mercer
pharmacy students for an in-depth, evidence-based report on a specific
pharmaceutical question. Patients can use this application to search
four large health information websites for pharmaceutical information
with the click of a button. In both cases, users will be able to
receive updates on their queries as new information becomes available.

### Tech Specs

  - Ruby 2.2.0 / Rails 4.0.0
  - Postgres
  - Rspec + Capybara
  - Sendgrid

### Hosting

The application is hosted on Heroku.

  - Production: [http://mercer-inpharmd.herokuapp.com](http://mercer-inpharmd.herokuapp.com)
  - Staging: [http://staging-mercer-inpharmd.herokuapp.com](http://staging-mercer-inpharmd.herokuapp.com)

### Workflow

Push completed stories to the `staging` branch. Deliver them to the staging environment (see below). Once a story
has been accepted, merge the relevant branches into production and redeploy.

### Environment Variables

Some of these are sensitive, so they may not be located in this repo. You need to have, at a minimum:

Twilio login information:

  - `TWILIO_ACCOUNT_SID`
  - `TWILIO_AUTH_TOKEN`
  - `TWILIO_PHONE_NUMBER`

Stripe keys*:
  -`STRIPE_PUBLIC_KEY`
  -`STRIPE_API_KEY`
(For testing, development, and the staging environment, use the test keys provided by Stripe.)

And be sure that these are set on Heroku (not necessary for developing on localhost)--
  - `APP_NAME` -- should just be the Heroku app name
  - `HEROKU_API_KEY`
(These are both needed by the Workless gem.)

### Deploying

Use the following rake tasks. These tasks assume your Heroku remotes are called `heroku-staging` and `heroku-production`.

  - Deploy `staging` branch to staging: `rake deploy:staging`
  - Deploy `master` branch to production: `rake deploy:production`

### Setup

  1. `brew install postgresql` (unless you already have it)
  2. `bundle install`
  3. `rake db:create && rake db:migrate`
  4. `rake db:seed && rake sync_plans_with_stripe` to get the Plan and Product lookup tables ready
  5. `bundle exec foreman start` - start Unicorn (port 5000) and Mailcatcher (port 1080)

### Testing

  1. `RAILS_ENV=test rake db:create && RAILS_ENV=test rake db:migrate`
  2. `rake sync_plans_with_stripe` to get the Plan and Product lookup tables ready
  3. `bundle exec rspec`

We're using a code coverage gem called Coco, which will generate line-by-line code coverage reports for classes that are below the acceptable coverage threshold (which is currently set to 100%, so if you don't see a class in the report, it's fully covered). The report gets generated each time Rspec is run.

To view the report:
 - `open coverage/index.html`
