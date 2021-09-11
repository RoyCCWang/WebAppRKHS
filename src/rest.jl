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

route("/jsonpayload", method = POST) do
  @show jsonpayload()
  @show rawpayload()

  json("Hello $(jsonpayload()["input_array"])")
#  json("$(jsonpayload()["x"]), $(jsonpayload()["y"])")


  # # make these into user-inputs later.
  # θ = RKHSRegularization.Spline34KernelType(0.04)
  # σ² = 1e-3
  #
  # # move uploaded file.
  # f_name = filename(filespayload(:yourfile))
  #  print("f_name = $(f_name)") # debug.
  #
  # # load to file.
  # x_string = readtargetnames(f_name)
  # x = collect( tryparse(Float64, x_string[i]) for i = 1:length(x_string) )
  # filter!(xx->typeof(xx)<:Real, x) # in case there are empty lines.
  #
  # N = length(x)
  # println(x)
  #
  # # do GP regression.
  # X = collect( [x[n]] for n = 1:N )
  #
  # f = xx->sinc(4*xx)*xx^3 # oracle.
  # y = f.(x)
  #
  # η = RKHSRegularization.RKHSProblemType( zeros(Float64,length(X)),
  #                      X,
  #                      θ,
  #                      σ²)
  # RKHSRegularization.fitRKHS!(η, y)
  #
  #
  #
  # # query.
  # Nq = 1000
  # xq_range = LinRange(x[1], x[end], Nq)
  # xq = collect( [xq_range[n]] for n = 1:Nq )
  #
  # f_xq = f.(xq_range) # generating function.
  #
  # yq = Vector{Float64}(undef, Nq)
  # RKHSRegularization.query!(yq,xq,η)

end

up()
