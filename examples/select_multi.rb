# Shows how to use the libcurl-ffi interface in combination with eventmachine.
# Inspired by the different hiperfifo examples on the libcurl site.
require "rubygems"
require "benchmark"
require "eventmachine"

require File.expand_path("../lib/curl", File.dirname(__FILE__))

if FFI::Platform.windows?
  # Sockets returned by curl are WinSock SOCKETs
  # As we want to wrap these sockets in Ruby's IO interface (using IO.for_fd),
  # we have to first get the SOCKET's filehandle using _get_osfhandle.
  #
  # To later get the SOCKET again, we can use _open_osfhandle again.
  module WinSock
    extend FFI::Library
    ffi_lib FFI::Library::LIBC
    attach_function :_get_osfhandle, [:int], :long
    attach_function :_open_osfhandle, [:long, :int], :int
  end

  def get_socket(io)
    WinSock._get_osfhandle(io.fileno)
  end

  def get_io(socket)
    FFI::IO.for_fd(WinSock._open_osfhandle(socket, 0), "r")
  end
else
  def get_socket(io)
    io.fileno
  end

  def get_io(socket)
    IO.for_fd(socket, "r")
  end
end

$sockets = { }

def addsock(socket, easy, action)
  io = get_io(socket)
  $sockets[socket] = {
    :io => io,
    :action => action,
  }
  setsock(socket, easy, action)
end

def setsock(socket, easy, action)
  $sockets[socket][:action] = action
end

def remsock(socket)
  puts "Removing Socket #{socket}"
  $sockets.delete(socket)
end

def progress_callback(url_pointer, dltotal, dlnow, ultotal, ulnow)
  puts "[#{Time.now}]Progress: %s (%g/%g)\n" % [url_pointer.read_string, dlnow, dltotal]
  return 0
end

def write_callback(easy, size, nmemb, data)
  realsize = size * nmemb
  return realsize
end

def mcode_or_die(where, code)
  return if code == :OK
  puts "ERROR: %s returns %s\n" % [where, code]
  exit unless code == :BAD_SOCKET
end

PROGRESS_CALLBACK = FFI::Function.new(:int, [:pointer, :double, :double, :double, :double], &self.method(:progress_callback))
WRITE_CALLBACK = FFI::Function.new(:size_t, [:pointer, :size_t, :size_t, :pointer], &self.method(:write_callback))

sock_callback = FFI::Function.new(:int, [:pointer, :int, :int]) do |easy_ptr, socket, what|
  whatstr = [ "none", "IN", "OUT", "INOUT", "REMOVE" ]
  puts("socket callback: s=%d e=%p what=%s " % [socket, easy_ptr, whatstr[what]])

  if what == 4
    remsock(socket)
    puts ""
  else
    if $sockets[socket].nil?
      puts "Adding data: %s\n" % whatstr[what]
      addsock(socket, easy_ptr, what)
    else
      puts "Changing action from %s to %s\n" % [whatstr[$sockets[socket][:action]], whatstr[what]]
      setsock(socket, easy_ptr, what)
    end
  end

  0
end

multi_timer_callback = FFI::Function.new(:int, [:pointer, :long]) do |multi_ptr, timeout_ms|
  puts "multi_timer_cb: Setting timeout to %d ms\n" % timeout_ms

  $timeout = timeout_ms

  0
end

$prev_running = 0
def check_run_count
  if $prev_running > $multi.running
    puts "REMAINING: %d\n" % $multi.running

    while message = $multi.info_read_next
      if message[:msg] == :DONE
        puts "Done!"
      end
    end
  end
  $prev_running = $multi.running
end

$timeout = 0
$multi = Curl::Multi.new
$multi.setopt(:SOCKETFUNCTION, sock_callback)
$multi.setopt(:TIMERFUNCTION, multi_timer_callback)

[ "http://www.microsoft.com",
  "http://www.opensource.org",
  "http://www.google.com",
  "http://www.yahoo.com",
  "http://www.ibm.com",
  "http://www.mysql.com",
  "http://www.oracle.com",
  "http://www.ripe.net",
  "http://www.iana.org",
  "http://www.amazon.com",
  "http://www.netcraft.com",
  "http://www.heise.de",
  "http://www.chip.de",
  "http://www.ca.com",
  "http://www.cnet.com",
  "http://www.news.com",
  "http://www.cnn.com",
  "http://www.wikipedia.org",
  "http://www.dell.com",
  "http://www.hp.com",
  "http://www.cert.org",
  "http://www.mit.edu",
  "http://www.nist.gov",
  "http://www.ebay.com",
  "http://www.playstation.com",
  "http://www.uefa.com",
  "http://www.ieee.org",
  "http://www.apple.com",
  "http://www.sony.com",
  "http://www.symantec.com",
  "http://www.zdnet.com",
  "http://www.fujitsu.com",
  "http://www.supermicro.com",
  "http://www.hotmail.com",
  "http://www.ecma.com",
  "http://www.bbc.co.uk",
  "http://news.google.com",
  "http://www.foxnews.com",
  "http://www.msn.com",
  "http://www.wired.com",
  "http://www.sky.com",
  "http://www.usatoday.com",
  "http://www.cbs.com",
  "http://www.nbc.com",
  "http://slashdot.org",
  "http://www.bloglines.com",
  "http://www.techweb.com",
  "http://www.newslink.org" ].each do |url|
    e = Curl::Easy.new
    e.setopt(:PROXY, "")
    e.setopt(:URL, url)
    e.setopt(:NOPROGRESS, 0)
    e.setopt(:PROGRESSFUNCTION, PROGRESS_CALLBACK)
    e.setopt(:WRITEFUNCTION, WRITE_CALLBACK)
    e.setopt(:PROGRESSDATA, url)
    $multi.add_handle(e)
end

begin
  to_read = $sockets.select { |k, v| v[:action] & 1 != 0 }.map { |x| x[1][:io] }
  to_write = $sockets.select { |k, v| v[:action] & 2 != 0 }.map { |x| x[1][:io] }

  read, write, err = IO.select(to_read, to_write, [], $timeout / 1000.0)

  if read
    read.each do |io|
      begin
        rc = $multi.socket_action(get_socket(io), 1)
      end while rc == :CALL_MULTI_PERFORM
      mcode_or_die("event_cb: curl_multi_socket", rc)
      check_run_count
    end
  end

  if write
    write.each do |io|
      begin
        rc = $multi.socket_action(get_socket(io), 2)
      end while rc == :CALL_MULTI_PERFORM
      mcode_or_die("event_cb: curl_multi_socket", rc)
      check_run_count
    end
  end

  if !read && !write
    puts "!!! Socket timeout"
    begin
      rc = $multi.socket_action(Curl::SOCKET_TIMEOUT, 0)
      puts rc
    end while rc == :CALL_MULTI_PERFORM
    mcode_or_die("timer_cb: curl_multi_socket_action", rc)
    check_run_count
  end

end while $multi.running > 0