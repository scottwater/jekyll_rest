# Jekyll Rest

Jekyll Rest provide an API end point to write new posts for sites using Jekyll and Github.

It's primary use case is to enable writing posts from your favorite email client or even via SMS. It is probably not for everyone. However, if you are trying to write more outside of walled gardens like Twitter, you may find it useful.

Today, it has a single end point, `create_post`. The create\_post end point does its best to take whatever content is handed to it and create a corresponding file on your git repo.

Here are the basic rules:

1. There must always be a `body` parameter.
1. If the body parameter contains front matter, the title in the front matter is used (if it exists)
1. If there is no front matter (or title) it looks for a title or subject parameter.
1. If the above fails, the content before the first line break is used as the title.
1. And if all else fails, the content before the first period, question mark, or exclamation point is used for the title.

If there is no body and title, no post will be created on Github.

## Set up

You should be able to set it up by clicking the following Heroku button.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)


The following environment variables are available:

* API\_KEY - This is how you authenticate with Jekyll Rest. Using the Heroku button one will be generated for you.
* GITHUB\_API\_KEY - This is the API Key used to authenticate with Github. You can create one on Github with Settings > Developer Settings
* GITHUB\_REPO - What repo do you want to post to.
* GITHUB\_USER - The Github user account (could also be an organization)
* SHORTI\_URL - (optional) - will allow link\_url's found in front matter to be shortened.
* SHORTI\_API\_KEY - (optional) - API Key for Shorti if used.

## API

The only supported end point is a HTTP Post or Put to /create_post.

It just have at a minimum a body parameter. You can also include a repo and user to override the ENV variables

## Emails && SMS

I use Zapier to manage all of this. You can set up an email at Zapier to receive an incoming email and then send a webhook to this project. You can do the same for SMS. Setup Twilio (or your favorite service) to send a web hook to Zapier. In turn, have Zapier send a webhook back here.

## Publishing

Ultimately, this whole thing works much better if you are using Netlify, Github Page, or something else that will trigger a rebuild/publish of your site when a Git push is completed.
