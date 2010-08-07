path = File.expand_path(File.dirname(__FILE__))
$:.unshift(path) unless $:.include?(path)

require "curl/curl"
require "curl/easy"
require "curl/multi"