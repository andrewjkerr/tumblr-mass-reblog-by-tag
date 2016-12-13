# Tumblr Mass Reblog By Tag

A simple script to reblog a number of tagged posts to a Tumblr blog. Uses the [`tumblr_client`](https://github.com/Tumblr/tumblr_client) Ruby gem to make the API calls.

## Installation

1. `bundle install`
2. Move `.env.sample` to `.env` and add the appropriate values. You can get a Tumblr OAuth Token/Token Secret via the [API Console](https://api.tumblr.com/console).

## Usage

```shell
$ ruby mass-reblog.rb --help
Usage: mass-reblog.rb [options]
    -t, --tag TAG                    The tag to draft.
    -b, --blog BLOG                  The URL of the blog to reblog posts to.
    -c, --count COUNT                The number of posts to reblog.
    -p, --post-type POST-TYPE        The posttype to use.
    -a, --add-tags TAG1,TAG2,...     A list of tags to add to a post (comma separated).
    -s, --status status              The status of the reblogged posts.
    -d, --dry-run                    Whether to actually reblog the posts or not (a dry run).
    -h, --help                       Show this help message
```

_Note: you are required to define a tag, blog, and count._

### Example

To __draft 50 "donuts" photo posts__ to the blog __donuts.tumblr.com__ with a number of donut related tags, you would run:

```shell
ruby mass-reblog.rb -t donuts -b donuts.tumblr.com -c 50 -p photo -s draft -a "donut, donuts, doughnut, doughnuts, food porn, munchies, drunk food, yummy, foodgasm, food, delicious"
```


## License

This repository is licensed under the [MIT license](https://github.com/andrewjkerr/tumblr-mass-reblog-by-tag/blob/master/LICENSE.md).

## Disclaimer

This project is my own personal project and not affiliated with Tumblr.

## Contributing

Want to contribute? Great! Here's what you do:

1. Fork this repository
2. Push some code to your fork
3. Come back to this repository and open a PR
4. After some review, get that PR merged to `master`
5. Give yourself a pat on the back; you're awesome!

Feel free to also open an issue with any requests!
