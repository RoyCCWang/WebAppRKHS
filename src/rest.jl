# https://genieframework.github.io/Genie.jl/dev/guides/Simple_API_backend.html#Developing-a-simple-API-backend

# using Genie, Genie.Router, Genie.Renderer.Json, Genie.Requests
# using HTTP
#
# route("/echo", method = POST) do
#   message = jsonpayload()
#   (:echo => (message["message"] * " ") ^ message["repeat"]) |> json
#   println("message = ", message)
# end
#
# route("/send") do
#   response = HTTP.request("POST", "http://localhost:8000/echo", [("Content-Type", "application/json")], """{"message":"hello", "repeat":3}""")
#
#   response.body |> String |> json
# end
#
# Genie.startup(async = false)


# https://genieframework.github.io/Genie.jl/dev/tutorials/7--Using_JSON_Payloads.html
using Genie, Genie.Router, Genie.Requests, Genie.Renderer.Json

import RKHSRegularization

route("/jsonpayload", method = POST) do
  @show jsonpayload()
  @show rawpayload()

  incoming_array = jsonpayload()["input_array"]
  #println("typeof(incoming_array) = ", incoming_array)
  x = convert(Vector{Float64}, incoming_array[1])
  y = convert(Vector{Float64}, incoming_array[2])
  xq = convert(Vector{Float64}, incoming_array[3])

  hyperparams = convert(Vector{Float64}, incoming_array[4])
  θ_len = hyperparams[1]
  σ² = hyperparams[2]

  # make these into user-inputs later.
  θ = RKHSRegularization.Spline34KernelType(θ_len)

  N = length(x)
  # TODO error handle if length(y) != length(x).
  Nq = length(xq)

  # do GP regression.
  X = collect( [x[n]] for n = 1:N )

  η = RKHSRegularization.RKHSProblemType( zeros(Float64,length(X)),
                       X,
                       θ,
                       σ²)
  RKHSRegularization.fitRKHS!(η, y)

  # query.
  #xq = collect( [xq_range[n]] for n = 1:Nq )
  #f_xq = f.(xq_range) # generating function.

  yq = Vector{Float64}(undef, Nq)
  Xq = collect( [xq[n]] for n = 1:Nq )
  RKHSRegularization.query!(yq, xq, η)

  # assemble output.

  json("$(yq)")
#  json("$(jsonpayload()["x"]), $(jsonpayload()["y"])")


end

up()
