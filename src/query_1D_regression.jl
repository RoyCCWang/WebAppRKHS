
import HTTP
import JSON3

x_range = LinRange(-3, 5, 20)
f = xx->sinc(4*xx)*xx^3 # oracle.
y = f.(x_range)

Nq = 1000
xq_range = LinRange(x_range[1], x_range[end], Nq)

θ_len = 0.34
σ² = 1e-3
hyperparams = [θ_len; σ²]

xq = collect(xq_range)
x = collect(x_range)

# set up and send to microservice.
input_array = Vector{Vector{Float64}}(undef, 4)
input_array[1] = x
input_array[2] = y
input_array[3] = xq
input_array[4] = hyperparams


#import RKHSRegularization
#incoming_array = input_array


q =  """{"input_array":$(input_array)}"""

# z = HTTP.request("POST", "http://localhost:8000/jsonpayload",
#     [("Content-Type", "application/json")], q)

z = HTTP.request("POST", "http://rwresearch.ca/jsonpayload",
    [("Content-Type", "application/json")], q)

#out = convert(Vector{Float64}, z.body)
h = String(z.body)
out_j3 = JSON3.read(h)
yq = convert(Vector{Float64}, out_j3)

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
    print("Bad input.")
end
