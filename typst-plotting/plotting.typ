#import "axis.typ": *
#import "util/classify.typ": *
#import "util/util.typ": *
#import calc: *

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
#let scatter_plot(plot, size, caption: "Scatter Plot", stroke: black, fill: none) = {
  let x_axis = plot.axes.at(0)
  let y_axis = plot.axes.at(1)
  // The code rendering the plot
  let plot_code() = {
    let step_size_x = calc_step_size(100%, x_axis)
    let step_size_y = calc_step_size(100%, y_axis)
      // Places the data points
    for (x,y) in plot.data {
      if type(x) == "string" {
        x = x_axis.values.position(c => c == x)
      }
      if type(y) == "string" {
        y = y_axis.values.position(c => c == y)
      }
      place(dx: (x - x_axis.min) * step_size_x - 1pt, dy: -(y - y_axis.min) * step_size_y - 1pt, square(width: 2pt, height: 2pt, fill: fill, stroke: stroke))
      }
  }

  // Sets outline for a plot and defines width and height and executes the plot code
  prepare_plot(size, caption, plot_code, plot: plot)
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
  let x_axis = plot.axes.at(0)
  let y_axis = plot.axes.at(1)
  let plot_code() = {
    let step_size_x = calc_step_size(100%, x_axis)
    let step_size_y = calc_step_size(100%, y_axis)
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
      } else if i == data.len() - 1 {
        delta.push((rounding * (curr.at(0) - prev.at(0)), rounding * (curr.at(1) - prev.at(1))))
      } else {
        delta.push((rounding * .5 * (next.at(0) - prev.at(0)), rounding * .5 * (next.at(1) - prev.at(1))))
      }
    }
    
    place(dx: 0pt, dy: 1pt, path(fill: fill, stroke: stroke, ..data.zip(delta)))
    for p in data {
      place(dx: p.at(0) - 1pt, dy: p.at(1), square(size: 2pt, fill: black, stroke: none))
    }
  }

  prepare_plot(size, caption, plot_code, plot: plot)
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
#let histogram(plot, size, caption: "Histogram", stroke: black, fill: gray) = {
  // Get the relevant axes:
  let x_axis = plot.axes.at(0)
  let y_axis = plot.axes.at(1)
  let plot_code() = {
    let step_size_x = calc_step_size(100%, x_axis)
    let step_size_y = calc_step_size(100%, y_axis)

    let array_stroke = type(stroke) == "array"
    let array_fill = type(fill) == "array"
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
    for (idx, data) in plot.data.enumerate() {
      let width = (data.upper_lim - data.lower_lim) * step_size_x
      
      let rel_H = (data.data.len() / val_count)
      let bin_width = (data.upper_lim - data.lower_lim)
      let height = (data.data.len() * (common_class / bin_width)) * step_size_y
      let dx = data.lower_lim * step_size_x
      place(dx: dx, dy: -height, rect(width: width, height: height, fill: if array_fill {fill.at(idx)} else {fill}, stroke: if array_stroke {stroke.at(idx)} else {stroke}))
    }
  }

  prepare_plot(size, caption, plot_code, plot: plot)
}


// Displayes a pie chart if possible
//---
// The plot needs to look something like this:
// data: a list of 1 dimensional data or a tuple with (amount of occurance, value)
//---
// size: the size as array of (width, height) or as a single value for width and height
// caption: name of the figure
// stroke: the stroke color of the dots
// fill: the fill color of the dots
// display-style: changes the style of the chart. Available are: "vert-chart-legend", "hor-chart-legend", "vert-legend-chart", "hor-legend-chart", "legend-inside-chart"
// colors: the colors used in the pie chart. when more data is there, than colors, the colors get repeated
// offset: the distance from the center to the text in the chart (only relevant when using "legend-inside-chart")
#let pie_chart(plot, size, caption: "Pie chart", stroke: black, fill: none, display_style: "hor-chart-legend", colors: (red, blue, green, yellow, purple, orange), offset: 50%) = {
  // get a point on a radius 1 circle 
  //---
  // x: travelled distance around circle
  let point(x) = (
    calc.cos(x), calc.sin(x)
  )
    
  // calculate the points needed on a bezier curve to gain an approximation of a circle
  //---
  // radius: the radius of the circle
  // start_angle: the angle at which the circle starts (counting from right going clockwise)
  // length: the angle of the segment
  let segment(radius, start_angle, length) = {
    let details = 4 //number of details, 3 is minimum
    let points = ((0pt, 0pt),)
    let distance = (4 / 3) * calc.tan(length / details / 4)
    
    for i in range(0, details + 1) {
      
      let angle = length / details * i + start_angle
      let pnt = point(angle)
      let delta = point(angle - 90deg)
      
      points.push((
        (pnt.at(0) * radius, pnt.at(1) * radius),
        (delta.at(0) * radius * distance, delta.at(1) * radius * distance)
      ))
      
    }
    points.at(-1).push((0pt, 0pt)) // fix end corner
    
    let temp = points.at(1).at(1)
    points.at(1).at(1) = (0pt, 0pt)
    points.at(1).push((-temp.at(0), -temp.at(1)))
    points.push((0pt, 0pt))
    return points
  }

  let data = plot.data

  if not type(data.at(0)) == "array" {
    let new_data = ((0, data.at(0)),)
    for value in data {
      let found = false
      for (idx, existing) in new_data.enumerate() {
        if existing.at(1) == value {
          new_data.at(idx).at(0) += 1
          found = true
          break
        }
      }
      if not found {
        new_data.push((1, value))
      }
    }
    data = new_data
  }
  
  // The code rendering the plot
  let plot_code() = {
    set align(center + top)
    layout(size => {
      box(width: size.width, height: size.height)
      let total = data.map(a => a.at(0)).sum()
      let angle = 0deg
      
      let radius = min(
        size.width,
        if display_style.split("-").at(0) == "vert" {size.height - 30pt} else {size.height}) / 2
      let pie = []
      let legend = []
      let dx = radius
      if display_style == "legend-inside-chart" {
        dx = 50%
      }
      for (i, data) in data.enumerate() {
        let fraction = data.at(0) / total * 360deg
        let points = segment(radius, angle, fraction)
        pie += place(dy: -radius, dx: dx, path(fill: colors.at(calc.rem(i, colors.len())), ..points))
        
        if display_style == "legend-inside-chart" {
          let pnt = point(angle + fraction / 2)
          pie += place(dx: pnt.at(0) * radius * offset + dx, dy: pnt.at(1) * radius * offset - radius, box(width: 0pt, height: 0pt, align(center + horizon, box(fill: purple, str(data.at(1))))))
        } else {
          legend += text(fill: colors.at(calc.rem(i, colors.len())), sym.hexa.filled) + sym.space.thin + str(data.at(1))
          if i != plot.data.len() - 1 { legend += if "hor" in display_style { "\n" } else { sym.space.quad } }
        }
        angle += fraction
      }
      style(s =>{
        let legend-size = measure(legend, s)
        if display_style == "vert-chart-legend" {
          place(dx: 50% - radius, dy: -30pt, pie)
          place(dx: 50% - legend-size.width / 2, dy: -20pt, legend)
        } else if display_style == "vert-legend-chart" {
          place(dx: 50% - legend-size.width / 2, dy: -(radius * 2) - 20pt, legend)
          place(dx: 50% - radius, dy: 0pt, pie)
        } else if display_style == "hor-chart-legend" { 
          place(dx: 50% - radius - legend-size.width / 2, dy: 0pt, pie)
          place(dx: 50% + radius - legend-size.width / 2 + 10pt, dy: -radius, box(height: 0pt, align(horizon, legend)))
        } else if display_style == "hor-legend-chart" {
          place(dx: 50% - radius + legend-size.width / 2, dy: 0pt, pie)
          place(dx: 50% - radius - legend-size.width / 2 - 10pt, dy: -radius, box(height: 0pt, align(horizon, legend)))
        } else if display_style == "legend-inside-chart" {
          pie
        } else {
          panic(display_style + " is not a valid display_style")
        }
        
      })
      
    })
  }

  // Sets outline for a plot and defines width and height and executes the plot code
  prepare_plot(size, caption, plot_code)
}

// Displayes a histogram if possible
//---
// The plot needs to look something like this:
// axis: two axes. One working as the x axis, the other as the y axis
// data: either 1. A list looking like this (val1, val2, val3, ...)
//              2. A list looking like this ((amount, value), (amount, value)...)
//---
// size: the size as array of (width, height) or as a single value for width and height
// caption: name of the figure
// stroke: the stroke color of a bar
// fill: the fill color of a bar
// centered_bars: if the bars should be on the number its corresponding to (default: true)
// bar_width: how thick the bars should be in percent. (default: 100%)
// rotated: if the bars should grow on the "x_axis" - this means the data gets mapped to the y axis - create the axis accordingly
#let barchart(plot, size, caption: "Barchart", stroke: black, fill: gray, centered_bars: true, bar_width: 100%, rotated: false) = {
  // Get the relevant axes:
  let x_axis = plot.axes.at(0)
  let y_axis = plot.axes.at(1)
  
  let plot_code() = {
    // get step sizes
    let step_size_x = calc_step_size(100%, x_axis)
    let step_size_y = calc_step_size(100%, y_axis)
    // get correct data
    let data = transform_data_count(plot.data)
    let array_stroke = type(stroke) == "array"
    let array_fill = type(fill) == "array"
    // draw the bars
    if not rotated {
      for (idx, data_set) in data.enumerate() {
      let height = data_set.at(0) * step_size_y
      let x_data = data_set.at(1)
      if type(data_set.at(1)) == "string" {
        x_data = x_axis.values.position(c => c == x_data)
      }
      let x_pos = x_data * step_size_x - if centered_bars {step_size_x * bar_width / 2} else {0pt}
      place(dx: x_pos, dy: -height,
        rect(width: step_size_x * bar_width, height: height,
          fill: if array_fill {fill.at(idx)} else {fill}, 
          stroke: if array_stroke {stroke.at(idx)} else {stroke}))
      } 
    } else {
      for (idx, data_set) in data.enumerate() {
        let width = data_set.at(0) * step_size_x
        let y_data = data_set.at(1)
        if type(data_set.at(1)) == "string" {
          y_data = y_axis.values.position(c => c == y_data)
        }
        let y_pos = y_data * step_size_y + if centered_bars {step_size_y * bar_width / 2} else {0pt}
        place(dx:0pt, dy: -y_pos, rect(width: width, height: step_size_y * bar_width,           
        fill: if array_fill {fill.at(idx)} else {fill}, 
        stroke: if array_stroke {stroke.at(idx)} else {stroke}))
      }
    }
  }
  prepare_plot(size, caption, plot_code, plot: plot)
}