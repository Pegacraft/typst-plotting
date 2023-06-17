#import "/typst-plotting/plotting.typ": *
#import "/typst-plotting/axis.typ": *
#import "/typst-plotting/util/classify.typ": *
#let print(desc: "", content) = {
  desc
  repr(content)
  [ \ ]
}
#let test_1() = {
  
  let gender_data = (
    ("w", 1), ("w", 3), ("w", 5), ("w", 4), ("m", 2), ("m", 2), ("m", 4), ("m", 6), ("d", 1), ("d", 9), ("d", 5), ("d", 8), ("d", 3), ("d", 1), (0, 11)
  )
  let y_axis = axis(min: 0, max: 11, step: 1, location: "left", helper_lines: true, invert_markings: false, title: "foo")
  let gender_axis_x = axis(values: ("", "m", "w", "d"), location: "bottom", helper_lines: true, invert_markings: false, title: "Geschlecht")
  let pl = plot(data: gender_data, axes: (gender_axis_x, y_axis))
  scatter_plot(pl, (100%,50%))
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
  histogram(pl, 100%, stroke: black, fill: (purple, blue, red, green, yellow))
}

#let test_4() = {
  let data = ((10, "Male"), (20, "Female"), (15, "Divers"), (2, "Other"))
  let data2 = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)

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
    #set align(left)
    #show: r => columns(2, r)
    #lorem(100)
    == Scatter plots
    #lorem(50)
    #{
      let data = (
        (0, 0), (1, 2), (2, 4), (3, 6), (4, 8), (5, 3), (6, 6),(7, 9),(11, 12)
      )
      let x_axis = axis(min: 0, max: 11, step: 1, location: "bottom")
      let y_axis = axis(min: 0, max: 13, step: 2, location: "left", helper_lines: true)
      let p = plot(data: data, axes: (x_axis, y_axis))
      scatter_plot(p, (100%, 20%))
    }
    == Histograms
    #lorem(150)
    #{
      let data = (
        18000, 18000, 18000, 18000, 18000, 18000, 18000, 18000, 18000, 18000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000,28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 28000, 35000, 46000, 75000, 95000
      )
      let classes = class_generator(10000, 50000, 4)
      classes.push(class(50000, 100000))
      classes = classify(data, classes)
      
      let x_axis = axis(min: 0, max: 100000, step: 20000, location: "bottom", show_markings: false, title: "Wert x", )
      
      let y_axis = axis(min: 0, max: 26, step: 3, location: "left", helper_lines: true, title: "Wert y und anderes Zeug", )
      let pl = plot(data: classes, axes: (x_axis, y_axis))
      histogram(pl, (100%, 20%), stroke: black, fill: gray)
    }

    == Pie charts
    #{
      lorem(120)
      let data = ((10, "Male"), (20, "Female"), (15, "Divers"), (2, "Other"))
      let pl = plot(data: data)
      pie_chart(pl, (100%, 20%), display_style: "hor-chart-legend")
    }
    #{
      let data = ((5, "0-18"), (9, "18-30"), (25, "30-60"), (7, "60+"))
      let pl = plot(data: data)
      pie_chart(pl, (100%, 20%), display_style: "hor-chart-legend")
      lorem(200)
    }
    == Bar charts
    #{
      lorem(50)
      let data = ((10, "Monday"), (5, "Tuesday"), (15, "Wednesday"), (9, "Thursday"), (11, "Friday"))

      let y_axis = axis(values: ("", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"), location: "left", show_markings: true)
      let x_axis = axis(min: 0, max: 20, step: 2, location: "bottom", helper_lines: true, title: "Visitors")

      let pl = plot(axes: (x_axis, y_axis), data: data)
      barchart(pl, (100%, 140pt), fill: (purple, blue, red, green, yellow), bar_width: 70%, rotated: true)

      let data_2 = ((20, 2), (30, 3), (16, 4), (40, 6), (5, 7))
      let y_axis_2 = axis(min: 0, max: 41, step: 10, location: "left", show_markings: true, helper_lines: true)
      let x_axis_2 = axis(min: 0, max: 9, step: 1, location: "bottom")
      let pl_2 = plot(axes: (x_axis_2, y_axis_2), data: data_2)
      barchart(pl_2, (100%, 120pt), fill: (purple, blue, red, green, yellow), bar_width: 70%)

      lorem(95)
    }
  ]
}

#let test_5() = {
  let classes = ()
  classes.push(class(11, 13))
  classes.push(class(13, 15))
  classes.push(class(1, 6))
  classes.push(class(6, 11))
  classes.push(class(15, 30))

  // let data = (2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 17, 17, 17, 17, 17)
  let data = ((20, 2), (30, 7), (16, 12), (40, 13), (5, 17))

  let x_axis = axis(min: 0, max: 31, step: 1, location: "bottom", show_markings: false)
  let y_axis = axis(min: 0, max: 41, step: 5, location: "left", helper_lines: true)
  
  classes = classify(data, classes)
  let pl = plot(axes: (x_axis, y_axis), data: classes)
  histogram(pl, 100%)
}


#let test_6() = {
  let data = ((10, "Monday"), (5, "Tuesday"), (15, "Wednesday"), (9, "Thursday"), (11, "Friday"))

  let y_axis = axis(values: ("", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"), location: "left", show_markings: true)
  let x_axis = axis(min: 0, max: 20, step: 2, location: "bottom", helper_lines: true)

  let pl = plot(axes: (x_axis, y_axis), data: data)
  barchart(pl, (100%, 33%), fill: (purple, blue, red, green, yellow), bar_width: 70%, rotated: true)

  let data_2 = ((20, 2), (30, 7), (16, 12), (40, 13), (5, 17))
  let y_axis_2 = axis(min: 0, max: 41, step: 5, location: "left", show_markings: true, helper_lines: true)
  let x_axis_2 = axis(min: 0, max: 21, step: 1, location: "bottom")
  let pl_2 = plot(axes: (x_axis_2, y_axis_2), data: data_2)
  barchart(pl_2, (100%, 60%), fill: (purple, blue, red, green, yellow), bar_width: 70%)
}

#{
  test_1()
  test_2()
  test_3()
  test_4()
  test_5()
  test_6()

  paper_test()
}