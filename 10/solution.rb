#!/usr/bin/ruby -w

data = File.read("input.txt").split
data.map! { |x| x.to_i }

# Part 1, simple list traversal, counting the number
# of differences of 1 and 3 in the list
jolts = 0
diff1 = 0
diff3 = 0

data.sort.each{ |x|
  if x-jolts == 1
    diff1+=1
  elsif x-jolts == 3
    diff3+=1
  end

  if x-jolts<4
    jolts = x
  else
    raise ArgumentError.new("Too large difference at " + x)
  end         
}

jolts+=3
diff3+=1

puts diff1
puts diff3
puts diff3*diff1

# Part 2, combinatorics

# Recursive path solver, gets a DAG in a hash
# like {n=>[n1, n2, n3], n2=>[n3, n7] ...}
# The stupidly simple version is too memory-hungry
# and slow for the input, so it won't work. Even
# when caching this ate up all my memory.
def solve(graph, start, stop)  
  if start == stop
    # Halting condition, only one way out
    $pathcache.store(stop, [[stop]] )
    return [[stop]]
  else
    if not $pathcache.has_key?(start)
      $pathcache.store(start,[])
    end
    graph[start].lazy.each { |nxt|      
      if $pathcache.has_key?(nxt)
        nextpaths =  $pathcache[nxt]
      else
        nextpaths = solve(graph, nxt, stop)
        $pathcache.store(nxt, nextpaths)
      end
      nextpaths.lazy.each { |path|
        tmp = []
        tmp.replace(path)
        tmp.push(nxt)

        $pathcache[start].push(tmp)
      }
    }
    return $pathcache[start]
  end
end

# Don't return any paths, just count the possibilities
# This is also pretty slow without caching the results.
def countpaths(graph, start, stop)
  if start == stop
    return 1
  else    
    sum = 0
    graph[start].each { |nxt|
      if $pathcache.has_key?(nxt)
        tmp = $pathcache[nxt]
      else
        tmp = countpaths(graph, nxt, stop)
        $pathcache.store(nxt, tmp)
      end
      sum += tmp      
    }
    return sum
  end
end



# Build an hash of arrays mapping each number in data
# to its potential successors (i.e. difference is 0<x<4)
successors = Hash.new
# To simplify, we add the start and end point (0 and jolts)
# into the graph
data << 0
data << jolts
               
data.sort.each{ |x|
  succ = data.select { |n| n > x && n < x+4 }
  successors.store(x, succ)
}

puts successors

# Need to init the cache before trying to solve.
# This should be reworked into some class based
# solution instead of a global.
$pathcache = Hash.new

# Too slow for the real assignment, handles the
# test case that ends up at 19208 paths just fine.
#paths = solve(successors, 0, jolts)
#puts paths.length()

paths = countpaths(successors, 0, jolts)
puts paths

