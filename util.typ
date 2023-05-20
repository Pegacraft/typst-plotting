

// Prepares everything for a plot and executes the function that draws a plot. Supplies it with width and height
// size: the size of the plot either as array(width, height) or length
// caption: the caption for the plot
// capt_dist: distance from plot to caption
//-------
// the plot code: a function that needs to look accept 3 parameters (width, height, caption_distance)
// width: the width of the plot
// height: the height of the plot
// caption_distance: the distance between the caption and the plot (required for drawing axes)
//-------
#let prepare_plot(size, caption, capt_dist: 20pt, plot_code) = {
  let (width, height) = if type(size) == "array" {size} else {(size, size)}
  figure(caption: caption, supplement: "Graph", kind: "plot")[#box(stroke: none, width: width, height: height + capt_dist)[
    #{
      width = if type(width) == "ratio" {100%} else {width}
      height = if type(height) == "ratio" {100% - capt_dist} else {height}
      set align(left + bottom)
      plot_code(width, height, capt_dist)
      v(capt_dist)
    }
  ]]
}

// Calculates step size for an axis
// full_dist: the distance of the axis while drawing (most likely width or height)
// axis: the axis
// returns: the step size
#let calc_step_size(full_dist, axis) = {
  return full_dist / axis.values.len() / axis.step
}