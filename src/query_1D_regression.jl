
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


##########
import RKHSRegularization
incoming_array = input_array

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
RKHSRegularization.query!(yq, Xq, η)

import PyPlot
PyPlot.close("all")
fig_num = 1

PyPlot.figure(fig_num)
fig_num += 1

PyPlot.plot(X, y, ".", label = "observed")
PyPlot.plot(xq, yq, label = "GP mean function")

title_string = "1D GP regression"
PyPlot.title(title_string)
PyPlot.legend()


@assert 1==43

q =  """{"input_array":$(input_array)}"""

z = HTTP.request("POST", "http://localhost:8000/jsonpayload",
    [("Content-Type", "application/json")], q)

h = String(HTTP.payload(z.request))

dic = JSON3.read(h)
#Z = convert(Vector{Vector{Float64}}, dic["input_array"])
