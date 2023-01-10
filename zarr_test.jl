using Zarr
z1 = zcreate(Int, 10000,10000,path = "data/example.zarr",chunks=(1000, 1000))
z1[:] .= 42
z1[:,1] = 1:10000
z1[1,:] = 1:10000



z2 = zopen("example.zarr") #default in read-only mode

var=z2.arrays["variable"]
zinfo(var) #show chunks, size etc.
v=var.attrs["scale_factor"]*var[:,:]+var.attrs["add_offset"] #manual scaling, different from xarray

z3=zopen("https://nx7384.your-storageshare.de/apps/sharingpath/wetwin/public/test/example.zarr")

