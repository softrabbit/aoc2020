;; I'm so like a fish out of water on this one,
;; improvising using what I find on the interwebs and lots of guesswork
(require '[clojure.string :as str])

;; Load the file into a list
;; https://www.tutorialspoint.com/clojure/clojure_file_io.htm
(defn Load [file]
  (with-open [rdr (clojure.java.io/reader file) ]
    (reduce conj [] (line-seq rdr))))

;; https://stackoverflow.com/questions/5621279/in-clojure-how-can-i-convert-a-string-to-a-number
(defn parse-int [s]
  (Integer. (re-find #"\d+" s)))

;; Very coarse trig. Expects integer degrees for N/E/S/W
(defn sin [d] (nth [0,1,0,-1] (/ d 90)))
(defn cos [d] (nth [1,0,-1,0] (/ d 90)))

;; Move in a certain direction. Let's hope it's always in multiples of 90
(defn Forward [h x y l]
  [h
   (+ x (* l (sin h) ))
   (+ y (* l (cos h) ))]
  )

;; Handle one navigation step, i.e. "R90" or such
;; and return modified heading and coordinates
(defn NavStep [step h x y]
  (case (str(first step))
    "N" [h x (+ y (parse-int step))]
    "S" [h x (- y (parse-int step))]
    "E" [h (+ x (parse-int step)) y]
    "W" [h (- x (parse-int step)) y]
    "L" [(mod (- h (parse-int step)) 360) x y]
    "R" [(mod (+ h (parse-int step)) 360) x y]
    "F" (Forward h x y (parse-int step))
    ))

;; Follow the instructions, i.e.
;; navigate from one spot to the next until no more path
;; Return the coordinates when done.
(defn Navigate [path heading x y]
  (if (empty? path)
    [x y]
    (let [ [ new_h new_x new_y] ;; Yay, variables!
          (NavStep (first path) heading x y)] 
      (Navigate (rest path) new_h new_x new_y))))


;; Start navigation at (0,0), facing east
;; (going in compass degrees, not geometry)
;; This should end up at [17, -8].
(println (Navigate ["F10" "N3" "F7" "R90" "F11"] 90 0 0))

;; Solution to part 1.
(println (reduce + (map (fn [x] (Math/abs x))
                      (Navigate (Load "input.txt") 90 0 0))))


   
