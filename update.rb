require 'pp'
require 'json'
require 'securerandom'
require 'httparty'
require 'sequel'
require 'env'

COOKIE = ENV.fetch("COOKIE")
DB_PATH = ENV.fetch("DB_PATH")

module ClassDojo
  class Requester
    attr_reader :href

    def initialize(href)
      @href = href
    end

    def get
      return ResponseTranslator.new([]) if href.nil?
      response = HTTParty.get(href, format: :plain, headers: {"Cookie" => COOKIE})
      json = JSON.parse(response, symbolize_names: true)

      ResponseTranslator.new(json)
    end
  end

  class Attachment
    attr_reader :href

    def initialize(href)
      @href = href
    end

    def suffix(content_type)
      case content_type
      when "image/jpeg"
        "jpeg"
      when "image/gif"
        "gif"
      when "image/png"
        "png"
      when "video/mp4"
        "mp4"
      else
        puts "Unknown content_type #{content_type}"
        ""
      end

    end

    def get
      response = HTTParty.get(href, stream_body: true, headers: {"Cookie" => COOKIE})
      suffix = suffix(response.headers.content_type)

      filename = File.join('downloads', "#{SecureRandom.uuid}.#{suffix}")

      File.open(filename, "w") do |file|
        file.binmode
        file.write(response.body)
      end

      filename
    end
  end

  class ResponseTranslator
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def links
      source[:_links]
    end

    def next_link
      return nil if links.empty?
      links[:prev][:href]
    end

    def next_requester
      Requester.new(next_link)
    end

    def items
      source[:_items].map{ |item| ItemTranslator.new(item) }
    end

    def to_json
      items.map(&:to_json)
    end

    def empty?
      source.empty? || items.empty?
    end
  end

  class ItemTranslator
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def format_attachment(attachment_json)
      {
        path: attachment_json[:path],
        type: attachment_json[:type]
      }
    end

    def to_s
      "<ItemTranslator date=#{source[:time]}>"
    end

    def to_json
      contents = source[:contents]
      attachments = contents[:attachments]
      {
        id: source[:_id],
        time: source[:time],
        headerText: source[:headerText],
        headerSubtext: source[:headerSubtext],
        contents: {
          body: contents[:body],
          attachments: attachments.map{|attachment| format_attachment(attachment) }
        }
      }
    end
  end
end

class Db
  attr_reader :db

  def initialize(filename)
    @db = Sequel.sqlite(filename)
  end

  def setup_db!
    db.create_table :attachments do
      primary_key :id
      foreign_key :item_id, :items
      String :url
      String :type
      String :path
    end

    db.create_table :items do
      primary_key :id
      String :classdojo_id
      String :time, null: false
      String :headerText
      String :headerSubtext
      String :contents
      String :body
    end
  end

  def pull_attachment(url)
    ClassDojo::Attachment.new(url).get
  end

  def attachment_exists?(url)
    db[:attachments].where(url: url).count > 0
  end

  def create_attachment(item_id, attachment_json)
    url = attachment_json[:path]
    type = attachment_json[:type]
    filename = pull_attachment(url)

    return if attachment_exists?(url)

    db[:attachments].insert(item_id: item_id, url: url, type: type, path: filename)
  end

  def item_exists?(picture_json)
    db[:items].where(classdojo_id: picture_json[:id]).count > 0
  end

  def create_item(picture_json)
    classdojo_id  = picture_json[:id]
    time          = picture_json[:time]
    headerText    = picture_json[:headerText]
    headerSubtext = picture_json[:headerSubtext]
    body          = picture_json[:contents][:body]
    attachments   = picture_json[:contents][:attachments]

    item_id = db[:items].insert(classdojo_id: classdojo_id,
                                time: time,
                                headerText: headerText,
                                headerSubtext: headerSubtext,
                                body: body)

    attachments.each do |attachment|
      create_attachment(item_id, attachment)
    end
  end
end

db = Db.new(DB_PATH)
# To create the database schema
#db.setup_db!

response = ClassDojo::Requester.new('https://home.classdojo.com/api/storyFeed?includePrivate=true').get
until response.empty?
  response.items.each do |item|
    if db.item_exists? item.to_json
      puts "Up to date!"
      exit
    end

    puts "Creating #{item}..."
    db.create_item(item.to_json)
  end
  response = response.next_requester.get
end
