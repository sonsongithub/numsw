//
//  SelectTableViewController.swift
//  sandbox
//
//  Created by sonson on 2017/04/07.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit
import NumswRenderer

class SelectTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RenderScrollViewController {
            
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
            
            vc.append(renderer: makeRenderer())
            vc.append(renderer: makeRenderer())
            vc.append(renderer: makeRenderer())
            
        } else if let vc = segue.destination as? RendererDebugViewController {
            
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
            
            vc.renderer = makeRenderer()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            DummyData.runHoldExample()
            self.navigationController?.pushViewController(NumswPlayground.shared.viewController, animated: true)
        }
    }
}
