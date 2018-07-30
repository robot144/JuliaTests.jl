
type TreeVector
   data::Array
   left::Nullable{TreeVector}
   right::Nullable{TreeVector}
   function TreeVector(data::Array)
      return new(data,Nullable{TreeVector}(),Nullable{TreeVector}())
   end
end

#No way to instantiate?
