require 'dotenv'
require 'optparse'
require 'tumblr_client'

#####
# FUNCTIONS
#####
# Initalize the Tumblr client
#
# @return Tumblr::Client the Tumblr client to make requests with
def init_client
  # Load our env variables
  Dotenv.load

  # Get dat Tumblr client
  return Tumblr::Client.new({
    consumer_key: ENV['TUMBLR_CONSUMER_KEY'],
    consumer_secret: ENV['TUMBLR_CONSUMER_SECRET'],
    oauth_token: ENV['TUMBLR_OAUTH_TOKEN'],
    oauth_token_secret: ENV['TUMBLR_OAUTH_TOKEN_SECRET']
  })
end

# Parses command line options using OptionParse
#
# @return Hash
def parse_options
  options = {}

  OptionParser.new do |opts|
    opts.banner = "Usage: mass-reblog.rb [options]"

    opts.on('-t', '--tag TAG', 'The tag to draft.') do |t|
      options[:tag] = t
    end

    opts.on('-b', '--blog BLOG', 'The URL of the blog to reblog posts to.') do |b|
      options[:blog] = b
    end

    opts.on('-c', '--count COUNT', Integer, 'The number of posts to reblog.') do |c|
      options[:count] = c
    end

    opts.on('-p', '--post-type POST-TYPE', 'The posttype to use.') do |pt|
      options[:type] = pt
    end

    opts.on('-a', '--add-tags TAG1,TAG2,...', 'A list of tags to add to a post (comma separated).') do |at|
      options[:tags_to_add] = at
    end

    opts.on('-s', '--status status', 'The status of the reblogged posts.') do |s|
      options[:status] = s
    end

    opts.on('-d', '--dry-run', 'Whether to actually reblog the posts or not (a dry run).') do |d|
      options[:dry] = true
    end

    opts.on('-h', '--help', 'Show this help message') do ||
      puts opts
      exit
    end
  end.parse!

  unless valid_options?(options)
    puts "Invalid usage! A tag, blog URL, and count are required."
    exit
  end

  return normalize_options(options)
end

# Validates the script options.
#
# @TODO: Validate valid post type
# @TODO: Validate valid status
#
# @param Hash options the options hash
# @return Bool are the current options valid?
def valid_options?(options)
  return (!(options[:tag].nil? || options[:blog].nil? || options[:count].nil?))
end

# Normalizes options that were not set by the user.
#
# @param Hash options the options hash
# @return Hash the normalized options
def normalize_options(options)
  options[:status] = 'published' if options[:status].nil?
  return options
end

# Fetches the tagged posts from Tumblr via the API
#
# @param String tag the tag to query from
# @param String|nil timestamp select posts "before" this timestamp
# @return Array an array of tagged posts
def tagged_posts(tag, timestamp = nil)
  if timestamp.nil?
    tagged = @client.tagged(tag)
  else
    tagged = @client.tagged(tag,
      before: timestamp
    )
  end
end

# Reblogs a post to the selected blog
#
# @param Tumblr::Post post the post to draft
# @param Hash options the post options
# @return Boolean whether the post was successfully reblogged to drafts
def reblog_post(post, options)
  @client.reblog(options[:blog],
    id: post['id'],
    reblog_key: post['reblog_key'],
    state: options[:status],
    tags: options[:tags_to_add]
  )
end

#####
# SCRIPT START
#####
@client = init_client
options = parse_options

tagged = tagged_posts(options[:tag])

current_count = 0

# Fetch tagged posts & reblog the ones we want!
while true do
  tagged.each do |post|
    next if (!options[:type].nil? && (post['type'] != options[:type]))
    reblog_post(post, options) unless options[:dry]

    # Add to count and check if count is reached
    current_count += 1
    break if current_count >= options[:count]
  end

  break if current_count >= options[:count]

  puts "Fetching new page... currently #{current_count}/#{options[:count]}"
  tagged = tagged_posts(options[:tag], tagged.last['timestamp'])
end

puts "Done!"
