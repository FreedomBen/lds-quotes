#!/usr/bin/ruby

require 'nokogiri'

(1..52).each do |index|
  f = Nokogiri::HTML(File.open("p#{index}.html"))
  out = File.open("p#{index}.out", 'w')
  f.css(".quotes_row td").each do |q|
    quote = q.text.split("\n").first
    author = q.css('.quotes_author').text
    source = q.css('.quotes_source').text
    outline = "#{quote}  #{author}"
    outline += ", #{source}" unless source.empty?
    outline += "\n"
    # outline = outline.encode(Encoding::US_ASCII)
    out.write(outline) unless outline.gsub(/\s/, '').gsub(/,/, '').empty?
    # puts "Line contains non-ascii" unless outline.ascii_only?
  end
  out.close()
end
