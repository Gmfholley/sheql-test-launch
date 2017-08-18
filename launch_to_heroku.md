## Launching your app to Heroku

1. Git Add and Git Commit everything on master
1. Push master back to GitHub
1. Teacher will run command `heroku create name-of-app` and the app will be created.  Write down the entire domain of the new app.
1. If Google Auth is set up, go back to [developer's console](https://console.developers.google.com) and add the new domain + '/authenticated' as an Authorized redirect URI.
 REDOWNLOAD your client_secrets.json file after you updated your account.
   - NOTE: you must hit Save after you add the new URI, and if it doesn't redirect you out of the redirect URI screen when you hit Save, it isn't really saved.
1. Push your repo to Heroku
`git push heroku master` => Why does this work?  Because your teacher added `heroku` as a remote repository, just like GitHub is a remote repository.  So now that it is created, you can push.
1. Set environmental variable for client secrets.  
In command line, type:

`heroku config:set CLIENT_SECRETS='` and then paste the entire content of your `client_secrets.json` file and end your single quote.  You must use single quotes around our CLIENT_SECRETS, not double quotes.  Do you not add anything else.  An example might look like:

```
  $ heroku config:set CLIENT_SECRETS='{"web":{"client_id":"long-id.apps.googleusercontent.com","project_id":"sheql-175101","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://accounts.google.com/o/oauth2/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_secret":"some-secret-string","redirect_uris":["https://test-gmfholley.c9users.io/authenticated","http://localhost:4567/authenticated","https://sheql-test.herokuapp.com/authenticated"]}}'

```

Your app should be running.

## Steps taken prior to this launch

1. config.ru file was added to the root to let Heroku know what to run.
1. The `unless no_authentication?` block in `app.rb` was modified to alternatively load secrets from an environmental variable.

```
  # set up authorization
  unless no_authentication?
    Google::Apis::ClientOptions.default.application_name = 'SheQL'
    Google::Apis::ClientOptions.default.application_version = '1.0.0'

    ## This is the line that changes
    client_secrets = Google::APICLientSecrets.load rescue Google::APIClient::ClientSecrets.new(JSON.parse(ENV['CLIENT_SECRETS']))

    ## all other lines stay the same
    authorization = client_secrets.to_authorization
    authorization.scope = 'openid email profile'

    set :authorization, authorization
  end

```
