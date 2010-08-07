require "ffi"

module Curl
  class Multi
    attr_reader :pointer, :running

    def initialize
      @pointer = FFI::AutoPointer.new(Curl.multi_init, Curl.method(:multi_cleanup))
      @running = -1
      @messages_in_queue = 0
    end

    # @todo handle return code
    def add_handle(easy)
      Curl.multi_add_handle(@pointer, easy.pointer)
    end

    # @todo handle return code
    def remove_handle(easy)
      Curl.multi_remove_handle(@pointer, easy.pointer)
    end

    def setopt(option, param)
      option = option.is_a?(Symbol) ? Curl::MULTI_OPTION[option] : option

      if option > Curl::OPTION_OFF_T
        Curl.multi_setopt_curl_off_t(@pointer, option, param)
      elsif option > Curl::OPTION_FUNCTIONPOINT
        Curl.multi_setopt_pointer(@pointer, option, param)
      elsif option > Curl::OPTION_OBJECTPOINT
        if param.respond_to?(:to_str)
          Curl.multi_setopt_string(@pointer, option, param.to_str)
        else
          Curl.multi_setopt_pointer(@pointer, option, param)
        end
      elsif option > Curl::OPTION_LONG
        Curl.multi_setopt_long(@pointer, option, param)
      end
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