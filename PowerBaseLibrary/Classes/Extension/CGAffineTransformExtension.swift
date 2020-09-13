//
//  CGAffineTransformExtension.swift
//  BaiheWeddingApp
//
//  Created by 实 程 on 16/4/15.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

import Foundation
import Accelerate

func matrixMultiplyMatrix(_ matrix1: Array<Double>, matrix2: Array<Double>) -> Array<Double> {
    var mresult = [Double](repeating: 0.0, count: 9)
    vDSP_mmulD(matrix1, 1, matrix2, 1, &mresult, 1, 3, 3, 3)
    return mresult
}

public extension CGAffineTransform {
    
    func convertParameterMatrixToArray() -> Array<Double> {
        return [Double(self.a), Double(self.b), 0, Double(self.c), Double(self.d), 0, Double(self.tx), Double(self.ty), 1]
    }
    
    func multiplyMatrix(_ matrix: Array<Double>) -> Array<Double> {
        let selfMatrix = self.convertParameterMatrixToArray()
        var mresult = [Double](repeating: 0.0, count: 9)
        vDSP_mmulD(mresult, 1, selfMatrix, 1, &mresult, 1, 3, 3, 3)
        return mresult
    }
    
    init?(matrix: Array<Double>){
        if matrix.count == 9{
            let a = CGFloat(matrix[0])
            let b = CGFloat(matrix[1])
            let c = CGFloat(matrix[3])
            let d = CGFloat(matrix[4])
            let tx = CGFloat(matrix[6])
            let ty = CGFloat(matrix[7])
            self.init(a: a, b: b, c: c, d: d, tx: tx, ty: ty)
            dPrint(self)
        }
        else{
            return nil
        }
    }
}
