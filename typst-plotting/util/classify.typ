#import "util.typ": *

//-----------------
//THIS FILE CONTAINS EVERYTHING TO CLASSIFY DATA
//-----------------


// How data should be compared
// Can be overwritten in the respective methods in case data looks different
// Needs to return -1 if val1 < val2
// Needs to return 1 if val1 > val2
// Needs to return 0 if val1 == val2
#let compare(val1, val2) = {
  return if val1 < val2 {-1} else if val1 > val2 {1} else {0}
}

// Creates a class used to classify data
// its range is [lower_lim; upper_lim[
#let class(lower_lim, upper_lim) = {
  return (
    lower_lim: lower_lim,
    upper_lim: upper_lim,
    data: ()
  )
}

// Generates a number of classes that follow a certain pattern
// start: Starting number
// end: Ending number
// amount: How many classes should be generated
#let class_generator(start, end, amount) = {
  let step = int((end - start) / amount)
  let classes = ()
  for value in range(start, end, step: step) {
    classes.push(class(value, value + step))
  }
  return classes
}

// Classifies given data into a class
// data: the data you want to classify (needs to be comparable by the compare function)
// classes: the class/classes the data should be mapped to (min, max need to be comparable)
// compare: the method used for comparing. Looks like this: compare(val1, val2)
//          returns: val1 < val2: -1; val1 > val2: 1; val1 == val2: 0
#let classify(data, classes, compare: compare) = {
  let data = transform_data_full(data)
  let classes = if "lower_lim" in classes {(classes,)} else {classes}
  for (idx, class) in classes.enumerate() {
    for value in data {
      if compare(value, class.lower_lim) >= 0 and compare(value, class.upper_lim) <= -1 {
        class.data.push(value)
      }
    }
    classes.at(idx) = class
  }
  return if classes.len() == 1 {classes.at(0)} else {classes}
}