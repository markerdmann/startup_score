require 'nokogiri'
require 'open-uri'
require 'cgi'
require 'json'

class Parser
  def self.score(url)
      doc = Nokogiri::HTML(open(url))
      scores = doc.css('.founder .profile-link').map do |founder|
          query = CGI.escape("\"#{founder.text}\" profile site:github.com")
          url = "http://www.google.com/search?q=#{query}"
          html = open(url).read
          name = (html.match(%r{github.com/(\w+)})||[])[1]
          next unless name
          res = JSON.load(open("https://github.com/api/v2/json/user/show/#{name}").read) rescue next
          follower_count = res['user']['followers_count'].to_i
          repo_count = res['user']['public_repo_count'].to_i
          score = follower_count + repo_count
          [score, name, founder.text]
      end.compact
      scores.sort!
      scores.map {|s| s[0] }.inject(:+)
  end
end