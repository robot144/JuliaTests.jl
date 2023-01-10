import xarray as xr
import numpy as np

# create data
data = np.random.randn(2, 3)
# create coords
rows = [1,2]
cols = [1,2,3]

# put data into a dataset
ds = xr.Dataset(
    data_vars=dict(
        variable=(["x", "y"], data)
    ),
    coords=dict(
        lon=(["x"], rows),
        lat=(["y"], cols),
    ),
    attrs=dict(description="coords with vectors"),
)


encoding={'variable': {'_FillValue': -9999, 'scale_factor': 0.01, 'add_offset': -1.0, 'dtype': 'int16'}}

ds.to_zarr("example.zarr",encoding=encoding)
ds.to_netcdf("example.nc",encoding=encoding)

reopened = xr.open_dataset("example.zarr",engine='zarr')

reopened

remote_zarr=xr.open_dataset("https://nx7384.your-storageshare.de/apps/sharingpath/wetwin/public/test/example.zarr",engine="zarr")
remote_nc=xr.open_dataset("https://nx7384.your-storageshare.de/apps/sharingpath/wetwin/public/test/example.nc",engine="h5netcdf")


