require "rubygems"
require "lib/curl"

multi = Curl::Multi.new

e = Curl::Easy.new
e.setopt(Curl::OPTION[:PROXY], "")
e.setopt(Curl::OPTION[:VERBOSE], 1)
e.setopt(Curl::OPTION[:URL], "http://www.un.org")

multi.add_handle(e)


e = Curl::Easy.new
e.setopt(Curl::OPTION[:PROXY], "")
e.setopt(Curl::OPTION[:VERBOSE], 1)
e.setopt(Curl::OPTION[:URL], "http://www.google.com")

multi.add_handle(e)

begin
  multi.perform
end while multi.running != 0