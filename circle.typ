#import calc: *

// draws a circle part for the pie chart (and maybe others later)
#let circle_part(percentage, radius, rotation, fill: none, stroke: black) = {
  let angle = 360deg * percentage

  // Points
  let A = (
    sin(rotation) * radius,
    cos(rotation) * radius
  )
  let B = (
    sin(angle + rotation) * radius,
    cos(angle + rotation) * radius
  )

  let curve_point = (
    A.at(0) + radius,
    B.at(1) + radius
  )

  // Lines for curve
  let aw = (
    (curve_point.at(0) - A.at(0)),
    (curve_point.at(1) - A.at(1))
  )

  path((0pt, 0pt), (A, (0pt, 0pt), aw), B, (0pt, 0pt), fill: fill, stroke: stroke)
}