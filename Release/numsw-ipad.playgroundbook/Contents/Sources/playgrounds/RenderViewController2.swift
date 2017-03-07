//  Final customized first implementation with UIScrollView

import UIKit

public class RenderViewController2: UIViewController {
    
    func makeRenderer() -> ChartRenderer {
        let points1 = DummyData.points1()
        let points2 = DummyData.points2()
        
        var chart = Chart()
        chart.elements = [
            .line(LineGraph(points: points1)),
            .line(LineGraph(points: points2))
        ]
        chart.computeViewport()
    
        return ChartRenderer(chart: chart)
    }
    
    var renderers: [Renderer] = []
    
    var scrollView: UIScrollView!
    
    public func append(renderer: Renderer) {
        self.renderers.append(renderer)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        scrollView = UIScrollView()
        scrollView.frame = self.view.frame
        
        self.view.addSubview(scrollView)
    }
    
    func updateViews(){
        for view in scrollView.subviews{
            view.removeFromSuperview()
        }
        scrollView.contentSize.height = 0
        self.render()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.frame
        updateViews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.render()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func render(){
        
        var size = self.view.frame.size
        size.height *= 0.5
        // renderer 取り出してscrollviewに追加
        for renderer in renderers {
            let image = renderer.renderToImage(size: size)
            let imageView = UIImageView(image: image)
            imageView.frame.size = size
            imageView.contentMode = .scaleToFill
            imageView.frame.origin = CGPoint(x: 0, y: scrollView.contentSize.height)
            scrollView.addSubview(imageView)
            scrollView.contentSize.height += size.height
        }
    }
    
    
}
