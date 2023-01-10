# playing with Tasks based on documentation

#
# Tasks
#

#define a task
t = @task begin; sleep(5); println("done"); end
# start it
schedule(t)
# start and wait for it
schedule(t);wait(t)
# combine @task and schedule with @async

#
# Channels
#
#define producer
function producer(c::Channel)
   put!(c, "start")
   for n=1:4
       put!(c, n)
   end
   put!(c, "stop")
end;
#create channel
chnl = Channel(producer);
#consume results
for x in Channel(producer)
   println(x)
end

function maker(n)
   for i=1:3
      println("n=$(n), i=$(i)")
   end
end

#
# Example with tasks and channels
#
const jobs = Channel{Int}(2); #channel can hold 32 Int's
const results = Channel{Tuple}(2);

function do_work()
    for job_id in jobs
        exec_time = rand()
        sleep(exec_time)                # simulates elapsed time doing actual work
                                        # typically performed externally.
        put!(results, (job_id, exec_time))
    end
end;

function make_jobs(n)
    for i in 1:n
        put!(jobs, i)
    end
end;

n = 12;

@async make_jobs(n); # feed the jobs channel with "n" jobs

for i in 1:4 # start 4 tasks to process requests in parallel
    @async do_work()
end

@elapsed while n > 0 # print out results
    job_id, exec_time = take!(results)
    println("$job_id finished in $(round(exec_time; digits=2)) seconds")
    global n = n - 1
end

#
# Multi threading
#
# pre v1.5
export JULIA_NUM_THREADS=4
julia
# post v1.5
julia --threads 4

n=Threads.nthreads()
id=Threads.threadid() #we are on the main thread 1

a=zeros(10)
Threads.@threads for i = 1:10
   a[i] = Threads.threadid()
end
#another example
function mywork(n)
   println("working on $(n) at $(Threads.threadid())")
   sleep(1.0)
   println("done")
   return 1.0*n
end
Threads.@threads for i = 1:10
   a[i] = mywork()
end
# Note that locking and race conditions are up to the programmer


#
# parallel processes
#
n=nprocs() #number of processes add eg with julia -p 2 then returns 3
addprocs(1) #add another process
p=procs() #return process ids typically 1:n

#elastic cluster manager
using ClusterManagers
using Pkg
em = ElasticManager(addr=:auto, port=0)

function get_connect_cmd(em::ElasticManager)
   io=IOBuffer()
   show(io,em) #writes to buffer instead of screen
   temp1=read(seekstart(io),String)
   temp2=split(temp1,"\n")
   return temp2[end]
end
