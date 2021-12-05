
import Pkg
Pkg.add(path="https://github.com/RoyCCWang/RKHSRegularization")
Pkg.add("Genie")

using Genie, Genie.Router, Genie.Requests, Genie.Renderer.Json

import RKHSRegularization

#Genie.config.run_as_server = true

# test case to see if server is up.
route("/hello") do
  "Hello World"
end

function errorcheck1Dregression(x::Vector{T}, y::Vector{T}, xq::Vector{T}, θ_len::T, σ²::T)::Bool where T
    # check length.
    if length(x) != length(y)
        return false
    end

    # check finite input.
    if !(all(isfinite.(x)) & all(isfinite.(y)) & all(isfinite.(xq)))
        return false
    end

    # check if positive numbers for the hyperparameters.
    if !(0 < θ_len < Inf && 0 < σ² < Inf)
        return false
    end

    return true
end

# unrecognized inputs.
function errorcheck1Dregression(x, y, xq, θ_len, σ²)::Bool
    return false
end

function geterrormessage1Dregression()
    return "Please check your inputs. The input format is:
    input_array = Vector{Vector{Float64}}(undef, 4)
    input_array[1] = x
    input_array[2] = y
    input_array[3] = xq
    input_array[4] = [θ_len; σ²]"
end

function run1Dregression!(yq::Vector{T}, x::Vector{T}, y::Vector{T}, xq::Vector{T}, θ_len::T, σ²::T)::Nothing where T

    θ = RKHSRegularization.Spline34KernelType(θ_len)

    N = length(x)
    Nq = length(xq)

    # do GP regression.
    X = collect( [x[n]] for n = 1:N )

    η = RKHSRegularization.RKHSProblemType( zeros(Float64,length(X)),
                     X,
                     θ,
                     σ²)
    RKHSRegularization.fitRKHS!(η, y)

    # query.
    resize!(yq, Nq)
    Xq = collect( [xq[n]] for n = 1:Nq )
    RKHSRegularization.query!(yq, Xq, η)

    return nothing
end

route("/jsonpayload", method = POST) do
  #@show jsonpayload()
  #@show rawpayload()

  incoming_array = jsonpayload()["input_array"]
  #println("typeof(incoming_array) = ", incoming_array)
  x = convert(Vector{Float64}, incoming_array[1])
  y = convert(Vector{Float64}, incoming_array[2])
  xq = convert(Vector{Float64}, incoming_array[3])

  hyperparams = convert(Vector{Float64}, incoming_array[4])
  θ_len = hyperparams[1]
  σ² = hyperparams[2]

  # error check.
  flag = errorcheck1Dregression(x, y, xq, θ_len, σ²)

  yq = Vector{Float64}(undef, 0)
  if flag

    run1Dregression!(yq, x, y, xq, θ_len, σ²)

    # assemble output.
    println("Done yq")
  else
    println("Bad input")
    out = geterrormessage1Dregression()
    #push!(yq, Inf)
  end

  json(yq)
end

up(async = false) # block the execution of this script.
#up()
#Genie.startup()
