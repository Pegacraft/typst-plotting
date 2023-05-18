#import "axis.typ": *
#import "classify.typ": *
#import "util.typ": *

// Creates a data representation of a plot
// axes: a list of axes needed for drawing the plot (most likely and x and a y axis)
// data: the data that should be mapped onto the plot. The format depends on the plot type
#let plot(axes: (), data: ()) = {
  let plot_data = (
    axes: axes,
    data: data
  )
  return plot_data
}

// Displayes a scatter plot if possible
//---
// The plot needs to look something like this:
// axis: two axes. One working as the x axis, the other as the y axis
// data: a tuple of x and y pairs
//---
// size: the size as array of (width, height) or as a single value for width and height
// caption: name of the figure
// stroke: the stroke color of the dots
// fill: the fill color of the dots
// caption_distance: the distance between the plot and the caption
#let scatter_plot(plot, size, caption: "Scatter Plot", stroke: black, fill: none, caption_distance: 20pt) = {
  
  // The code rendering the plot
  let plot_code(width, height, cd) = {
      let x_axis = plot.axes.at(0)
      let y_axis = plot.axes.at(1)
      // Draw coordinate system
      draw_axis(x_axis, length: width, length_offset: cd)
      draw_axis(y_axis, length: height, length_offset: cd)

      // Calculates distance for 1 unit
      let step_size_x = calc_step_size(width, x_axis)
      let step_size_y = calc_step_size(height, y_axis)

      // Places the data points
      for data in plot.data {
        // Converts the data to the actual coordinate
        // x data
        let data_x = if str(data.at(0)) == data.at(0) {
            x_axis.values.position(c => c == data.at(0))
          } else {data.at(0)}
        // the y data
        let data_y = if str(data.at(1)) == data.at(1) {
          y_axis.values.position(c => c == data.at(1))
        } else {data.at(1)}
        
        place(dx: (data_x - x_axis.min) * step_size_x - 1pt, dy: -(data_y - y_axis.min) * step_size_y - 1pt, square(width: 2pt, height: 2pt, fill: fill, stroke: stroke))
      }
  }

  // Sets outline for a plot and defines width and height and executes the plot code
  prepare_plot(size, caption, plot_code, capt_dist: caption_distance)
}

// Displayes a graph plot if possible
//---
// The plot needs to look something like this:
// axis: two axes. One working as the x axis, the other as the y axis
// data: a tuple of x and y pairs
//---
// size: the size as array of (width, height) or as a single value for width and height
// caption: name of the figure
// rounding: amount of rounded edges, ideally between 0 and 100%
// stroke: the stroke color of the line
// fill: the fill color of the line
// caption_distance: the distance between the plot and the caption
#let graph_plot(plot, size, caption: "Graph Plot", rounding: 0%, stroke: black, fill: none, caption_distance: 20pt) = {
  let plot_code(width, height, cd) = {
      let x_axis = plot.axes.at(0)
      let y_axis = plot.axes.at(1)

            // Draw coordinate system
      draw_axis(x_axis, length: width, length_offset: cd)
      draw_axis(y_axis, length: height, length_offset: cd)

      // Calculates distance for 1 unit
      let step_size_x = calc_step_size(width, x_axis)
      let step_size_y = calc_step_size(height, y_axis)

      // Places the data points
      let data = plot.data.map(data => { ((data.at(0) - x_axis.min) * step_size_x, -(data.at(1) - y_axis.min) * step_size_y - 1pt) })
      let delta = ()
      let rounding = rounding * -1
      for i in range(data.len()) {
        let curr = data.at(i)
        let next
        let prev
        if i != data.len() - 1 { next = data.at(i + 1) }
        if i != 0 { prev = data.at(i - 1) }
        if i == 0 {  
          delta.push((rounding * (next.at(0) - curr.at(0)), rounding * (next.at(1) - curr.at(1))))
          continue
        }
        if i == data.len() - 1 {
          delta.push((rounding * (curr.at(0) - prev.at(0)), rounding * (curr.at(1) - prev.at(1))))
          continue
        }
        delta.push((rounding * .5 * (next.at(0) - prev.at(0)), rounding * .5 * (next.at(1) - prev.at(1))))
      }
      
      place(dx: 0pt, dy: 1pt, path(fill: fill, stroke: stroke, ..data.zip(delta)))
      for p in data {
        place(dx: p.at(0) - 1pt, dy: p.at(1), square(size: 2pt, fill: black, stroke: none))
      }
  }

  prepare_plot(size, caption, plot_code, capt_dist: caption_distance)
}

// Displayes a histogram if possible
//---
// The plot needs to look something like this:
// axis: two axes. One working as the x axis, the other as the y axis
// data: a list of classes filled with data (see classify.typ)
//---
// size: the size as array of (width, height) or as a single value for width and height
// caption: name of the figure
// stroke: the stroke color of a bar
// fill: the fill color of a bar
// caption_distance: the distance between the plot and the caption
#let histogram(plot, size, caption: "Histogram", stroke: black, fill: gray, caption_distance: 20pt) = {
  let plot_code(width, height, cd) = {
    // Get the relevant axes:
    let x_axis = plot.axes.at(0)
    let y_axis = plot.axes.at(1)
    
    // Draw the axes
    draw_axis(x_axis, length: width, length_offset: cd)
    draw_axis(y_axis, length: height, length_offset: cd)
    
    // Calculates distance for 1 unit
    let step_size_x = calc_step_size(width, x_axis)
    let step_size_y = calc_step_size(height, y_axis)
    
    // Get count of values
    let val_count = 0
    for data in plot.data {
     val_count += data.data.len()
    }
    
    // Find most common class size
    // count class occurances
    let bin_count = ()
    for data in plot.data {
     let temp = data.upper_lim - data.lower_lim
     let found = false
     for (idx, entry) in bin_count.enumerate() {
       if temp == entry.at(1) {
         bin_count.at(idx).at(0) += 1
         found = true
         break
       }
     }
     if not found {
        bin_count.push((1, temp))
     }
    }
    // find most common one
    let common_class = bin_count.at(0)
    for value in bin_count {
     common_class = if value.at(0) > common_class.at(0) {value} else {common_class}
    }
    // get the size of the most common class
    common_class = common_class.at(1)
    
    // place the bars
    for data in plot.data {
     let width = (data.upper_lim - data.lower_lim) * step_size_x
     
     let rel_H = (data.data.len() / val_count)
     let bin_width = (1 / (data.upper_lim - data.lower_lim))
     let height = rel_H * bin_width * step_size_y * val_count * common_class
     let dx = data.lower_lim * step_size_x
     place(dx: dx, dy: -height, rect(width: width, height: height, fill: fill, stroke: stroke))
    }
  }

  prepare_plot(size, caption, plot_code, capt_dist: caption_distance)
}