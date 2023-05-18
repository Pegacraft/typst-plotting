//------------------
// THIS FILE CONTAINS EVERYTHING TO DRAW AND REPRESENT AXES
//------------------


// Data representation of the axes
// min: start of the axis
// max: end of the axis (exclusive)
// step: the steps the axis should take per section
// values: the values of the markings (if set manually the first three arguments should be unchanged)
// location: the position of the axis. Valid are: "top", "bottom", "left", "right"
// show_values: if the values should be displayed
// show_markings: if the markings should be displayed
// invert_markings: if the markins should point away from the data
// marking_offset_left: amount of hidden markings from the left or bottom
// marking_offset_right: amount of hidden markings from the right or top
// stroke: the color of the baseline for the axis
// marking_color: the color of the marking
// value_color: the color of a value
// heler_lines: if helper lines (to see better alignment of data) should be displayed
// helper_line_style: the style of the helper lines, options are: "solid", "dotted", "densely-dotted", "loosely-dotted", "dashed", "densely-dashed", "loosely-dashed", "dash-dotted", "densely-dash-dotted" or "loosely-dash-dotted"
// helper_line_color: the color of the helper line
// marking_length: the length of a marking in absolute size
// marking_number_distance: the distance between the marker and the number
#let axis(min: 0, max: 0, step: 1, values: (), location: "bottom", show_values: true, show_markings: true, invert_markings: false, marking_offset_left: 1, marking_offset_right: 0, stroke: black, marking_color: black, value_color: black, helper_lines: false, helper_line_style: "dotted", helper_line_color: gray, marking_length: 5pt, marking_number_distance: 5pt) = {
  let axis_data = (
    min: min,
    max: max,
    step: step,
    location: location,
    show_values: show_values,
    show_markings: show_markings,
    invert_markings: invert_markings,
    marking_offset_left: marking_offset_left,
    marking_offset_right: marking_offset_right,
    stroke: stroke,
    marking_color: marking_color,
    value_color: value_color,
    helper_lines: helper_lines,
    helper_line_style: helper_line_style,
    helper_line_color: helper_line_color,
    marking_length: marking_length,
    marking_number_distance: marking_number_distance,
    values: values
  )

  if values.len() == 0 {
    axis_data.values = range(min, max, step: step)
  }

  return axis_data
  
}

//------------------------------
// AXIS DRAWING
//-------------------------------

// axis: the axis to draw
// length: the length of the axis (mostly gotten from the plot code function; see util.typ, prepare_plot())
// pos: the position offset as an array(x, y)
// length_offset: the distance between caption and plot. (mostly gotten from the plot code function; see util.typ, prepare_plot())
#let draw_axis(axis, length: 200pt, pos: (0pt, 0pt), length_offset: 20pt) = {
    
    let step_length = length / axis.values.len()
    let invert_markings = 1
    let user_invert_markings = if axis.invert_markings {-1} else {1}
    // Changes point of reference if top or right is chosen
    if axis.location == "right" {
      pos.at(0) += length + if type(length) == "relative length" {length_offset} else {0pt}
      invert_markings = -1
    }
    if axis.location == "top" {
      pos.at(1) -= length - if type(length) == "ratio" {length_offset} else {0pt}
      invert_markings = -1
    }
    
    if axis.location == "left" or axis.location == "right" {
      // Places the axis line
      place(dx: pos.at(0), dy: pos.at(1), line(angle: -90deg, length: length, stroke: axis.stroke))

      // Draws step markings
      for step in range(axis.marking_offset_left, axis.values.len() - axis.marking_offset_right) {
        // Draw helper lines:
        if axis.helper_lines {
          place(dx: pos.at(0), dy: pos.at(1) - step_length * step, line(angle: 0deg, length: 100% * invert_markings, stroke: (paint: axis.helper_line_color, dash: axis.helper_line_style)))
        }
        
        // Draw markings
        if axis.show_markings {
          place(dx: pos.at(0), dy: pos.at(1) - step_length * step, line(angle: 0deg, length: axis.marking_length * invert_markings * user_invert_markings, stroke: axis.marking_color))
        }
        // Draw numbering
        if axis.show_values {
          let number = axis.values.at(step)
          style(styles => {
            let size = measure([#number], styles)
            let dist = if axis.invert_markings {axis.marking_length + axis.marking_number_distance} else {axis.marking_number_distance}
            let inversion = if invert_markings == -1 {dist * 2 + size.width} else {0pt}
            place(dx: pos.at(0) - dist - size.width + inversion, dy: pos.at(1) - step_length * step - 4pt)[#set text(fill: axis.value_color);#number]
          })
        }
      }

    } else if axis.location == "top" or axis.location == "bottom" {
      // Places the axis line
      place(dx: pos.at(0), dy: pos.at(1), line(angle: 0deg, length: length, stroke: axis.stroke))

      // Draws step markings
      for step in range(axis.marking_offset_left, axis.values.len() - axis.marking_offset_right) {
        // Draw helper lines:
        if axis.helper_lines {
          place(dx: pos.at(0) + step_length * step, dy: pos.at(1), line(angle: 90deg, length: (100% - length_offset) * -invert_markings, stroke: (paint: axis.helper_line_color, dash: axis.helper_line_style)))
        }

        // Draw markings
        if axis.show_markings {
          place(dx: pos.at(0) + step_length * step, dy: pos.at(1), line(angle: 90deg, length: axis.marking_length * -invert_markings * user_invert_markings, stroke: axis.marking_color))
        }

        // Show values
        if axis.show_values {
          let number = axis.values.at(step)
          style(styles => {
            let size = measure([#number], styles)
            let dist = if axis.invert_markings {axis.marking_number_distance + axis.marking_length} else {axis.marking_number_distance}
            let inversion = if invert_markings == -1 {-dist * 2 - size.height} else {0pt}
            place(dx: pos.at(0) + step_length * step, dy: pos.at(1) + dist + inversion, box(width: 0pt, align(center, text(fill: axis.value_color, str(number)))))
          })
        }
      }
    } else { panic("axis location wrong") }
}

// ------------------------