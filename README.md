<div align="center">

![Logo](https://raw.githubusercontent.com/cokgay/icons/main/webp/cokdotgay-nobg.webp)

# Me

Source code of the https://me.cok.gay/ back-end.

</div>

## Contents

- [Information](#information)
  - [About](#about)
  - [Reference](#reference)
- [Host with Podman](#host-with-podman)
- [Theme Options](#theme-options)
- [API Docs](#api-docs)
  - [Create User](#create-user)
  - [Auth User](#auth-user)
  - [About User](#about-user)
  - [Edit User](#edit-user)

## Information

### About

Me is a platform for making an one-page app for your links and biography. Me allows you to create one-page websites for yourself and comes with themes.

### Reference

- [Lanyard](https://github.com/Phineas/lanyard) for tracking discord accounts real-time.
- [CloudFlare Turnstile](https://www.cloudflare.com/en-gb/products/turnstile/) for human verifying.
- [Icones](https://icones.js.org/) and [Simple Icons](https://simpleicons.org/) for icons.
- All the libraries we use can be found in `mix.exs` file

## Host with Podman

Use podman to host cokgay/me yourself.

```shell
git clone https://github.com/cokgay/me.git
cd me

podman build -t me .
podman run -p 4201:4201 me
```

Server runs on port `4201`.

## Theme Options

We currently support 5 total options for simple theming. Themes only use what they need.

- `backgroundUrl`
  - Allows you to edit background image in a theme. Made for `ArtBox` and `MacOs` theme. You must give a valid url for option. Otherwise it will not work.
- `backgroundColor`, `secondaryColor`, `thirdColor` and `foregroundColor`
  - Allows you to edit theme colors. Accepts any valid color value like `#fff` or `rgb(255, 0, 255)`.

## API Docs

You can access to public api with using url https://me.cok.gay/api/ as prefix.

You may see something like `GET /example -> 400:JSON | 200`.

- `GET` is a method, it can be also `POST`, `PATCH` etc...
- `/example` is the path. You should send a request with prefix, so url becomes https://me.cok.gay/api/example.
- `->` is a way to refer response status code. The syntax is like `-> <status code>[:encoding] | <another status code>` where `|` means or. In this example it says _"responses with status code 400 (bad request with json response) or 200 (ok)"_
- `where` is a way to describe what status code means.

### Create User

```
POST /create -> 400:TEXT | 403:TEXT | 200:TEXT

where 400 -> it returns a text that describes whats wrong in request.

where 403 -> invalid cloudflare turnstile token.

where 200 -> user created without any error. It returns created user's token as text.
```

Request must contain a body with values for `username`, `password` and `cf-turnstile-response`. You can use json or any other valid format for request.

```json
{
  "username": "example",
  "password": "example password",
  "cf-turnstile-response": "token returned from turstile"
}
```

### Auth User

```
POST /auth -> 400:TEXT | 404:TEXT | 403:TEXT | 200:TEXT

where 400 -> it returns a text that describes whats wrong in request.

where 404 -> user not found.

where 403 -> invalid username or password.

where 200 -> it returns token as text.
```

Request must contain a body with values for `username` and `password`.

```json
{
  "username": "example",
  "password": "example password"
}
```

### About User

```
POST /about -> 400:TEXT | 404:TEXT | 200:JSON

where 400 -> it returns a text that describes whats wrong in request.

where 404 -> user not found.

where 200 -> it returns user information as json.
```

Request must contain a body with values for `username` **OR** `token`. A request with `token` will return user struct and user view without `password` value. A request with `username` will return user view information that contains about, links, lanyard id etc...

With username:

```json
{
  "username": "cart96"
}
```

With token:

```json
{
  "token": "secret token"
}
```

### Edit User

```
PATCH /edit -> 400:TEXT | 404:TEXT | 204:EMPTY

where 400 -> it returns a text that describes whats wrong in request

where 404 -> user not found

where 204 -> success
```

Request template must be like this. new data will replaced with the old one:

```json
{
  "token": "secret token",
  "data": {
    "about": "welcome to my page.",
    "lanyard_id": "1013270483560579165",
    "theme": "ArtBox",
    "theme_options": {
      "secondaryColor": "#00f"
    },
    "links": [
      {
        "display": "Website",
        "title": "Example",
        "url": "https://example.com"
      }
    ]
  }
}
```

## License

cokgay/me is licensed under the AGPL-3.0 License.
