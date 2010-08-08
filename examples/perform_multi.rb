require "rubygems"

require File.expand_path("../lib/curl", File.dirname(__FILE__))

multi = Curl::Multi.new

e = Curl::Easy.new
e.setopt(:PROXY, "")
e.setopt(:URL, "http://www.un.org")

multi.add_handle(e)


e = Curl::Easy.new
e.setopt(:PROXY, "")
e.setopt(:URL, "http://www.google.com")

multi.add_handle(e)

begin
  multi.perform
end while multi.running != 0