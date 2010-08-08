require "ffi"

module Curl
  class Multi
    attr_reader :pointer, :running

    def initialize
      @pointer = FFI::AutoPointer.new(Curl.multi_init, Curl.method(:multi_cleanup))
      @running = -1
      @handles = []
      @messages_in_queue = 0
    end

    # @todo handle return code
    def add_handle(easy)
      Curl.multi_add_handle(@pointer, easy.pointer)
      @handles << easy # Save the handle so it won't be gc'ed
    end

    # @todo handle return code
    def remove_handle(easy)
      Curl.multi_remove_handle(@pointer, easy.pointer)
      @handles.delete(easy) # Save the handle so it won't be gc'ed
    end

    def setopt(option, param)
      Curl.multi_setopt(@pointer, option, param)
    end

    def info_read_all()
      messages = []
      while message = info_read_next
        messages << message
      end
      messages
    end

    def info_read_next()
      int_pointer = FFI::MemoryPointer.new(:int)
      message_pointer = Curl.multi_info_read(@pointer, int_pointer)
      @messages_in_queue = int_pointer.read_int
      message_pointer.null? ? nil : Curl::Message.new(message_pointer)
    end

    # @todo handle return code
    def socket_action(sockfd, ev_bitmask = 0)
      int_pointer = FFI::MemoryPointer.new(:int)
      result = Curl.multi_socket_action(@pointer, sockfd, ev_bitmask, int_pointer)
      @running = int_pointer.read_int
      result
    end

    def perform()
      int_pointer = FFI::MemoryPointer.new(:int)
      result = Curl.multi_perform(@pointer, int_pointer)
      @running = int_pointer.read_int
      result
    end

    def timeout
      long_pointer = FFI::MemoryPointer.new(:long)
      result = Curl.multi_timeout(@pointer, long_pointer)
      long_pointer.read_long
    end
  end
end