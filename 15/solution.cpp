#include <iostream>
#include <unordered_map>

using namespace std;

// Maps a number to when it was last spoken.
// std::map makes this run 3-4x slower!
unordered_map<int, int> numbers;

// Speak a number and write it down
// If number has never been spoken before, return 0.
// Otherwise return distance to previous occurrance.
int speak(int n, int round, bool start) {
  int p;

  if(numbers.find(n) == numbers.end()) {
    numbers[n] = round;
    return 0;    
  } else {
    p = round - numbers[n];
    numbers[n] = round;
    return p;
  }
}

int main() {

  // With these two lines, expect last number to be 436
  // const int FIRSTS = 3;
  // int first[FIRSTS] = {0,3,6};

  // The actual puzzle input
  const int FIRSTS = 6;
  int first[FIRSTS] = {1,12,0,20,8,16};

  const int ROUNDS = 30000000; // 2020 in part 1
  
  int round;
  int next;

  // Speak the starting numbers
  for(round=0; round<FIRSTS; round++) {
    next = speak(first[round], round, true);
    // cout << first[round] << "  ";
  }
  // Speak the rest (NB. the -1 because we're always
  // looking at the NEXT value)
  for(; round<ROUNDS-1; round++) { 
    // cout << next << "  "; // << "(" << round << ")" << endl;
    next = speak(next, round, false);
  }
  cout << next << endl;
  return 0;
}
