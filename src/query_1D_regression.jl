
import Pkg

try
   import HTTP
catch er
   Pkg.add("HTTP")
end


try
   import JSON3
catch er
   Pkg.add("JSON3")
end

try
   import PyPlot
catch er
   Pkg.add("PyPlot")
end


f = xx->sinc(4*xx)*xx^3 # oracle function to fit.

# generate data.
x_range = LinRange(-3, 5, 20)
y = f.(x_range)

# the query positions for plotting.
Nq = 1000
xq_range = LinRange(x_range[1], x_range[end], Nq)

# specify Gaussian process regression tuning parameters.
θ_len = 0.34
σ² = 1e-3
hyperparams = [θ_len; σ²]

# set up and send to microservice.
xq = collect(xq_range)
x = collect(x_range)

input_array = Vector{Vector{Float64}}(undef, 4)
input_array[1] = x
input_array[2] = y
input_array[3] = xq
input_array[4] = hyperparams

# put into the JSON format that the server script is expecting.
q =  """{"input_array":$(input_array)}"""

# z = HTTP.request("POST", "http://localhost:8000/jsonpayload",
#     [("Content-Type", "application/json")], q)

z = HTTP.request("POST", "http://rwresearch.ca/jsonpayload",
    [("Content-Type", "application/json")], q)

#out = convert(Vector{Float64}, z.body)
h = String(z.body)
out_j3 = JSON3.read(h)
yq = convert(Vector{Float64}, out_j3)

# if the server was successful in fitting a curve, i.e., the queried points yq is non-empty,
#   plot.
if !isempty(yq)
    import PyPlot
    PyPlot.close("all")
    fig_num = 1

    PyPlot.figure(fig_num)
    fig_num += 1

    PyPlot.plot(x, y, ".", label = "observed")
    PyPlot.plot(xq, yq, label = "GP mean function")

    title_string = "1D GP regression"
    PyPlot.title(title_string)
    PyPlot.legend()
else
    print("Bad input. The algorithm on the server failed to fit a Gaussian process regression model.")
end
