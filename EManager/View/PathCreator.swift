//
//  PathCreator.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/15.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

//每条子线段信息
struct BezierInfo{
    let path:UIBezierPath//具体线段
    let color:UIColor//线段对应颜色
    init(path:UIBezierPath,color:UIColor){
        self.path = path
        self.color = color
    }
}

class PathCreator{
    //所有笔画
    private var paths:[NSMutableArray]?
    //笔画内当前子线段
    private var currentBezierPathInfo:BezierInfo?
    //当前笔画的所有子线段
    private var currentPath:NSMutableArray?
    //当前笔画已经采集处理了几个触摸点
    private var pointCountInOnePath = 0
    
//    static let colors = [UIColor.red,UIColor.orange,UIColor.yellow,UIColor.green,UIColor.blue,UIColor.gray,UIColor.purple]
    func colors(_ val:Int) -> UIColor {
        return UIColor.init(displayP3Red:CGFloat(val%255) , green: CGFloat(val%255), blue: CGFloat(val%255), alpha: 1)
    }
    init() {
        paths = []
    }
    //添加新笔画
    func addNewPath(to:CGPoint,isEraser:Bool)->Void{
        //创建起始线段
        let path = UIBezierPath()
        path.lineWidth = 5
        path.move(to: to)
        path.lineJoinStyle = CGLineJoin.round
        path.lineCapStyle = CGLineCap.round
        if !isEraser {
            //绑定线段与颜色信息
            currentBezierPathInfo = BezierInfo(path: path, color: colors(pointCountInOnePath))
        }else{
            //处于擦除模式，颜色与画板背景色相同
            currentBezierPathInfo = BezierInfo(path: path, color: UIColor.black)
        }
        //新建一个笔画
        currentPath = NSMutableArray.init()
        //将起始线段加入当前笔画
        currentPath!.add(currentBezierPathInfo)
        pointCountInOnePath = 0
        //将当前笔画加入笔画数组
        paths!.append(currentPath!)
    }
    //添加新的点，更新当前笔画路径
    func addLineForCurrentPath(to:CGPoint,isEraser:Bool) -> Void {
        pointCountInOnePath += 1//同一笔画内，每7个点换一次颜色
        if pointCountInOnePath % 7 == 0{//换颜色
            if let currentBezierPathInfo = currentBezierPathInfo{
                //将当前点加入当前子线段,更新当前子线段路径
                currentBezierPathInfo.path.addLine(to: to)
            }
            //生成新的子线段
            let path = UIBezierPath()
            path.lineWidth = 5
            path.move(to: to)
            path.lineJoinStyle = CGLineJoin.round
            path.lineCapStyle = CGLineCap.round
            if !isEraser{
                //给当前子线段设置下一个颜色
                currentBezierPathInfo = BezierInfo(path: path, color: colors(pointCountInOnePath))
            }else{
                //处于擦除模式，颜色与画板背景色相同
                currentBezierPathInfo = BezierInfo(path: path, color: UIColor.black)
            }
            //将当前子线段加入当前笔画
            currentPath!.add(currentBezierPathInfo)
        }else{
            if let currentBezierPathInfo = currentBezierPathInfo{
                //将当前点加入当前子线段,更新当前子线段路径
                currentBezierPathInfo.path.addLine(to: to)
            }
        }
    }
    
    func drawPaths()->Void{
        //画线
        let pathCount = paths!.count
        for i in 0..<pathCount{
            //取出所有笔画
            let onePath = paths![i]
            let onePathCount = onePath.count
            for j in 0..<onePathCount{
                //绘制每条笔画内每个子线段
                let pathInfo = onePath.object(at: j) as! BezierInfo
                pathInfo.color.set()
                pathInfo.path.stroke()
            }
        }
    }
    
    func revoke()->Void{
        //移走上一笔画
        if paths!.count > 0 {
            paths!.removeLast()
        }
    }
    
    func clean()->Void{
        //移走所有笔画
        paths!.removeAll()
    }
}
