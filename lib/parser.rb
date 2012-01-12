require 'nokogiri'
require 'open-uri'
require 'cgi'
require 'json'

class Parser
  def self.score(url)
      doc = Nokogiri::HTML(open(url))
      names = doc.css('.founder a.linkedin').map do |el|
        (el['href'].match(%r{linkedin.com/in/(\w+)})||[])[1]
      end.compact
      names << (url.match(%r{angel.co/([0-9a-zA-Z-]+)})||[])[1]
      p names
      scores = names.map do |name|
          res = JSON.load(open("https://github.com/api/v2/json/user/show/#{name}").read) rescue next
          follower_count = res['user']['followers_count'].to_i
          repos = JSON.load(open("https://github.com/api/v2/json/repos/show/#{name}").read) rescue next
          score = follower_count
          repos['repositories'].each do |repo|
            score += repo['watchers']
          end
          [score, name]
      end.compact
      scores.sort!
      p scores
      scores.map {|s| s[0] }.inject(:+) || 0
  end
end

#Parser.score('http://angel.co/genomera')
#Parser.score('http://angel.co/tout')