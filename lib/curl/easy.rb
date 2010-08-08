require "ffi"

module Curl
  class Easy
    attr_reader :pointer

    def initialize
      @pointer = FFI::AutoPointer.new(Curl.easy_init, Curl.method(:easy_cleanup))
    end

    def reset
      Curl.easy_reset(@pointer)
    end

    def initialize_copy(other)
      @pointer = FFI::AutoPointer.new(Curl.easy_duphandle(other.pointer), Curl.method(:easy_cleanup))
    end

    def escape(string)
      str_pointer = Curl.easy_escape(@pointer, string, string.length)
      result = str_pointer.null? ? nil : str_pointer.read_string
      Curl.free(str_pointer)
      result
    end

    def unescape(string)
      int_pointer = FFI::MemoryPointer.new(:int)
      str_pointer = Curl.easy_unescape(@pointer, string, string.length, int_pointer)
      result = str_pointer.read_string(int_pointer.read_int)
      Curl.free(str_pointer)
      result
    end

    def error_string(error_code)
      Curl.easy_strerror(error_code)
    end

    def perform
      check_code(Curl.easy_perform(@pointer))
    end

    def setopt(option, value)
      check_code(Curl.easy_setopt(@pointer, option, value))
    end

    def getinfo(info)
      if info > Curl::INFO_SLIST
        raise "Not implemented yet"
      elsif info > Curl::INFO_DOUBLE
        getinfo_double(info)
      elsif info > Curl::INFO_LONG
        getinfo_long(info)
      elsif info > Curl::INFO_STRING
        getinfo_string(info)
      end
    end

    def perform
      check_code(Curl.easy_perform(@pointer))
    end

    protected
      def check_code(result)
        if result != :OK
          raise "Error - #{result}"
        end
      end

      def getinfo_double(info)
        double_ptr = FFI::MemoryPointer.new(:double)
        check_code(Curl.easy_getinfo(@pointer, info, double_ptr))
        double_ptr.read_double
      end

      def getinfo_string(info)
        pointer = FFI::MemoryPointer.new(:pointer)
        check_code(Curl.easy_getinfo(@pointer, info, pointer))
        string_ptr = pointer.read_pointer
        string_ptr.null? ? nil : string_ptr.read_string
      end

      def getinfo_long(info)
        long_ptr = FFI::MemoryPointer.new(:long)
        check_code(Curl.easy_getinfo(@pointer, info, long_ptr))
        long_ptr.read_long
      end
  end
end