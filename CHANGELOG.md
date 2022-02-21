# 1.1.0

### New features
* Support the new Zoom API OAuth security measures which are described here:
  https://marketplace.zoom.us/docs/guides/stay-up-to-date/announcements/#zoom-oauth-security-updates
* Support the code_verifier parameter in the access_tokens call.

# 1.0.2

### Fixes:
* Fix meeting_recording_get endpoint.

# 1.0.1

### Fixes:
* Fix OAuth requests in Zoom::Actions::Token.

# 1.0.0

The 1.0 release and a major refactor of all endpoint definitions.

### Breaking Change
* The `user_create` endpoint now requires its arguments to match the actual Zoom API.
  This is done to simplify the code and encourage consistency.
  This means that instead of passing:
  ```
  {
    action: 'create',
    email: 'foo@bar.com',
    type: 1,
    first_name: 'Zoomie',
    last_name: 'Userton',
    password: 'testerino'
  }
  ```
  You will instead have to pass:
  ```
  {
    action: 'create',
    user_info: {
      email: 'foo@bar.com',
      type: 1,
      first_name: 'Zoomie',
      last_name: 'Userton',
      password: 'testerino'
    }
  }
  ```
  Zoom API reference for user creation: https://marketplace.zoom.us/docs/api-reference/zoom-api/users/usercreate

### New features
* Greatly simplified new syntax when adding endpoints. This reduces repetition and makes it easier.
* On `user_settings_get`, permit `option` and `custom_query_fields`.
* Add `group_create` and `group_update`.

# 0.11.0

This is the first CHANGELOG entry.

### New features:
* A lot of new endpoints

### Fixes:
* Update README to say `require 'zoom'`
* Fix a typo in the README

### Misc:
* Update gems
* Update bundler to 2.2
* Update Ruby to 2.7
