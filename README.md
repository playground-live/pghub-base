# Pghub::Base
This gem offers base function for all `Pghub` gems.

[pghub-lgtm](https://github.com/playground-live/pghub-lgtm)

[pghub-issue_title](https://github.com/playground-live/pghub-issue_title)

[pghub-auto_assign](https://github.com/playground-live/pghub-auto_assign)

## Usage
You don't have to operate this gem.
Look at other `Pghub` gems.

### Get github access token

### Deploy to heroku

### All Pghub gems (lgtm, issue\_title, auto\_assign)

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

### Pghub-lgtm

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/playground-live/pghub-server/tree/lgtm)

### Pghub-issue_title

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/playground-live/pghub-server/tree/issue_title)

### Pghub-auto_assign

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/playground-live/pghub-server/tree/auto_assign)

### Deploy manually
- mount in routes.rb

```ruby
mount Pghub::Base::Engine => 'some/path'
```

- Add following settings to config/initializers/pghub.rb

```ruby
Pghub.configure do |config|
  config.github_organization = "Your organization (or user) name"
  config.github_access_token = "Your Github Access Token"
  #for auto_assign
  config.num_of_assignees_per_team = { your_team_name: 1, your_team_name2: 1 }
  config.num_of_reviewers_per_team = { your_team_name: 2, your_team_name2: 2 }
end
```

- Deploy to server


### Set webhook to your repository

|||
|:-:|:-:|
|URL|heroku'sURL/github_webhooks or heroku'sURL/some/path|
|Content-Type|application/json|
|Secret||
|event|check the following events|

#### events
- commit comment
- issue comment
- issues
- pull request
- pull request comment
- pull request review comment


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'pghub-base'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install pghub-base
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
