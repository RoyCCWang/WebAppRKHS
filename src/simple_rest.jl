
# https://genieframework.github.io/Genie.jl/dev/tutorials/7--Using_JSON_Payloads.html
using Genie, Genie.Router, Genie.Requests, Genie.Renderer.Json

route("/jsonpayload", method = POST) do
  @show jsonpayload()
  @show rawpayload()

  #json("Hello $(jsonpayload()["name"])")
  json("Hello $(jsonpayload()["name"])")
end

up()
