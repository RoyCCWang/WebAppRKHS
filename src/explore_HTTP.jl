
using Genie.Renderer.Json
import JSON3
import HTTP

yq = randn(3)

z = json(yq)

h = String(z.body)
out_j3 = JSON3.read(h)
out = convert(Vector{Float64}, out_j3)
