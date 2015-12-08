# WordPress to Jekyll Markdown

By [Johanthan Lyman](http://github.com/jelyman2)

This rather simple Ruby script pings the REST API on a self-hosted WordPress site, gets post data, and converts it 
into `.md` (markdown) files for use in Jekyll blogs.

I build this out of necessity since the Jekyll export plugin for WordPress hasn't worked in many months and I 
couldn't find any easy to use pre-built tools out on the interwebs.

The code is clunky, I'll admit, but it did what I needed it to do and it processed 252 posts in less than 10 seconds.
 Not bad for a couple hours work, if you ask me.

## Requirements

- A WordPress.org installation
- The WP REST API plugin installed and active
- `Bundler`

## Usage

- Run `bundle install`
- Open `wpjekyll.rb` and edit the three variables at the top of the file: `wordpress_url`, `the_post_author`, and 
`the_post_category`.

## TODO

- Get categories dynamically via the API
- Get tags dynamically via the API
- Take limit argument
- Take URL argument
- Take Author Argument
- Get author dynamically via the API
- rspec tests
- Catch HTTP errors
- Verbosity argument
- MAJOR REFACTORING

## LICENSE

This code is covered under the MIT License.