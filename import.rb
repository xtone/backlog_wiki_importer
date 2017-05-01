require 'faraday'
require 'optparse'
require 'pp'

endpoint = ENV['BACKLOG_ENDPOINT']
api_key = ENV['BACKLOG_API_KEY']
project_id = ENV['BACKLOG_PROJECT_ID'].to_i

class Importer
  attr_accessor :client, :dir_path, :files
  
  def initialize(client, dir_path)
    @client = client
    @dir_path = dir_path
    @files = Dir.glob File.join(dir_path, '**/*.md')
  end

  def import(dry_run: true)
    @files.each do |file|
      wiki_name = file.gsub(/\A#{dir_path}/, '').gsub(/\.md\Z/, '')

      if dry_run
        p "[#{Time.now} #{wiki_name} => success! (dry_run)"
        next
      end

      response = client.create_wiki(wiki_name, File.read(file))
      print "[#{Time.now} #{wiki_name} => "
      case response.status
      when 201
        # success
        p 'success!'
      else
        # fail
        p "failure with status: #{response.status}."
      end
    end
  end
end

class Client
  def initialize(api_key, project_id, endpoint)
    @api_key = api_key
    @project_id = project_id
    @endpoint = endpoint

    @connection = Faraday.new url: "https://#{@endpoint}" do |faraday|
      faraday.request  :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end

  def create_wiki(name, content)
    params = {
      projectId: @project_id,
      name: name,
      content: content,
      mailNotify: false
    }

    path = "/api/v2/wikis?apiKey=#{@api_key}"

    res = @connection.post do |req|
      req.url path
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.body = params
    end

    res
  end
end

params = ARGV.getopts('', 'dryrun', 'path:md_source_dir')

if params['path'] == 'md_source_dir'
  puts "Usage: bundle exec ruby #{$0} [-d] -p md_source_dir"
  exit 1
end

p "ENDPOINT: #{endpoint}"
p "API_KEY: #{api_key}"
p "PROJECT_ID: #{project_id}"

client = Client.new api_key, project_id, endpoint
importer = Importer.new client, params['path']
importer.import(dry_run: params['dryrun'])
