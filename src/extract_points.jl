
using NetCDF

info=ncinfo("totslr_mean_rcp45_ts.nc")
x=info.vars["x"]
y=info.vars["y"]
t=info.vars["t"]
z=info.vars["z"]
(zx,zy,zt)=size(z)

xp=[-1.5, -1.5, -1.5, 7.5]
xp=[ (x<=0)?x+360:x for x in xp ]
yp=[49.5, 50.5, 56.5, 56.5]
np=length(xp)

#find nearest
xi=zeros(Int64,np)
yi=zeros(Int64,np)
for i=1:np
   (val,imin)=findmin(abs.(x-xp[i]))
   xi[i]=imin
   (val,imin)=findmin(abs.(y-yp[i]))
   yi[i]=imin
end

zp=zeros(Float64,np,zt)
for i=1:np
    zp[i,:]=squeeze(z[xi[i],yi[i],:],(1,2))
end

filename="extracted_sealevel_rise_rcp45.nc"
ip=collect(1:np)
isfile(filename) && rm(filename)
nccreate(filename, "z", "station_index", ip, "t", Array(t), Dict("units"=>"yr"), atts=Dict("units" => "m"))
nccreate(filename, "x", "station_index", ip,Dict("standard_name" => "lon"))
nccreate(filename, "y", "station_index", ip,Dict("standard_name" => "lat"))
ncwrite(zp,filename,"z")
ncwrite(xp,filename,"x")
ncwrite(yp,filename,"y")
