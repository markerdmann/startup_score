#!/usr/bin/env ruby
require './environment'

page = 1
loop do
  doc = Nokogiri::HTML(open("http://angel.co/startups?page=#{page}"))
  links = doc.css('.name a')
  break if links.empty?
  p page
  score_sum = 0
  #scores = Parallel.map(links, :in_threads => 10) do |link|
  scores = links.map do |link|
      url = link.attributes['href'].value
      p url
      score = Parser.score(url)
      score_sum += score
      {:name => link.text, :score => score, :url => url}
  end
  scores.each do |attrs|
    unless startup = Startup.find_by_url(attrs[:url])
      startup = Startup.new
    end
    startup.attributes = attrs
    startup.save
  end
  raise "game over" if score_sum == 0
  page += 1
end