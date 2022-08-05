//
//  CGFloat+Extension.swift
//  FlappyBird
//
//  Created by 李泰儀 on 2022/8/6.
//

import CoreGraphics

extension CGFloat {
    public static func randomBetween(_ first: CGFloat, _ second: CGFloat) -> CGFloat {
        CGFloat.random(in: first...second)
    }
}
