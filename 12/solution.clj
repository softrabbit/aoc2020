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

;; Very coarse trig. Expects integer compass degrees.
(defn sin [d] (nth [0  1  0 -1] (/ d 90)))
(defn cos [d] (nth [1  0 -1  0] (/ d 90)))

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

;; Solution 2
;; Rotate the waypoint, clockwise is positive, anticlockwise negative.
;; We don't need the x and y here, but getting and returning them is
;; IMO slightly more readable than using "let" for the calls to rot in
;; NavStep2. There must be eleganter ways to solve this.
(defn rot [x y wpx wpy d]
  (case (mod d 360)
    0   [x y wpx wpy]
    90  [x y wpy (* -1 wpx)]
    180 [x y (* -1 wpx) (* -1 wpy)]
    270 [x y (* -1 wpy) wpx]
    )
)
;; Here the waypoint is moved and rotated 
;; and only F is going to move the ship.
(defn NavStep2 [step x y wpx wpy]
  (case (str(first step))
    "N" [x y wpx (+ wpy (parse-int step))]
    "S" [x y wpx (- wpy (parse-int step))]
    "E" [x y (+ wpx (parse-int step)) wpy]
    "W" [x y (- wpx (parse-int step)) wpy]
    "L" (rot x y wpx wpy (* -1 (parse-int step)))
    "R" (rot x y wpx wpy (parse-int step))
    "F" [(+ x (* wpx (parse-int step))) (+ y (* wpy (parse-int step))) wpx wpy]
    ))

;; Navigation, corrected. Need to have the waypoint coordinates
;; passed along throughout. OTOH, that leaves the heading redundant
(defn Navigate2 [path x y wpx wpy]
  (if (empty? path)
    [x y]
    (let [ [ new_x new_y new_wpx new_wpy ]
          (NavStep2 (first path) x y wpx wpy)] 
      (Navigate2 (rest path) new_x new_y new_wpx new_wpy))))


;; Start navigation at (0,0), facing east
;; (going in compass degrees, not geometry)
;; This should end up at [17, -8].
(println (Navigate ["F10" "N3" "F7" "R90" "F11"] 90 0 0))

;; Solution to part 1.
(println (reduce + (map (fn [x] (Math/abs x))
                      (Navigate (Load "input.txt") 90 0 0))))


;; Part 2
;; This should end up at [214, -72].
(println (Navigate2 ["F10" "N3" "F7" "R90" "F11"] 0 0 10 1))

;; Solution 
(println (reduce + (map (fn [x] (Math/abs x))
                        (Navigate2 (Load "input.txt")
                                  0 0 10 1))))
