# Uses the WordPress.org REST API Plugin to get post data from a WordPress.org installation and convert the posts into
# jekyll post files.

require 'json'
require 'net/http'
require 'uri'
require 'reverse_markdown'


# Change these variables to suit your installation and needs.

wordpress_url = 'http://YOUR_SITE_URL/wp-json/wp/v2/posts?per_page=1000'
the_post_author = 'YOUR_NAME'
the_post_category = 'POST_CATEGORY'


def url_open(url)
  Net::HTTP.get(URI.parse(url))
end

page_content = url_open(wordpress_url)
the_posts = JSON.parse(page_content)

puts 'Generating jekyll post files...'

count = 0

# Processing the posts
the_posts.each do |post|
  the_post_id = post['id'] # the unique ID number of the post as known to WordPress
  the_post_datestamp = post['date'] # the day the post was published.
  the_post_slug = post['slug'] # the post slug
  the_post_title = post['title']['rendered'] # the rendered post title
  the_post_content = post['content']['rendered'].split("\n") # the post content, split into new lines.

  # TODO: Get tag and category data from WordPress via API

  # Set the Tag and Category API URLs for later usage

  puts '------------'
  puts "Processing Post ID# #{the_post_id}"

  # Sanitize the date to remove the time of day
  the_clean_date = the_post_datestamp.split('T')[0]

  # Generate the permalink
  s = the_clean_date.split('-')
  y, m, d = s[0], s[1], s[2]
  the_post_permalink = "/#{y}/#{m}/#{d}/#{the_post_slug}/"

  # Create the _posts directory

  system('mkdir', '_posts') unless File.exists?('_posts')

  # Create the .md file
  the_post_file_name = the_clean_date + '-' + the_post_slug + '.md'
  the_post_file = File.new("_posts/#{the_post_file_name}", 'w')

  puts "Created post file #{the_post_file_name}"

  # Write the header data

  puts 'Writing header data to file'

  # Header data should look like this:
  # ---
  # title: Hello World!
  # author: Daniel Seita
  # layout: post
  # permalink: /2011/08/02/hello-world/
  # categories:
  #     - Everything Else
  # ---

  the_post_file.puts('---')
  the_post_file.puts("title: \"#{the_post_title}\"")
  the_post_file.puts("author: #{the_post_author}")
  the_post_file.puts('layout: post')
  the_post_file.puts("permalink: #{the_post_permalink}")
  the_post_file.puts('categories:')
  the_post_file.puts("    - #{the_post_category}")
  # TODO: Add tag capability
  the_post_file.puts('---')
  the_post_file.puts('')

  # Convert the the_post_content from HTML to Markdown
  the_post_markdown = ''
  the_post_content.each do |line|
    line.slice! '<!--more-->'
    converted_line = ReverseMarkdown.convert line
    the_post_markdown << converted_line

  end

  puts 'Writing content data'

  the_post_file.puts(the_post_markdown)

  puts 'Complete. Closing file.'
  the_post_file.close

  puts 'File closed.'
  count += 1
end

puts "Done. #{count} post(s) generated."
