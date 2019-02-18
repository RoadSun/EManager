//
//  SCanvasModelExtend.swift
//  DSRobotEditorPad
//
//  Created by Sunlu on 2019/1/28.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SCanvasModelExtend: SCanvasModel {
    /* 判断区域 *********************************************************************/
    
    /*
     * 判断移动区域
     * judge area move
     */
    func j_areaMove(_ point:CGPoint) -> Bool {
        if point.x > self.config.frame.x + space &&
            point.x < self.config.frame.x_w - space &&
            point.y > self.config.frame.y + space &&
            point.y < self.config.frame.y_h - space {
            return true
        }
        return false
    }
    
    /*
     * 判断拖动区域
     * judge drag
     */
    func j_drag(_ point:CGPoint) {
        // 如果锁定选择框, 选择框大小不能改变
        if direction != .default {
            return
        }
        // 上
        if point.x >= self.config.frame.x &&
            point.x <= self.config.frame.x_w &&
            point.y >= self.config.frame.y - t_space &&
            point.y <= self.config.frame.y + space  {
            
            let y = point.y - self.o.height
            self.config.frame.y = y
            self.config.frame.h = self.config.frame.y_h - y
//            SMLog(content: "上")
        }
        
        // 右
        if point.x > self.config.frame.x_w - space &&
            point.x < self.config.frame.x_w + t_space &&
            point.y >= self.config.frame.y &&
            point.y <= self.config.frame.y_h  {
            
            let x = point.x + self.reverse_o.width
            self.config.frame.x_w = x
            self.config.frame.w = x - self.config.frame.x
//            SMLog(content: "右")
        }
        
        // 下
        if point.x >= self.config.frame.x &&
            point.x <= self.config.frame.x_w &&
            point.y >= self.config.frame.y_h - space &&
            point.y <= self.config.frame.y_h + t_space  {
            
            let y = point.y + self.reverse_o.height
            self.config.frame.y_h = y
            self.config.frame.h = y - self.config.frame.y
//            SMLog(content: "下")
        }
        
        // 左
        if point.x >= self.config.frame.x - t_space &&
            point.x <= self.config.frame.x + space &&
            point.y >= self.config.frame.y &&
            point.y <= self.config.frame.y_h  {
            
            let x = point.x - self.o.width
            self.config.frame.x = x
            self.config.frame.w = self.config.frame.x_w - x
//            SMLog(content: "左")
        }
    }
    
    /*
     * 判断区间
     * judge type
     */
    func j_area(_ dir:SPanDirection, _ val:CGFloat) {
        switch dir {
        case .u:
            if self.config.frame.y < val {
                self.config.frame.y = val
                self.config.frame.y_h = self.config.frame.h + val
            }
            break
        case .r:
            if self.config.frame.x_w > val {
                self.config.frame.x_w = val
                self.config.frame.x = val - self.config.frame.w
            }
            break
        case .d:
            if self.config.frame.y_h > val {
                self.config.frame.y_h = val
                self.config.frame.y = val - self.config.frame.h
            }
            break
        case .l:
            if self.config.frame.x < val {
                self.config.frame.x = val
                self.config.frame.x_w = self.config.frame.w + val
            }
            break
        default: break
        }
    }
    
    /*
     * 判断点的点击区域
     * judge type
     */
    func j_type(_ type:SCanvasSelectType = .point) {
        selectedType = type
        if type == .point {
            config = CanvasConfig(frame: CanvasFrame(x: 0,
                                                     y: 0,
                                                     w: 20,
                                                     h: 20,
                                                     x_w: 10,
                                                     y_h: 10), center: CGPoint(x: 0, y: 0))
        }else if(type == .rect){
            config = CanvasConfig(frame: CanvasFrame(x: 200,
                                                     y: 200,
                                                     w: 100,
                                                     h: 100,
                                                     x_w: 300,
                                                     y_h: 300), center: CGPoint(x: 0, y: 0))
        }
    }
    
    /* 触摸部分 *********************************************************************/
    
    /*
     * 中心点位置
     * move center move begin
     */
    func m_c_moveBegin(_ point:CGPoint) {
        self.config.frame.x = point.x - self.config.frame.w / 2
        self.config.frame.y = point.y - self.config.frame.h / 2
        
        self.config.frame.x_w = point.x + self.config.frame.w / 2
        self.config.frame.y_h = point.y + self.config.frame.h / 2
        
        self.o.width = point.x - self.config.frame.x
        self.o.height = point.y - self.config.frame.y
        
        self.reverse_o.width = self.config.frame.x_w - point.x
        self.reverse_o.height = self.config.frame.y_h - point.y
        
        self.config.center.x = self.config.frame.x + self.config.frame.w / 2
        self.config.center.y = self.config.frame.y + self.config.frame.h / 2
    }
    
    /*
     * 触点与框原始坐标差值
     * move move begin
     */
    func m_moveBegin(_ point:CGPoint) {
        self.o.width = point.x - self.config.frame.x
        self.o.height = point.y - self.config.frame.y
        
        self.reverse_o.width = self.config.frame.x_w - point.x
        self.reverse_o.height = self.config.frame.y_h - point.y
        
        self.config.center.x = self.config.frame.x + self.config.frame.w / 2
        self.config.center.y = self.config.frame.y + self.config.frame.h / 2
    }
    
    /*
     * 移动点框跟随移动
     * move move
     */
    func m_move(_ point:CGPoint) { // || self.direction == .default
        
        if self.direction == .left_and_right{
            let x = point.x - self.o.width
            self.config.frame.x = x
            self.config.frame.x_w = self.config.frame.x + self.config.frame.w
            self.config.center.x = self.config.frame.x + self.config.frame.w / 2
        }
        
        if self.direction == .up_and_down{
            let y = point.y - self.o.height
            self.config.frame.y = y
            self.config.frame.y_h = self.config.frame.y + self.config.frame.h
            self.config.center.y = self.config.frame.y + self.config.frame.h / 2
        }
    }
    
    /*
     * 单点移动
     * move point move begin
     */
    func m_p_moveBegin(_ point:CGPoint) {
        self.o.width = self.config.frame.w/2
        self.o.height = self.config.frame.h/2
        
        self.reverse_o.width = self.o.width
        self.reverse_o.height = self.o.height
        
        self.config.frame.x = point.x - self.config.frame.w / 2
        self.config.frame.y = point.y - self.config.frame.h / 2
        
        self.config.center = point
    }
    
    /*
     * 单点移动
     * move point move
     */
    func m_p_move(_ point:CGPoint) {
        let y = point.y - self.o.height
        self.config.frame.y = y
        self.config.frame.y_h = self.config.frame.y + self.config.frame.h
        self.config.center.y = self.config.frame.y + self.config.frame.h / 2
    }
    
    /*
     * 单水平方向移动
     *
     */
}
