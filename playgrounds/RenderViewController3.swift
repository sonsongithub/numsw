//  Final customized first implementation with UIScrollView

import UIKit

public class RenderViewController3: UIViewController {

    func makeRenderer() -> LineGraphRenderer {
        return LineGraphRenderer(lines: [
            LineData(points: DummyData.points1()),
            LineData(points: DummyData.points2())
            ]
        )
    }

    var renderers: [Renderer] = []

    @IBOutlet weak var scrollView: UIScrollView!

    public override func viewDidLoad() {
        super.viewDidLoad()

        renderers.append(makeRenderer())
        renderers.append(makeRenderer())
        renderers.append(makeRenderer())
        renderers.append(makeRenderer())
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
            let image = renderer.render(size: size)

            let imageView = UIImageView(image: image)
            imageView.frame.size = size
            imageView.contentMode = .scaleToFill
            imageView.frame.origin = CGPoint(x: 0, y: scrollView.contentSize.height)
            scrollView.addSubview(imageView)
            scrollView.contentSize.height += size.height
        }
    }


}
