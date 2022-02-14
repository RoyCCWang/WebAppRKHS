# WebAppRKHS

[![Build Status](https://github.com/RoyCCWang/WebAppRKHS.jl/workflows/CI/badge.svg)](https://github.com/RoyCCWang/WebAppRKHS.jl/actions)
[![Coverage](https://codecov.io/gh/RoyCCWang/WebAppRKHS.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/RoyCCWang/WebAppRKHS.jl)


This is a package where I explore different ways to call my `PatchMixtureKriging` Julia package via REST. The `PatchMixtureKriging` package is a curve fitting package based on the Gaussian process regression, which is related to Bayesian filtering methods. It has applications in tracking and control systems. The `PatchMixtureKriging` package hosted on a webserver [http://rwresearch.ca](http://rwresearch.ca), and the client sends input data to the server to get a fitted curve back for display. Although `PatchMixtureKriging` can handle multiple dimensions and large data sets, we restrict to fitting a few points in a 1D regression setting here because the focus here is for me to explore different algorithm deployment methods on the cloud.

So far, I have explored using the [Genie](https://github.com/GenieFramework/Genie.jl) framework, which is a MVC web framework for Julia, similar to Python's Django.
The script deployed on the server is `src/rest_1D_regression.jl`. To send a few points to the server, then use MatPlotLib to plot the returned curve, see `src/query_1D_regression.jl`. You can run `src/query_1D_regression.jl` for a demo for fitting data generated from the sinc-like oracle function on `line 10`.

For real-time applications, latency and dropouts need to be addressed. For time-consuming algorithms, concurrency issues from multiple user requests while the server is busy need to be addressed. I plan to explore a JavaScript frontend + Golang backend setup when I explore these issues in the future.
