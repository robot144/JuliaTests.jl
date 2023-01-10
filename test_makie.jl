
# Purpose: test Makie.jl
# Author: robot144@protonmail.com
# Create some simple plots using Makie.jl
#using CairoMakie
#using ElectronDisplay
using GLMakie

f=Figure(resolution=(500,500))
ax=Axis(f[1,1],xlabel="x",ylabel="y",title="title")
x=range(0,2*pi,length=100)
ysin=sin.(x)
ycos=cos.(x)
l1=lines!(ax,x,ysin,color=:black)
l2=lines!(ax,x,ycos,color=:blue)
display(f) #using ElectronDisplay
save("fig_sincos.png",f) #write to png file