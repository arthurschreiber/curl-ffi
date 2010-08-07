require 'ffi'

module Curl
  extend FFI::Library
  ffi_lib "libcurl"

  if FFI::Platform.windows?
    typedef :uint, :curl_socket_t
  else
    typedef :int, :curl_socket_t
  end

  # @todo This might have to be changed for different systems
  typedef :long_long, :curl_off_t

  CODE = enum :code, [
    :OK,                        0,
    :UNSUPPORTED_PROTOCOL,      1,
    :FAILED_INIT,               2,
    :URL_MALFORMAT,             3,

    :COULDNT_RESOLVE_PROXY,     5,
    :COULDNT_RESOLVE_HOST,      6,
    :COULDNT_CONNECT,           7,
    :FTP_WEIRD_SERVER_REPLY,    8,

    # a service was denied by the server due to lack of access when login fails this is not returned.
    :REMOTE_ACCESS_DENIED,      9,

    :FTP_WEIRD_PASS_REPLY,      11,
    :FTP_WEIRD_PASV_REPLY,      13,
    :FTP_WEIRD_227_FORMAT,      14,
    :FTP_CANT_GET_HOST,         15,
    :FTP_COULDNT_SET_TYPE,      17,
    :PARTIAL_FILE,              18,
    :FTP_COULDNT_RETR_FILE,     19,
    # quote command failure
    :QUOTE_ERROR,               21,
    :HTTP_RETURNED_ERROR,       22,
    :WRITE_ERROR,               23,
    # failed upload "command"
    :UPLOAD_FAILED,             25,
    # couldn't open/read from file
    :READ_ERROR,                26,
    # Note: :OUT_OF_MEMORY may sometimes indicate a conversion error
    #       instead of a memory allocation error if CURL_DOES_CONVERSIONS
    #       is defined
    :OUT_OF_MEMORY,             27,

    :OPERATION_TIMEDOUT,        28,
    :FTP_PORT_FAILED,           30,
    :FTP_COULDNT_USE_REST,      31,
    :RANGE_ERROR,               33,
    :HTTP_POST_ERROR,           34,
    :SSL_CONNECT_ERROR,         35,
    :BAD_DOWNLOAD_RESUME,       36,
    :FILE_COULDNT_READ_FILE,    37,
    :LDAP_CANNOT_BIND,          38,
    :LDAP_SEARCH_FAILED,        39,
    :FUNCTION_NOT_FOUND,        41,
    :ABORTED_BY_CALLBACK,       42,
    :BAD_FUNCTION_ARGUMENT,     43,
    :INTERFACE_FAILED,          45,
    :TOO_MANY_REDIRECTS,        47,
    :UNKNOWN_TELNET_OPTION,     48,
    :TELNET_OPTION_SYNTAX,      49,
    # peer's certificate or fingerprint wasn't verified fine
    :PEER_FAILED_VERIFICATION,  51,

    # when this is a specific error
    :GOT_NOTHING,               52,
    # SSL crypto engine not found
    :SSL_ENGINE_NOTFOUND,       53,
    # can not set SSL crypto engine as default
    :SSL_ENGINE_SETFAILED,      54,

    # failed sending network data
    :SEND_ERROR,                55,
    # failure in receiving network data
    :RECV_ERROR,                56,
    # problem with the local certificate
    :SSL_CERTPROBLEM,           58,
    # couldn't use specified cipher
    :SSL_CIPHER,                59,
    # problem with the CA cert (path?)
    :SSL_CACERT,                60,
    # Unrecognized transfer encoding
    :BAD_CONTENT_ENCODING,      61,
    # Invalid LDAP URL
    :LDAP_INVALID_URL,          62,
    # Maximum file size exceeded
    :FILESIZE_EXCEEDED,         63,
    # Requested FTP SSL level failed
    :USE_SSL_FAILED,            64,
    # Sending the data requires a rewind that failed
    :SEND_FAIL_REWIND,          65,

    # failed to initialise ENGINE
    :SSL_ENGINE_INITFAILED,     66,
    # user, password or similar was not accepted and we failed to login
    :LOGIN_DENIED,              67,

    # file not found on server
    :TFTP_NOTFOUND,             68,
    # permission problem on server
    :TFTP_PERM,                 69,
    # out of disk space on server
    :REMOTE_DISK_FULL,          70,
    # Illegal TFTP operation
    :TFTP_ILLEGAL,              71,
    # Unknown transfer ID
    :TFTP_UNKNOWNID,            72,
    # File already exists
    :REMOTE_FILE_EXISTS,        73,
    # No such user
    :TFTP_NOSUCHUSER,           74,
    # conversion failed
    :CONV_FAILED,               75,
    # caller must register conversion callbacks using curl_easy_setopt options
    # CURLOPT_CONV_FROM_NETWORK_FUNCTION,
    # CURLOPT_CONV_TO_NETWORK_FUNCTION, and
    # CURLOPT_CONV_FROM_UTF8_FUNCTION
    :CONV_REQD,                 76,

    # could not load CACERT file, missing or wrong format
    :SSL_CACERT_BADFILE,        77,

    # remote file not found
    :REMOTE_FILE_NOT_FOUND,     78,

    # error from the SSH layer, somewhat generic so the error message will be of
    # interest when this has happened
    :SSH,                       79,

    # Failed to shut down the SSL connection
    :SSL_SHUTDOWN_FAILED,       80,

    # socket is not ready for send/recv, wait till it's ready and try again (Added in 7.18.2)
    :AGAIN,                     81,

    # could not load CRL file, missing or wrong format (Added in 7.19.0)
    :SSL_CRL_BADFILE,           82,

    # Issuer check failed.  (Added in 7.19.0)
    :SSL_ISSUER_ERROR,          83,
    # a PRET command failed
    :FTP_PRET_FAILED,           84,
    # mismatch of RTSP CSeq numbers
    :RTSP_CSEQ_ERROR,           85,
    # mismatch of RTSP Session Identifiers
    :RTSP_SESSION_ERROR,        86,
    # unable to parse FTP file list
    :FTP_BAD_FILE_LIST,         87,
    # chunk callback reported error
    :CHUNK_FAILED,              88
  ]

  MULTI_CODE = enum :multi_code, [
    :CALL_MULTI_PERFORM, -1,
    :OK,                  0,
    :BAD_HANDLE,          1,
    :BAD_EASY_HANDLE,     2,
    :OUT_OF_MEMORY,       3,
    :INTERNAL_ERROR,      4,
    :BAD_SOCKET,          5,
    :UNKNOWN_OPTION,      6
  ]

  MESSAGE = enum :message, [
    :DONE, 1
  ]

  OPTION_LONG          = 0
  OPTION_OBJECTPOINT   = 10000
  OPTION_FUNCTIONPOINT = 20000
  OPTION_OFF_T         = 30000

  OPTION = enum :option, [
    :FILE,  1 + OPTION_OBJECTPOINT,
    :URL,   2 + OPTION_OBJECTPOINT,
    :PORT,  3 + OPTION_LONG,
    :PROXY, 4 + OPTION_OBJECTPOINT
  ]

  MULTI_OPTION = enum :multi_option, [
    :SOCKETFUNCTION, 1 + OPTION_FUNCTIONPOINT,
    :SOCKETDATA,     2 + OPTION_OBJECTPOINT,
    :PIPELINING,     3 + OPTION_LONG,
    :TIMERFUNCTION,  4 + OPTION_FUNCTIONPOINT,
    :TIMERDATA,      5 + OPTION_OBJECTPOINT,
    :MAXCONNECTS,    6 + OPTION_LONG
  ]

  INFO_STRING = 0x100000
  INFO_LONG   = 0x200000
  INFO_DOUBLE = 0x300000
  INFO_SLIST  = 0x400000

  INFO = enum :info, [
    :EFFECTIVE_URL,           INFO_STRING + 1,
    :RESPONSE_CODE,           INFO_LONG   + 2,
    :TOTAL_TIME,              INFO_DOUBLE + 3,
    :NAMELOOKUP_TIME,         INFO_DOUBLE + 4,
    :CONNECT_TIME,            INFO_DOUBLE + 5,
    :PRETRANSFER_TIME,        INFO_DOUBLE + 6,
    :SIZE_UPLOAD,             INFO_DOUBLE + 7,
    :SIZE_DOWNLOAD,           INFO_DOUBLE + 8,
    :SPEED_DOWNLOAD,          INFO_DOUBLE + 9,
    :SPEED_UPLOAD,            INFO_DOUBLE + 10,
    :HEADER_SIZE,             INFO_LONG   + 11,
    :REQUEST_SIZE,            INFO_LONG   + 12,
    :SSL_VERIFYRESULT,        INFO_LONG   + 13,
    :FILETIME,                INFO_LONG   + 14,
    :CONTENT_LENGTH_DOWNLOAD, INFO_DOUBLE + 15,
    :CONTENT_LENGTH_UPLOAD,   INFO_DOUBLE + 16,
    :STARTTRANSFER_TIME,      INFO_DOUBLE + 17,
    :CONTENT_TYPE,            INFO_STRING + 18,
    :REDIRECT_TIME,           INFO_DOUBLE + 19,
    :REDIRECT_COUNT,          INFO_LONG   + 20,
    :PRIVATE,                 INFO_STRING + 21,
    :HTTP_CONNECTCODE,        INFO_LONG   + 22,
    :HTTPAUTH_AVAIL,          INFO_LONG   + 23,
    :PROXYAUTH_AVAIL,         INFO_LONG   + 24,
    :OS_ERRNO,                INFO_LONG   + 25,
    :NUM_CONNECTS,            INFO_LONG   + 26,
    :SSL_ENGINES,             INFO_SLIST  + 27,
    :COOKIELIST,              INFO_SLIST  + 28,
    :LASTSOCKET,              INFO_LONG   + 29,
    :FTP_ENTRY_PATH,          INFO_STRING + 30,
    :REDIRECT_URL,            INFO_STRING + 31,
    :PRIMARY_IP,              INFO_STRING + 32,
    :APPCONNECT_TIME,         INFO_DOUBLE + 33,
    :CERTINFO,                INFO_SLIST  + 34,
    :CONDITION_UNMET,         INFO_LONG   + 35,
    :RTSP_SESSION_ID,         INFO_STRING + 36,
    :RTSP_CLIENT_CSEQ,        INFO_LONG   + 37,
    :RTSP_SERVER_CSEQ,        INFO_LONG   + 38,
    :RTSP_CSEQ_RECV,          INFO_LONG   + 39,
    :PRIMARY_PORT,            INFO_LONG   + 40,
    :LOCAL_IP,                INFO_STRING + 41,
    :LOCAL_PORT,              INFO_LONG   + 42
  ]

  class MessageData < FFI::Union
    layout :whatever, :pointer,
        :result, :code
  end

  class Message < FFI::Struct
    layout :msg, :message,
      :easy_handle, :pointer,
      :data, MessageData
  end

  # Returns a char * - needs to be freed manually using curl_free
  attach_function :easy_escape, :curl_easy_escape, [:pointer, :string, :int], :pointer
  attach_function :easy_init, :curl_easy_init, [], :pointer
  attach_function :easy_cleanup, :curl_easy_cleanup, [:pointer], :void
  attach_function :easy_duphandle, :curl_easy_duphandle, [:pointer], :pointer
  attach_function :easy_getinfo, :curl_easy_getinfo, [:pointer, :info, :pointer], :code
  attach_function :easy_pause, :curl_easy_pause, [:pointer, :int], :code
  attach_function :easy_perform, :curl_easy_perform, [:pointer], :code
  attach_function :easy_recv, :curl_easy_recv, [:pointer, :pointer, :size_t, :size_t], :code
  attach_function :easy_reset, :curl_easy_reset, [:pointer], :void
  attach_function :easy_send, :curl_easy_send, [:pointer, :string, :size_t, :pointer], :code

  attach_function :easy_setopt_long, :curl_easy_setopt, [:pointer, :option, :long], :code
  attach_function :easy_setopt_string, :curl_easy_setopt, [:pointer, :option, :string], :code
  attach_function :easy_setopt_pointer, :curl_easy_setopt, [:pointer, :option, :pointer], :code
  attach_function :easy_setopt_curl_off_t, :curl_easy_setopt, [:pointer, :option, :curl_off_t], :code

  attach_function :easy_strerror, :curl_easy_strerror, [:code], :string

  # Returns a char * that has to be freed using curl_free
  attach_function :easy_unescape, :curl_easy_unescape, [:pointer, :string, :int, :pointer], :pointer


  attach_function :multi_add_handle, :curl_multi_add_handle, [:pointer, :pointer], :multi_code
  attach_function :multi_assign, :curl_multi_assign, [:pointer, :curl_socket_t, :pointer], :multi_code
  attach_function :multi_cleanup, :curl_multi_cleanup, [:pointer], :void
  attach_function :multi_fdset, :curl_multi_fdset, [:pointer, :pointer, :pointer, :pointer, :pointer], :multi_code
  attach_function :multi_info_read, :curl_multi_info_read, [:pointer, :pointer], :pointer
  attach_function :multi_init, :curl_multi_init, [], :pointer
  attach_function :multi_perform, :curl_multi_perform, [:pointer, :pointer], :multi_code
  attach_function :multi_remove_handle, :curl_multi_remove_handle, [:pointer, :pointer], :multi_code

  attach_function :multi_setopt_long, :curl_multi_setopt, [:pointer, :multi_option, :long], :multi_code
  attach_function :multi_setopt_string, :curl_multi_setopt, [:pointer, :multi_option, :string], :multi_code
  attach_function :multi_setopt_pointer, :curl_multi_setopt, [:pointer, :multi_option, :pointer], :multi_code
  attach_function :multi_setopt_curl_off_t, :curl_multi_setopt, [:pointer, :multi_option, :curl_off_t], :multi_code

  attach_function :multi_socket_action, :curl_multi_socket_action, [:pointer, :curl_socket_t, :int, :pointer], :multi_code
  attach_function :multi_strerror, :curl_multi_strerror, [:multi_code], :string
  attach_function :multi_timeout, :curl_multi_timeout, [:pointer, :pointer], :multi_code


  attach_function :free, :curl_free, [:pointer], :void

  attach_function :slist_append, :curl_slist_append, [:pointer, :string], :pointer
  attach_function :slist_free_all, :curl_slist_free_all, [:pointer], :void


end