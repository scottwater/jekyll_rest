# Jekyll Rest

Jekyll Rest provide an API end point to write new posts for sites using Jekyll and Github.

It's primary use case is to enable automating content creation. It is probably not for everyone. However, if you are trying to write more outside of walled gardens like Twitter, you may find it useful.

Today, it has a single end point, `create_post`. The create\_post end point does its best to take whatever content is handed to it and create a corresponding file on your git repo.

## Content Rules

1. There must always be a `body` parameter.
1. If the body parameter contains front matter, the title in the front matter is used (if it exists)
1. If there is no front matter (or title) it looks for a title or subject parameter.
1. If the above fails, the content before the first line break is used as the title.
1. And if all else fails, the content before the first period, question mark, or exclamation point is used for the title.

If there is no body and title, no post will be created on Github.

## API Semantics

1. multipart/form-data is the assumed content type
1. If the Content-Type header is set to `application/json` a JSON document may be submitted
1. The API will respond to both POST and Put
1. Any extra parameters will be added to the front matter.
1. A status code of 201 means the post was created.
1. The response body will contain the post (front matter and content) that was sent to Github

## Set up

You should be able to set it up by clicking the following Heroku button.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

The following environment variables are available:

* API\_KEY - This is how you authenticate with Jekyll Rest. Using the Heroku button one will be generated for you.
* GITHUB\_API\_KEY - This is the API Key used to authenticate with Github. You can create one on Github with Settings > Developer Settings
* GITHUB\_REPO - What repo do you want to post to.
* GITHUB\_USER - The Github user account (could also be an organization)

## Emails && SMS

I use Zapier to manage all of this. You can set up an email at Zapier to receive an incoming email and then send a webhook to this project. You can do the same for SMS. Setup Twilio (or your favorite service) to send a web hook to Zapier. In turn, have Zapier send a webhook back here.

## Publishing

Ultimately, this whole thing works much better if you are using Netlify, Github Page, or something else that will trigger a rebuild/publish of your site when a Git push is completed.

## Testing

1. Clone the project
1. `bundle install`
1. `bundle exec rspec`

## Assets

Right now there is no support for assets. I would love to see this added in the future. As I understand it, you can only submit one file at a time to the Github API which was one of the reasons I did not tackle this from the start.
