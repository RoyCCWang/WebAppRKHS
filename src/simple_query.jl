
import HTTP
#import JSON3

HTTP.request("POST", "http://localhost:8000/jsonpayload",
    [("Content-Type", "application/json")], """{"name":"Adrian"}""")

#
# import HTTP
# HTTP.request("POST", "http://rwresearch.ca/jsonpayload",
#     [("Content-Type", "application/json")], """{"name":"Adrian"}""")
