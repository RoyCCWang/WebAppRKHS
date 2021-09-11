
import HTTP
import JSON3

# url = "http://127.0.0.1:8000"
# q = HTTP.request("GET", url, [], [])

# HTTP.request("POST", "http://localhost:8000/jsonpayload",
#     [("Content-Type", "application/json")], """{"name":"Adrian"}""")

x = randn(3)
y = randn(3)
xq = randn(30)

input_array = Vector{Vector{Float64}}(undef, 2)
input_array[1] = x
input_array[2] = y

q =  """{"input_array":$(input_array)}"""
#q =  """{"x":$(x)}"""
#q = """{"name":"Adrian"}"""

b = JSON3.write(input_array)
c = JSON3.read(b)
d = convert(Vector{Vector{Float64}}, c)
x_rec = d[1]
y_rec = d[2]

z = HTTP.request("POST", "http://localhost:8000/jsonpayload",
    [("Content-Type", "application/json")], q)

h = String(HTTP.payload(z.request))

dic = JSON3.read(h)
Z = convert(Vector{Vector{Float64}}, dic["input_array"])



dic = JSON3.read(q)
Q = convert(Vector{Vector{Float64}}, dic["input_array"])
x_rec2 = Q[1]
y_rec2 = Q[2]
