require 'ffi'

module Curl
  extend FFI::Library
  ffi_lib "libcurl"

  if FFI::Platform.windows?
    typedef :uint, :curl_socket_t
    SOCKET_BAD = 4294967295
  else
    typedef :int, :curl_socket_t
    SOCKET_BAD = -1
  end

  SOCKET_TIMEOUT = SOCKET_BAD

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
    # This is the FILE* or void* the regular output should be written to.
    :FILE, OPTION_OBJECTPOINT + 1,

    # The full URL to get/put
    :URL,  OPTION_OBJECTPOINT + 2,

    # Port number to connect to, if other than default.
    :PORT, OPTION_LONG + 3,

    # Name of proxy to use.
    :PROXY, OPTION_OBJECTPOINT + 4,

    # "name:password" to use when fetching.
    :USERPWD, OPTION_OBJECTPOINT + 5,

    # "name:password" to use with proxy.
    :PROXYUSERPWD, OPTION_OBJECTPOINT + 6,

    # Range to get, specified as an ASCII string.
    :RANGE, OPTION_OBJECTPOINT + 7,

    # Specified file stream to upload from (use as input):
    :INFILE, OPTION_OBJECTPOINT + 9,

    # Buffer to receive error messages in, must be at least CURL_ERROR_SIZE
    # bytes big. If this is not used, error messages go to stderr instead:
    :ERRORBUFFER, OPTION_OBJECTPOINT + 10,

    # Function that will be called to store the output (instead of fwrite). The
    # parameters will use fwrite() syntax, make sure to follow them.
    :WRITEFUNCTION, OPTION_FUNCTIONPOINT + 11,

    # Function that will be called to read the input (instead of fread). The
    # parameters will use fread() syntax, make sure to follow them.
    :READFUNCTION, OPTION_FUNCTIONPOINT + 12,

    # Time-out the read operation after this amount of seconds
    :TIMEOUT, OPTION_LONG + 13,

    # If the CURLOPT_INFILE is used, this can be used to inform libcurl about
    # how large the file being sent really is. That allows better error
    # checking and better verifies that the upload was successful. -1 means
    # unknown size.
    #
    # For large file support, there is also a _LARGE version of the key
    # which takes an off_t type, allowing platforms with larger off_t
    # sizes to handle larger files.  See below for INFILESIZE_LARGE.
    :INFILESIZE, OPTION_LONG + 14,

    # POST static input fields.
    :POSTFIELDS, OPTION_OBJECTPOINT + 15,

    # Set the referrer page (needed by some CGIs)
    :REFERER, OPTION_OBJECTPOINT + 16,

    # Set the FTP PORT string (interface name, named or numerical IP address)
    #   Use i.e '-' to use default address.
    :FTPPORT, OPTION_OBJECTPOINT + 17,

    # Set the User-Agent string (examined by some CGIs)
    :USERAGENT, OPTION_OBJECTPOINT + 18,

    # If the download receives less than "low speed limit" bytes/second
    # during "low speed time" seconds, the operations is aborted.
    # You could i.e if you have a pretty high speed connection, abort if
    # it is less than 2000 bytes/sec during 20 seconds.

    # Set the "low speed limit"
    :LOW_SPEED_LIMIT, OPTION_LONG + 19,

    # Set the "low speed time"
    :LOW_SPEED_TIME, OPTION_LONG + 20,

    # Set the continuation offset.
    #
    # Note there is also a _LARGE version of this key which uses
    # off_t types, allowing for large file offsets on platforms which
    # use larger-than-32-bit off_t's.  Look below for RESUME_FROM_LARGE.
    :RESUME_FROM, OPTION_LONG + 21,

    # Set cookie in request:
    :COOKIE, OPTION_OBJECTPOINT + 22,

    # This points to a linked list of headers, struct curl_slist kind
    :HTTPHEADER, OPTION_OBJECTPOINT + 23,

    # This points to a linked list of post entries, struct curl_httppost
    :HTTPPOST, OPTION_OBJECTPOINT + 24,

    # name of the file keeping your private SSL-certificate
    :SSLCERT, OPTION_OBJECTPOINT + 25,

    # password for the SSL or SSH private key
    :KEYPASSWD, OPTION_OBJECTPOINT + 26,

    # send TYPE parameter?
    :CRLF, OPTION_LONG + 27,

    # send linked-list of QUOTE commands
    :QUOTE, OPTION_OBJECTPOINT + 28,

    # send FILE# or void# to store headers to, if you use a callback it
    #   is simply passed to the callback unmodified
    :WRITEHEADER, OPTION_OBJECTPOINT + 29,

    # point to a file to read the initial cookies from, also enables
    #   "cookie awareness"
    :COOKIEFILE, OPTION_OBJECTPOINT + 31,

    # What version to specifically try to use.
    #   See CURL_SSLVERSION defines below.
    :SSLVERSION, OPTION_LONG + 32,

    # What kind of HTTP time condition to use, see defines
    :TIMECONDITION, OPTION_LONG + 33,

    # Time to use with the above condition. Specified in number of seconds
    #   since 1 Jan 1970
    :TIMEVALUE, OPTION_LONG + 34,

    # Custom request, for customizing the get command like
    #   HTTP: DELETE, TRACE and others
    #   FTP: to use a different list command
    :CUSTOMREQUEST, OPTION_OBJECTPOINT + 36,

    # HTTP request, for odd commands like DELETE, TRACE and others
    :STDERR, OPTION_OBJECTPOINT + 37,

    # send linked-list of post-transfer QUOTE commands
    :POSTQUOTE, OPTION_OBJECTPOINT + 39,

    # Pass a pointer to string of the output using full variable-replacement
    #   as described elsewhere.
    :WRITEINFO, OPTION_OBJECTPOINT + 40,

    :VERBOSE, OPTION_LONG + 41,      # talk a lot
    :HEADER, OPTION_LONG + 42,       # throw the header out too
    :NOPROGRESS, OPTION_LONG + 43,   # shut off the progress meter
    :NOBODY, OPTION_LONG + 44,       # use HEAD to get http document
    :FAILONERROR, OPTION_LONG + 45,  # no output on http error codes >= 300
    :UPLOAD, OPTION_LONG + 46,       # this is an upload
    :POST, OPTION_LONG + 47,         # HTTP POST method
    :DIRLISTONLY, OPTION_LONG + 48,  # return bare names when listing directories

    :APPEND, OPTION_LONG + 50,       # Append instead of overwrite on upload!

    # Specify whether to read the user+password from the .netrc or the URL.
    # This must be one of the CURL_NETRC_* enums below.
    :NETRC, OPTION_LONG + 51,

    :FOLLOWLOCATION, OPTION_LONG + 52,  # use Location: Luke!

    :TRANSFERTEXT, OPTION_LONG + 53, # transfer data in text/ASCII format
    :PUT, OPTION_LONG + 54,          # HTTP PUT

    # 55 = OBSOLETE

    # Function that will be called instead of the internal progress display
    # function. This function should be defined as the curl_progress_callback
    # prototype defines.
    :PROGRESSFUNCTION, OPTION_FUNCTIONPOINT + 56,

    # Data passed to the progress callback
    :PROGRESSDATA, OPTION_OBJECTPOINT + 57,

    # We want the referrer field set automatically when following locations
    :AUTOREFERER, OPTION_LONG + 58,

    # Port of the proxy, can be set in the proxy string as well with:
    #   "[host]:[port]"
    :PROXYPORT, OPTION_LONG + 59,

    # size of the POST input data, if strlen() is not good to use
    :POSTFIELDSIZE, OPTION_LONG + 60,

    # tunnel non-http operations through a HTTP proxy
    :HTTPPROXYTUNNEL, OPTION_LONG + 61,

    # Set the interface string to use as outgoing network interface
    :INTERFACE, OPTION_OBJECTPOINT + 62,

    # Set the krb4/5 security level, this also enables krb4/5 awareness.  This
    # is a string, 'clear', 'safe', 'confidential' or 'private'.  If the string
    # is set but doesn't match one of these, 'private' will be used.
    :KRBLEVEL, OPTION_OBJECTPOINT + 63,

    # Set if we should verify the peer in ssl handshake, set 1 to verify.
    :SSL_VERIFYPEER, OPTION_LONG + 64,

    # The CApath or CAfile used to validate the peer certificate
    #   this option is used only if SSL_VERIFYPEER is true
    :CAINFO, OPTION_OBJECTPOINT + 65,

    # Maximum number of http redirects to follow
    :MAXREDIRS, OPTION_LONG + 68,

    # Pass a OPTION_long set to 1 to get the date of the requested document (if
    #   possible)! Pass a zero to shut it off.
    :FILETIME, OPTION_LONG + 69,

    # This points to a linked list of telnet options
    :TELNETOPTIONS, OPTION_OBJECTPOINT + 70,

    # Max amount of cached alive connections
    :MAXCONNECTS, OPTION_LONG + 71,

    # What policy to use when closing connections when the cache is filled up
    :CLOSEPOLICY, OPTION_LONG + 72,

    # Set to explicitly use a new connection for the upcoming transfer.
    #   Do not use this unless you're absolutely sure of this, as it makes the
    #   operation slower and is less friendly for the network.
    :FRESH_CONNECT, OPTION_LONG + 74,

    # Set to explicitly forbid the upcoming transfer's connection to be re-used
    #   when done. Do not use this unless you're absolutely sure of this, as it
    #   makes the operation slower and is less friendly for the network.
    :FORBID_REUSE, OPTION_LONG + 75,

    # Set to a file name that contains random data for libcurl to use to
    #   seed the random engine when doing SSL connects.
    :RANDOM_FILE, OPTION_OBJECTPOINT + 76,

    # Set to the Entropy Gathering Daemon socket pathname
    :EGDSOCKET, OPTION_OBJECTPOINT + 77,

    # Time-out connect operations after this amount of seconds, if connects
    #   are OK within this time, then fine... This only aborts the connect
    #   phase. [Only works on unix-style/SIGALRM operating systems]
    :CONNECTTIMEOUT, OPTION_LONG + 78,

    # Function that will be called to store headers (instead of fwrite). The
    # parameters will use fwrite() syntax, make sure to follow them.
    :HEADERFUNCTION, OPTION_FUNCTIONPOINT + 79,

    # Set this to force the HTTP request to get back to GET. Only really usable
    #   if POST, PUT or a custom request have been used first.
    :HTTPGET, OPTION_LONG + 80,

    # Set if we should verify the Common name from the peer certificate in ssl
    # handshake, set 1 to check existence, 2 to ensure that it matches the
    # provided hostname.
    :SSL_VERIFYHOST, OPTION_LONG + 81,

    # Specify which file name to write all known cookies in after completed
    #   operation. Set file name to "-" (dash) to make it go to stdout.
    :COOKIEJAR, OPTION_OBJECTPOINT + 82,

    # Specify which SSL ciphers to use
    :SSL_CIPHER_LIST, OPTION_OBJECTPOINT + 83,

    # Specify which HTTP version to use! This must be set to one of the
    #   CURL_HTTP_VERSION* enums set below.
    :HTTP_VERSION, OPTION_LONG + 84,

    # Specifically switch on or off the FTP engine's use of the EPSV command. By
    #   default, that one will always be attempted before the more traditional
    #   PASV command.
    :FTP_USE_EPSV, OPTION_LONG + 85,

    # type of the file keeping your SSL-certificate ("DER", "PEM", "ENG")
    :SSLCERTTYPE, OPTION_OBJECTPOINT + 86,

    # name of the file keeping your private SSL-key
    :SSLKEY, OPTION_OBJECTPOINT + 87,

    # type of the file keeping your private SSL-key ("DER", "PEM", "ENG")
    :SSLKEYTYPE, OPTION_OBJECTPOINT + 88,

    # crypto engine for the SSL-sub system
    :SSLENGINE, OPTION_OBJECTPOINT + 89,

    # set the crypto engine for the SSL-sub system as default
    #   the param has no meaning...
    :SSLENGINE_DEFAULT, OPTION_LONG + 90,

    # Non-zero value means to use the global dns cache
    :DNS_USE_GLOBAL_CACHE, OPTION_LONG + 91, # To become OBSOLETE soon

    # DNS cache timeout
    :DNS_CACHE_TIMEOUT, OPTION_LONG + 92,

    # send linked-list of pre-transfer QUOTE commands
    :PREQUOTE, OPTION_OBJECTPOINT + 93,

    # set the debug function
    :DEBUGFUNCTION, OPTION_FUNCTIONPOINT + 94,

    # set the data for the debug function
    :DEBUGDATA, OPTION_OBJECTPOINT + 95,

    # mark this as start of a cookie session
    :COOKIESESSION, OPTION_LONG + 96,

    # The CApath directory used to validate the peer certificate
    #   this option is used only if SSL_VERIFYPEER is true
    :CAPATH, OPTION_OBJECTPOINT + 97,

    # Instruct libcurl to use a smaller receive buffer
    :BUFFERSIZE, OPTION_LONG + 98,

    # Instruct libcurl to not use any signal/alarm handlers, even when using
    #   timeouts. This option is useful for multi-threaded applications.
    #   See libcurl-the-guide for more background information.
    :NOSIGNAL, OPTION_LONG + 99,

    # Provide a CURLShare for mutexing non-ts data
    :SHARE, OPTION_OBJECTPOINT + 100,

    # indicates type of proxy. accepted values are CURLPROXY_HTTP (default),
    #   CURLPROXY_SOCKS4, CURLPROXY_SOCKS4A and CURLPROXY_SOCKS5.
    :PROXYTYPE, OPTION_LONG + 101,

    # Set the Accept-Encoding string. Use this to tell a server you would like
    #   the response to be compressed.
    :ENCODING, OPTION_OBJECTPOINT + 102,

    # Set pointer to private data
    :PRIVATE, OPTION_OBJECTPOINT + 103,

    # Set aliases for HTTP 200 in the HTTP Response header
    :HTTP200ALIASES, OPTION_OBJECTPOINT + 104,

    # Continue to send authentication (user+password) when following locations,
    #   even when hostname changed. This can potentially send off the name
    #   and password to whatever host the server decides.
    :UNRESTRICTED_AUTH, OPTION_LONG + 105,

    # Specifically switch on or off the FTP engine's use of the EPRT command ( it
    #   also disables the LPRT attempt). By default, those ones will always be
    #   attempted before the good old traditional PORT command.
    :FTP_USE_EPRT, OPTION_LONG + 106,

    # Set this to a bitmask value to enable the particular authentications
    #   methods you like. Use this in combination with CURLOPT_USERPWD.
    #   Note that setting multiple bits may cause extra network round-trips.
    :HTTPAUTH, OPTION_LONG + 107,

    # Set the ssl context callback function, currently only for OpenSSL ssl_ctx
    #   in second argument. The function must be matching the
    #   curl_ssl_ctx_callback proto.
    :SSL_CTX_FUNCTION, OPTION_FUNCTIONPOINT + 108,

    # Set the userdata for the ssl context callback function's third
    #   argument
    :SSL_CTX_DATA, OPTION_OBJECTPOINT + 109,

    # FTP Option that causes missing dirs to be created on the remote server.
    #   In 7.19.4 we introduced the convenience enums for this option using the
    #   CURLFTP_CREATE_DIR prefix.
    :FTP_CREATE_MISSING_DIRS, OPTION_LONG + 110,

    # Set this to a bitmask value to enable the particular authentications
    #   methods you like. Use this in combination with CURLOPT_PROXYUSERPWD.
    #   Note that setting multiple bits may cause extra network round-trips.
    :PROXYAUTH, OPTION_LONG + 111,

    # FTP option that changes the timeout, in seconds, associated with
    #   getting a response.  This is different from transfer timeout time and
    #   essentially places a demand on the FTP server to acknowledge commands
    #   in a timely manner.
    :FTP_RESPONSE_TIMEOUT, OPTION_LONG + 112,
    :CURLOPT_SERVER_RESPONSE_TIMEOUT, OPTION_LONG + 112,

    # Set this option to one of the CURL_IPRESOLVE_* defines (see below) to
    #   tell libcurl to resolve names to those IP versions only. This only has
    #   affect on systems with support for more than one, i.e IPv4 _and_ IPv6.
    :IPRESOLVE, OPTION_LONG + 113,

    # Set this option to limit the size of a file that will be downloaded from
    #   an HTTP or FTP server.

    #   Note there is also _LARGE version which adds large file support for
    #   platforms which have larger off_t sizes.  See MAXFILESIZE_LARGE below.
    :MAXFILESIZE, OPTION_LONG + 114,

    # See the comment for INFILESIZE above, but in short, specifies
    # the size of the file being uploaded.  -1 means unknown.
    :INFILESIZE_LARGE, OPTION_OFF_T + 115,

    # Sets the continuation offset.  There is also a OPTION_LONG version of this;
    # look above for RESUME_FROM.
    :RESUME_FROM_LARGE, OPTION_OFF_T + 116,

    # Sets the maximum size of data that will be downloaded from
    # an HTTP or FTP server.  See MAXFILESIZE above for the OPTION_LONG version.

    :MAXFILESIZE_LARGE, OPTION_OFF_T + 117,

    # Set this option to the file name of your .netrc file you want libcurl
    #   to parse (using the CURLOPT_NETRC option). If not set, libcurl will do
    #   a poor attempt to find the user's home directory and check for a .netrc
    #   file in there.
    :NETRC_FILE, OPTION_OBJECTPOINT + 118,

    # Enable SSL/TLS for FTP, pick one of:
    #   CURLFTPSSL_TRY     - try using SSL, proceed anyway otherwise
    #   CURLFTPSSL_CONTROL - SSL for the control connection or fail
    #   CURLFTPSSL_ALL     - SSL for all communication or fail

    :USE_SSL, OPTION_LONG + 119,

    # The _LARGE version of the standard POSTFIELDSIZE option
    :POSTFIELDSIZE_LARGE, OPTION_OFF_T + 120,

    # Enable/disable the TCP Nagle algorithm
    :TCP_NODELAY, OPTION_LONG + 121,

    # When FTP over SSL/TLS is selected (with CURLOPT_USE_SSL), this option
    #   can be used to change libcurl's default action which is to first try
    #   "AUTH SSL" and then "AUTH TLS" in this order, and proceed when a OK
    #   response has been received.
    #
    #   Available parameters are:
    #   CURLFTPAUTH_DEFAULT - let libcurl decide
    #   CURLFTPAUTH_SSL     - try "AUTH SSL" first, then TLS
    #   CURLFTPAUTH_TLS     - try "AUTH TLS" first, then SSL
    :FTPSSLAUTH, OPTION_LONG + 129,

    :IOCTLFUNCTION, OPTION_FUNCTIONPOINT + 130,
    :IOCTLDATA, OPTION_OBJECTPOINT + 131,

    # zero terminated string for pass on to the FTP server when asked for
    #   "account" info
    :FTP_ACCOUNT, OPTION_OBJECTPOINT + 134,

    # feed cookies into cookie engine
    :COOKIELIST, OPTION_OBJECTPOINT + 135,

    # ignore Content-Length
    :IGNORE_CONTENT_LENGTH, OPTION_LONG + 136,

    # Set to non-zero to skip the IP address received in a 227 PASV FTP server
    #   response. Typically used for FTP-SSL purposes but is not restricted to
    #   that. libcurl will then instead use the same IP address it used for the
    #   control connection.
    :FTP_SKIP_PASV_IP, OPTION_LONG + 137,

    # Select "file method" to use when doing FTP, see the curl_ftpmethod
    #   above.
    :FTP_FILEMETHOD, OPTION_LONG + 138,

    # Local port number to bind the socket to
    :LOCALPORT, OPTION_LONG + 139,

    # Number of ports to try, including the first one set with LOCALPORT.
    #   Thus, setting it to 1 will make no additional attempts but the first.

    :LOCALPORTRANGE, OPTION_LONG + 140,

    # no transfer, set up connection and let application use the socket by
    #   extracting it with CURLINFO_LASTSOCKET
    :CONNECT_ONLY, OPTION_LONG + 141,

    # Function that will be called to convert from the
    #   network encoding (instead of using the iconv calls in libcurl)
    :CONV_FROM_NETWORK_FUNCTION, OPTION_FUNCTIONPOINT + 142,

    # Function that will be called to convert to the
    #   network encoding (instead of using the iconv calls in libcurl)
    :CONV_TO_NETWORK_FUNCTION, OPTION_FUNCTIONPOINT + 143,

    # Function that will be called to convert from UTF8
    #   (instead of using the iconv calls in libcurl)
    #   Note that this is used only for SSL certificate processing
    :CONV_FROM_UTF8_FUNCTION, OPTION_FUNCTIONPOINT + 144,

    # if the connection proceeds too quickly then need to slow it down
    # limit-rate: maximum number of bytes per second to send or receive
    :MAX_SEND_SPEED_LARGE, OPTION_OFF_T + 145,
    :MAX_RECV_SPEED_LARGE, OPTION_OFF_T + 146,

    # Pointer to command string to send if USER/PASS fails.
    :FTP_ALTERNATIVE_TO_USER, OPTION_OBJECTPOINT + 147,

    # callback function for setting socket options
    :SOCKOPTFUNCTION, OPTION_FUNCTIONPOINT + 148,
    :SOCKOPTDATA, OPTION_OBJECTPOINT + 149,

    # set to 0 to disable session ID re-use for this transfer, default is
    #   enabled (== 1)
    :SSL_SESSIONID_CACHE, OPTION_LONG + 150,

    # allowed SSH authentication methods
    :SSH_AUTH_TYPES, OPTION_LONG + 151,

    # Used by scp/sftp to do public/private key authentication
    :SSH_PUBLIC_KEYFILE, OPTION_OBJECTPOINT + 152,
    :SSH_PRIVATE_KEYFILE, OPTION_OBJECTPOINT + 153,

    # Send CCC (Clear Command Channel) after authentication
    :FTP_SSL_CCC, OPTION_LONG + 154,

    # Same as TIMEOUT and CONNECTTIMEOUT, but with ms resolution
    :TIMEOUT_MS, OPTION_LONG + 155,
    :CONNECTTIMEOUT_MS, OPTION_LONG + 156,

    # set to zero to disable the libcurl's decoding and thus pass the raw body
    #   data to the application even when it is encoded/compressed
    :HTTP_TRANSFER_DECODING, OPTION_LONG + 157,
    :HTTP_CONTENT_DECODING, OPTION_LONG + 158,

    # Permission used when creating new files and directories on the remote
    #   server for protocols that support it, SFTP/SCP/FILE
    :NEW_FILE_PERMS, OPTION_LONG + 159,
    :NEW_DIRECTORY_PERMS, OPTION_LONG + 160,

    # Set the behaviour of POST when redirecting. Values must be set to one
    #   of CURL_REDIR* defines below. This used to be called CURLOPT_POST301
    :POSTREDIR, OPTION_LONG + 161,

    # used by scp/sftp to verify the host's public key
    :SSH_HOST_PUBLIC_KEY_MD5, OPTION_OBJECTPOINT + 162,

    # Callback function for opening socket (instead of socket(2)). Optionally,
    #   callback is able change the address or refuse to connect returning
    #   CURL_SOCKET_BAD.  The callback should have type
    #   curl_opensocket_callback
    :OPENSOCKETFUNCTION, OPTION_FUNCTIONPOINT + 163,
    :OPENSOCKETDATA, OPTION_OBJECTPOINT + 164,

    # POST volatile input fields.
    :COPYPOSTFIELDS, OPTION_OBJECTPOINT + 165,

    # set transfer mode (;type=<a|i>) when doing FTP via an HTTP proxy
    :PROXY_TRANSFER_MODE, OPTION_LONG + 166,

    # Callback function for seeking in the input stream
    :SEEKFUNCTION, OPTION_FUNCTIONPOINT + 167,
    :SEEKDATA, OPTION_OBJECTPOINT + 168,

    # CRL file
    :CRLFILE, OPTION_OBJECTPOINT + 169,

    # Issuer certificate
    :ISSUERCERT, OPTION_OBJECTPOINT + 170,

    # (IPv6) Address scope
    :ADDRESS_SCOPE, OPTION_LONG + 171,

    # Collect certificate chain info and allow it to get retrievable with
    #   CURLINFO_CERTINFO after the transfer is complete. (Unfortunately) only
    #   working with OpenSSL-powered builds.
    :CERTINFO, OPTION_LONG + 172,

    # "name" and "pwd" to use when fetching.
    :USERNAME, OPTION_OBJECTPOINT + 173,
    :PASSWORD, OPTION_OBJECTPOINT + 174,

      # "name" and "pwd" to use with Proxy when fetching.
    :PROXYUSERNAME, OPTION_OBJECTPOINT + 175,
    :PROXYPASSWORD, OPTION_OBJECTPOINT + 176,

    # Comma separated list of hostnames defining no-proxy zones. These should
    #   match both hostnames directly, and hostnames within a domain. For
    #   example, local.com will match local.com and www.local.com, but NOT
    #   notlocal.com or www.notlocal.com. For compatibility with other
    #   implementations of this, .local.com will be considered to be the same as
    #   local.com. A single# is the only valid wildcard, and effectively
    #   disables the use of proxy.
    :NOPROXY, OPTION_OBJECTPOINT + 177,

    # block size for TFTP transfers
    :TFTP_BLKSIZE, OPTION_LONG + 178,

    # Socks Service
    :SOCKS5_GSSAPI_SERVICE, OPTION_OBJECTPOINT + 179,

    # Socks Service
    :SOCKS5_GSSAPI_NEC, OPTION_LONG + 180,

    # set the bitmask for the protocols that are allowed to be used for the
    #   transfer, which thus helps the app which takes URLs from users or other
    #   external inputs and want to restrict what protocol(s) to deal
    #   with. Defaults to CURLPROTO_ALL.
    :PROTOCOLS, OPTION_LONG + 181,

    # set the bitmask for the protocols that libcurl is allowed to follow to,
    #   as a subset of the CURLOPT_PROTOCOLS ones. That means the protocol needs
    #   to be set in both bitmasks to be allowed to get redirected to. Defaults
    #   to all protocols except FILE and SCP.
    :REDIR_PROTOCOLS, OPTION_LONG + 182,

    # set the SSH knownhost file name to use
    :SSH_KNOWNHOSTS, OPTION_OBJECTPOINT + 183,

    # set the SSH host key callback, must point to a curl_sshkeycallback
    #   function
    :SSH_KEYFUNCTION, OPTION_FUNCTIONPOINT + 184,

    # set the SSH host key callback custom pointer
    :SSH_KEYDATA, OPTION_OBJECTPOINT + 185,

    # set the SMTP mail originator
    :MAIL_FROM, OPTION_OBJECTPOINT + 186,

    # set the SMTP mail receiver(s)
    :MAIL_RCPT, OPTION_OBJECTPOINT + 187,

    # FTP: send PRET before PASV
    :FTP_USE_PRET, OPTION_LONG + 188,

    # RTSP request method (OPTIONS, SETUP, PLAY, etc...)
    :RTSP_REQUEST, OPTION_LONG + 189,

    # The RTSP session identifier
    :RTSP_SESSION_ID, OPTION_OBJECTPOINT + 190,

    # The RTSP stream URI
    :RTSP_STREAM_URI, OPTION_OBJECTPOINT + 191,

    # The Transport: header to use in RTSP requests
    :RTSP_TRANSPORT, OPTION_OBJECTPOINT + 192,

    # Manually initialize the client RTSP CSeq for this handle
    :RTSP_CLIENT_CSEQ, OPTION_LONG + 193,

    # Manually initialize the server RTSP CSeq for this handle
    :RTSP_SERVER_CSEQ, OPTION_LONG + 194,

    # The stream to pass to INTERLEAVEFUNCTION.
    :INTERLEAVEDATA, OPTION_OBJECTPOINT + 195,

    # Let the application define a custom write method for RTP data
    :INTERLEAVEFUNCTION, OPTION_FUNCTIONPOINT + 196,

    # Turn on wildcard matching
    :WILDCARDMATCH, OPTION_LONG + 197,

    # Directory matching callback called before downloading of an
    #   individual file (chunk) started
    :CHUNK_BGN_FUNCTION, OPTION_FUNCTIONPOINT + 198,

    # Directory matching callback called after the file (chunk)
    #   was downloaded, or skipped
    :CHUNK_END_FUNCTION, OPTION_FUNCTIONPOINT + 199,

    # Change match (fnmatch-like) callback for wildcard matching
    :FNMATCH_FUNCTION, OPTION_FUNCTIONPOINT + 200,

    # Let the application define custom chunk data pointer
    :CHUNK_DATA, OPTION_OBJECTPOINT + 201,

    # FNMATCH_FUNCTION user pointer
    :FNMATCH_DATA, OPTION_OBJECTPOINT + 202,
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

  def self.easy_setopt(handle, option, value)
    option = OPTION[option] if option.is_a?(Symbol)

    if option >= OPTION_OFF_T
      self.easy_setopt_curl_off_t(handle, option, value)
    elsif option >= OPTION_FUNCTIONPOINT
      self.easy_setopt_pointer(handle, option, value)
    elsif option >= OPTION_OBJECTPOINT
      if value.respond_to?(:to_str)
        self.easy_setopt_string(handle, option, value.to_str)
      else
        self.easy_setopt_pointer(handle, option, value)
      end
    elsif option >= OPTION_LONG
      self.easy_setopt_long(handle, option, value)
    end
  end

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

  def self.multi_setopt(handle, option, value)
    option = MULTI_OPTION[option] if option.is_a?(Symbol)

    if option >= OPTION_OFF_T
      self.multi_setopt_curl_off_t(handle, option, value)
    elsif option >= OPTION_FUNCTIONPOINT
      self.multi_setopt_pointer(handle, option, value)
    elsif option >= OPTION_OBJECTPOINT
      if value.respond_to?(:to_str)
        self.multi_setopt_string(handle, option, value.to_str)
      else
        self.multi_setopt_pointer(handle, option, value)
      end
    elsif option >= OPTION_LONG
      self.multi_setopt_long(handle, option, value)
    end
  end

  attach_function :multi_socket_action, :curl_multi_socket_action, [:pointer, :curl_socket_t, :int, :pointer], :multi_code
  attach_function :multi_strerror, :curl_multi_strerror, [:multi_code], :string
  attach_function :multi_timeout, :curl_multi_timeout, [:pointer, :pointer], :multi_code


  attach_function :free, :curl_free, [:pointer], :void

  attach_function :slist_append, :curl_slist_append, [:pointer, :string], :pointer
  attach_function :slist_free_all, :curl_slist_free_all, [:pointer], :void


end