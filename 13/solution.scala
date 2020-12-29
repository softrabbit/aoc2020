import scala.io.Source
import scala.util.Try
import scala.util.Sorting
import scala.collection.SortedMap
import scala.util.control.Breaks._

object AdventOfCode {

  def main(args: Array[String]): Unit = {
    // Read bus numbers and time from file
    if(args.size == 0) {
      println("No input file")
      sys.exit(0);
    }
    val data = Source.fromFile(args(0)).getLines()

    // First line is time
    val now = data.next.toInt

    // Second line says which buses are servicing this stop
    // This'll crash and burn at the slightest data hiccup
    val bus_str = data.next()

    // Solution, part 1
    // Check which bus will leave next and how many minutes from now, 
    // i.e. find the one with smallest "anti-remainder" after division
    // (is there a word for the distance to next multiple?)

    // Can't figure out how to get Try straight into the filter predicate
    // so I'll make this
    def isInt(n: String): Boolean = Try(n.toInt).isSuccess
    val buses = bus_str.split(",").filter(isInt(_)).map(x => x.toInt)

    var minutes = now // Ad-hoc upper limit on timestamp
    var busid = 0
    var rem = 0
    buses.foreach{x => {rem = x - (now % x);
			if(rem<minutes) {
			  minutes=rem; busid=x
			}
		      }
		}
    println(busid)
    println(minutes)
    println(busid*minutes)
    println("----")


    // Solution, part 2
    // Here we need to find a timestamp such that the buses will leave
    // at staggered times corresponding to their positions in the list
    // i.e. buses2[0] leaves at T+0, [1] at T+1 etc.

    // There's probably some clever math trick to solve this,
    // but I'm going the slow way thorugh iteration for now.

    // Need to keep the x:es as well this time
    val tmp = bus_str.split(",")
    // Incantations from the depths of Stackoverflow
    // to have the bus intervals map to their desired 
    // offsets in the solution, sorted largest first
    var busmap:SortedMap[Int, Int] = 
      SortedMap.empty(Ordering[Int].reverse)

    for (i <- 0 to tmp.length -1) {
      if(isInt(tmp(i))) {
	busmap += (tmp(i).toInt -> i)
	printf("%d -> %d\n",tmp(i).toInt, i)
      }
    }
    var done = false
    val maxinterval = busmap.keys.max
    val maxoffset = busmap(maxinterval) // Not the maximum offset, but the offset for the max interval
    var timestamp = 0 :Long
    var n = 0
    while(!done) {
      // Output one number for roughly a million checks
      // to show some progress. 
      n += 1
      if( (n & 0xfffff) == 0) { println(timestamp) }

      var it = busmap.keys.iterator
      var c = it.next()
      timestamp += c // Step size = largest interval
      done = true // Wishful thinking
      breakable {
	while(it.hasNext) {
	  c = it.next()
	  var offset = busmap(c) - maxoffset
	  if( (timestamp+offset) % c != 0) {
	    done = false
	    // I hear this is the wrong way to do it, 
	    // but it sure makes the code run faster
	    break 
	  } 
	}
      }
    }
    println(timestamp - maxoffset)
  }
}
