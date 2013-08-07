require 'singleton'
require 'launchy'
require 'oauth'
require 'yaml'
require 'json'


class TwitterSession

  attr_reader :access_token

  include Singleton
  AUTHORIZE_URL = "https://api.twitter.com/oauth/authorize"
  CONSUMER_KEY = "KHkmsVTe2EiOn4Tukzmg"
  CONSUMER_SECRET = "LP35aqEcZoSgGwTGrhTJIKaZtfZW17KyYmMitBM5vw"
  CONSUMER = OAuth::Consumer.new(
    CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")

  def initialize
    @access_token = get_token
  end

  def self.current_user
    self.instance.access_token.params[:screen_name]
  end

  def self.get(*args)
    self.instance.access_token.get(*args)
  end

  def self.post(*args)
    self.instance.access_token.post(*args)
  end


  def request_access_token
    request_token = CONSUMER.get_request_token
    authorize_url = request_token.authorize_url
    puts "Go to this URL: #{authorize_url}"
    # launchy is a gem that opens a browser tab for us
    Launchy.open(authorize_url)

    puts "Login, and type your verification code in"
    oauth_verifier = gets.chomp

    access_token = request_token.get_access_token(
      :oauth_verifier => oauth_verifier
    )
  end

  def get_token
    # We can serialize token to a file, so that future requests don't need
    # to be reauthorized.
    token_file = "lib/assets/token_file.yml"
    if File.exist?(token_file) # if already authorized Twatter Tweeter
      File.open(token_file) { |f| YAML.load(f) }
    else # if the first time authorizing Twatter Tweeter
      access_token = request_access_token
      File.open(token_file, "w") { |f| YAML.dump(access_token, f) }

      access_token
    end
  end


  def user_timeline
    # the access token class has methods `get` and `post` to make
    # requests in the same way as RestClient, except that these will be
    # authorized. The token takes care of the crypto for us :-)
    body  = @access_token.get("http://api.twitter.com/1.1/statuses/user_timeline.json").body
    JSON.parse(body)
  end
end

