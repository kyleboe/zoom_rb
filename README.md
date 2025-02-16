# zoom_rb [![Coverage Status](https://coveralls.io/repos/github/kyleboe/zoom_rb/badge.svg?branch=main)](https://coveralls.io/github/kyleboe/zoom_rb?branch=main) [![Maintainability](https://api.codeclimate.com/v1/badges/8b8d168aa7e9d3d004f6/maintainability)](https://codeclimate.com/github/kyleboe/zoom_rb/maintainability) [![Gem Version](https://badge.fury.io/rb/zoom_rb.svg)](https://badge.fury.io/rb/zoom_rb)

Ruby wrapper gem for zoom.us API (currently `v2`)

## Installation

Add this line to your application's Gemfile:

    gem 'zoom_rb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zoom_rb

## Usage

The Zoom API uses OAuth or JWT to [Authenticate](https://marketplace.zoom.us/docs/api-reference/Authentication) API request. By default, a JWT client will be used.

```ruby
Zoom.configure do |c|
  c.api_key = 'xxx'
  c.api_secret = 'xxx'
end

zoom_client = Zoom.new
```

To create an OAuth flow you need to make a call to auth, then create the client directly from an access token.

First you need to get an auth_code externally from:
```
https://zoom.us/oauth/authorize?response_type=code&client_id=7lstjKqdwjett_kwjwDSEQ&redirect_uri=https://yourapp.com
```

Which will result in a redirect to your app with code in the url params

then use this code to get an access token and a refresh token.

```ruby
auth = Zoom::Client::OAuth.new(auth_code: auth_code, redirect_uri: redirect_uri, timeout: 15).auth

zoom_client = Zoom::Client::OAuth.new(access_token: auth['access_token'], timeout: 15)
```

You can also make a call to refresh with auth using an auth_token and a refresh_token
```ruby
client = Zoom::Client::OAuth.new(auth_token: auth_token, refresh_token: refresh_token).auth

zoom_client = Zoom::Client::OAuth.new(access_token: 'xxx', timeout: 15)
```

With the zoom client, access the API

```ruby
user_list = zoom_client.user_list
user_list['users'].each do |user|
  user_id = user['id']
  puts zoom_client.meeting_list(user_id: user_id)
end

begin
  user_list = zoom_client.user_list!
rescue Zoom::Error => exception
  puts 'Something went wrong'
end
```

## Token Store

Currently supported stores are `:redis` and `:memory`. \
Memory adapter is used **by default**.

Here is a default configuration for Redis:

```ruby
Zoom::Client::OAuth.new(
  access_token: auth['access_token'], 
  timeout: 15, 
  token_store_config: [:redis, {
    host: '127.0.0.1',
    port: '6379',
    db: '0',
    key: -> { SecureRandom.uuid }
  }]
)
```

`key:` is optional, needed to create a Redis key that stores the token \
example: `zoom_rb:123:access_token`, default: generate `SecureRandom.uuid`


## Auto refresh token

You can enable automatic call auth when the token has expired
```ruby
Zoom::Client::OAuth.new(
  # ...
  auto_refresh_token: true
)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
