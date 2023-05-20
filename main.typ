#import "plotting.typ": *
#import "axis.typ": *
#import "classify.typ": *
#let print(desc: "", content) = {
  desc
  repr(content)
  [ \ ]
}
#let test_1() = {
  
  let gender_data = (
    ("w", 1), ("w", 3), ("w", 5), ("w", 4), ("m", 2), ("m", 2), ("m", 4), ("m", 6), ("d", 1), ("d", 9), ("d", 5), ("d", 8), ("d", 3), ("d", 1)
  )
  let y_axis = axis(min: 0, max: 11, step: 2, location: "left", helper_lines: true, invert_markings: false)
  let gender_axis_x = axis(values: ("", "m", "w", "d"), location: "bottom", helper_lines: true, invert_markings: false)
  let pl = plot(data: gender_data, axes: (gender_axis_x, y_axis))
  scatter_plot(pl, 100%)
}

#let test_2() = {
    let data = (
      (0, 0), (2, 2), (3, 0), (4, 4), (5, 7), (6, 6), (7, 9), (8, 5), (9, 9), (10, 1)
    )
    let x_axis = axis(min: 0, max: 11, step: 2, location: "bottom", stroke: blue, marking_color: red, value_color: purple)
    let y_axis = axis(min: 0, max: 11, step: 2, location: "left", helper_lines: false)
    let pl = plot(data: data, axes: (x_axis, y_axis))
    scatter_plot(pl, (100%, 25%))
    graph_plot(pl, (100%, 25%))
    graph_plot(pl, (100%, 25%), rounding: 30%, caption: "Graph Plot with caption and rounding", caption_distance: 20pt)
}

#let test_3() = {
  let data = (
    18000, 18000, 18000, 18000, 18000, 18000, 18000, 18000, 18000, 18000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000,28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 35000, 46000, 75000, 95000
  )
  let classes = class_generator(10000, 50000, 4)
  classes.push(class(50000, 100000))
  classes = classify(data, classes)
  let x_axis = axis(min: 0, max: 100000, step: 10000, location: "bottom")
  let y_axis = axis(min: 0, max: 31, step: 5, location: "left", helper_lines: true)
  let pl = plot(data: classes, axes: (x_axis, y_axis))
  histogram(pl, 100%, stroke: black)
}

#let test_4() = {
  let data = ((10, "Male"), (20, "Female"), (15, "Divers"), (2, "Other"))

  let p = plot(data: data)
  //pagebreak()
  pie_chart(p, (100%, 20%), display_style: "legend-inside-chart")
  pie_chart(p, (100%, 20%), display_style: "hor-chart-legend")
  pie_chart(p, (100%, 20%), display_style: "hor-legend-chart")
  pie_chart(p, (100%, 20%), display_style: "vert-chart-legend")
  pie_chart(p, (100%, 20%), display_style: "vert-legend-chart")
}

#let paper_test() = {
  set par(justify: true)
  pagebreak()
  [
    #set align(center)
    = This is my paper
    #show: r => columns(2, r)
    #lorem(100)
    == First sub topic
    #lorem(50)
    #{
      let data = (
        (0, 0), (1, 2), (2, 4), (3, 6), (4, 8), (5, 3), (6, 6),(7, 9)
      )
      let x_axis = axis(min: 0, max: 11, step: 1, location: "bottom")
      let y_axis = axis(min: 0, max: 11, step: 2, location: "left", helper_lines: true)
      let p = plot(data: data, axes: (x_axis, y_axis))
      scatter_plot(p, (100%, 20%))
    }
    == Second sub topic
    #lorem(150)
    #{
      let data = (
        18000, 18000, 18000, 18000, 18000, 18000, 18000, 18000, 18000, 18000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000,28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 35000, 46000, 75000, 95000
      )
      let classes = class_generator(10000, 50000, 4)
      classes.push(class(50000, 100000))
      classes = classify(data, classes)
      let x_axis = axis(min: 0, max: 100000, step: 20000, location: "bottom", show_markings: false)
      let y_axis = axis(min: 0, max: 26, step: 3, location: "left", helper_lines: true)
      let pl = plot(data: classes, axes: (x_axis, y_axis))
      histogram(pl, (100%, 20%), stroke: black)
    }

    == Third sub topic
    #{
      lorem(120)
      let data = ((10, "Male"), (20, "Female"), (15, "Divers"), (2, "Other"))
      let pl = plot(data: data)
      pie_chart(pl, (100%, 20%), display_style: "hor-chart-legend")
      lorem(400)
    }
  ]
}

#{
  test_1()
  test_2()
  test_3()
  test_4()
  paper_test()
  
}
// TODO:
// fix points when choosing rounding in graph plot
// PIE CHART (will be pain, but hey)