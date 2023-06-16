

// Prepares everything for a plot and executes the function that draws a plot. Supplies it with width and height
// size: the size of the plot either as array(width, height) or length
// caption: the caption for the plot
// capt_dist: distance from plot to caption
//-------
// width: the width of the plot
// height: the height of the plot
// the plot code: a function that needs to look accept 2 parameters (width, height)
//-------
#let prepare_plot(size, caption, plot_code) = {
  let (width, height) = if type(size) == "array" {size} else {(size, size)}
  figure(caption: caption, supplement: "Graph", kind: "plot")[
    // Graph box
    #set align(left + bottom)
    #box(width: width, height: height, fill: none, plot_code())
  ]
}

// Calculates step size for an axis
// full_dist: the distance of the axis while drawing (most likely width or height)
// axis: the axis
// returns: the step size
#let calc_step_size(full_dist, axis) = {
  return full_dist / axis.values.len() / axis.step
}

// transforms a data list ((amount, value),..) to a list only containing values
#let transform_data_full(data_count) = {
  
  if not type(data_count.at(0)) == "array" {
    return data_count
  }
  let new_data = ()
  for (amount, value) in data_count {
    for _ in range(amount) {
      new_data.push(value)
    }
  }
  return new_data
}

// transforms a data list (val1, val2, ...) to a list looking like this ((amount, val1),...)
#let transform_data_count(data_full) = {
  if type(data_full.at(0)) == "array" {
    return data_full
  }

  // count class occurances
  let new_data = ()
  for data in data_full {
   let found = false
   for (idx, entry) in new_data.enumerate() {
     if data == entry.at(1) {
       new_data.at(idx).at(0) += 1
       found = true
       break
     }
   }
   if not found {
      bin_count.push((1, data))
   }
  }
  return new_data
}