# Play with some netcdf files
#
#

using NetCDF

debug=1

#mutable struct NcFile
#    ncid::Int32
#    nvar::Int32
#    ndim::Int32
#    ngatts::Int32
#    vars::Dict{String,NcVar}
#    dim::Dict{String,NcDim}
#    gatts::Dict
#    nunlimdimid::Int32
#    name::String
#    omode::UInt16
#    in_def_mode::Bool
#end
#mutable struct NcDim
#  ncid::Int32
#  dimid::Int32
#  varid::Int32
#  name::String
#  dimlen::UInt
#  vals::AbstractArray
#  atts::Dict
#  unlim::Bool
#end
#mutable struct NcVar{T,N,M} <: AbstractArray{T,N}
#    ncid::Int32
#    varid::Int32
#    ndim::Int32
#    natts::Int32
#    nctype::Int32
#    name::String
#    dimids::Vector{Int32}
#    dim::Vector{NcDim}
#    atts::Dict
#    compress::Int32
#    chunksize::NTuple{N,Int32}
#end

mutable struct NcDefs
   filename::String
   vars::Dict{String,NcVar}
   dims::Dict{String,NcDim}
   gatts::Dict{String,Any}
end

function get_variables(filename)
   info=ncinfo(filename)
   return keys(info.vars)
end

function ncdefs_from(fromfile::String)
   info=ncinfo(fromfile)
   defs=NcDefs(fromfile,Dict{String,NetCDF.NcVar}(),Dict{String,NetCDF.NcDim}(), Dict{String,Any}())
   from_dims=info.dim
   for key in keys(from_dims)
       dim=from_dims[key]
       defs.dims[key]=NcDim(key, dim.dimlen, atts=dim.atts, unlimited=dim.unlim)
   end
   defs.gatts=info.gatts
   from_vars=info.vars
   for key in keys(from_vars)
       (debug>0) && println(key)
       var=from_vars[key]
       dimnames=[dim.name for dim in var.dim]
       dims=[defs.dims[dim.name] for dim in var.dim]
       #defs.vars[key]=NcVar(key, dims, atts=var.atts, t=NetCDF.nctype2jltype[var.nctype],compress=var.compress,chunksize=var.chunksize)
       #                                               type breaks down on strings
       defs.vars[key]=NcVar(key, dims, atts=var.atts, t=Int64(var.nctype),compress=var.compress,chunksize=var.chunksize)
   end
   return defs
end

function create_from_defs(tofile,defs::NcDefs)
   vararray=collect(values(defs.vars))
   nc=NetCDF.create(tofile,vararray,gatts=defs.gatts,mode=NC_NETCDF4)
   return nc
end

function copy_var_from(defs::NcDefs,varname::String,nc::NcFile)
   var=defs.vars[varname]
   infile=defs.filename
   if(prod(size(var))<1e6) #copy small stuff in one go
      NetCDF.putvar(nc,varname,collect(ncread(infile,varname)))
   else
      #nothing yet
      #NetCDF.putvar(nc,varname,collect(ncread(infile,varname)))
   end
end


# initial test
hisfile="../test_data/estuary_his.nc"

# create a file
tofile="test001.nc"
isfile(tofile) && rm(tofile)
defs=ncdefs_from(hisfile)
nc=create_from_defs(tofile,defs)
copy_var_from(defs,"waterlevel",nc)
NetCDF.close(nc)
