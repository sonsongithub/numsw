//#-code-completion(module, hide, Swift)
//#-code-completion(identifier, hide, _setup())
//#-code-completion(identifier, hide, AbstractPointChartable)
//#-hidden-code
_setup()
//#-end-hidden-code
//#-editable-code Tap to enter code.
// 1. Create a line plot.
let line = LinePlot(xyData: (1,1), (10,50))

// 2. Create a line plot from a data set.
let data = XYData()
for i in 1...10 {
    data.append(x: Double(i), y: Double(i * i))
}
let lineFromDataSet = LinePlot(xyData: data)
lineFromDataSet.color = #colorLiteral(red: 0.07005243003, green: 0.5545874834, blue: 0.1694306433, alpha: 1)

// 3. Create a line plot from a function.
let function = LinePlot { x in
    10 + x - x * x/2
}
function.color = #colorLiteral(red: 0.7086744905, green: 0.05744680017, blue: 0.5434997678, alpha: 1)
function.lineWidth = 3

//#-end-editable-code
