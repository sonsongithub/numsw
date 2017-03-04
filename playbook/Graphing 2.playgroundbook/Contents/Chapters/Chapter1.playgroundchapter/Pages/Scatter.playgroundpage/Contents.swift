//#-code-completion(module, hide, Swift)
//#-code-completion(identifier, hide, _setup())
//#-code-completion(identifier, hide, AbstractPointChartable)
//#-hidden-code
_setup()
//#-end-hidden-code
//#-editable-code Tap to enter code.
// 1. Create a scatter plot using symbols.
let symbolScatter = ScatterPlot(xyData: (1,3), (1.3,3.1), (1.7,3.4), (2,4.5), (2.25,4), (2.4,4.1), (2.5,3.85), (2.7,5.5), (3,6.25), (3.1,7.05), (3.5,7))
symbolScatter.color = #colorLiteral(red: 0, green: 0.1771291047, blue: 0.97898072, alpha: 1)

// 2. Create a scatter plot using images.
let imageScatter = ScatterPlot(xyData: (1.25,7.5), (1.35,7.1), (1.5,7.2), (1.55,6.9),(1.55,7.4))
imageScatter.symbol = Symbol(imageNamed: "SwiftBird", size: 24)

//#-end-editable-code
