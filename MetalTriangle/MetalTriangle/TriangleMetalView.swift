//
//  TriangleMetalView.swift
//  MetalTriangle
//
//  Created by quockhai on 2019/3/5.
//  Copyright © 2019 Polymath. All rights reserved.
//

import UIKit
import MetalKit

class TriangleMetalView: MTKView {

    var commandQueue: MTLCommandQueue?
    var rps: MTLRenderPipelineState?
    var vertexData: [Float]?
    var vertexBuffer: MTLBuffer?
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        
        self.render()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let drawable = currentDrawable, let rpd = currentRenderPassDescriptor {
            rpd.colorAttachments[0].clearColor = MTLClearColorMake(0, 0.5, 0.5, 1.0)
            let commandBuffer = commandQueue!.makeCommandBuffer()
            let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd)
            commandEncoder?.setRenderPipelineState(rps!)
            commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
            commandEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }
    
    func render() {
        if let defaultDevice = MTLCreateSystemDefaultDevice() {
            self.device = defaultDevice
            commandQueue = self.device!.makeCommandQueue()
            vertexData = [-1.0, -1.0, 0.0, 1.0,
                          1.0, -1.0, 0.0, 1.0,
                          0.0,  1.0, 0.0, 1.0]
            let dataSize = vertexData!.count * MemoryLayout<Float>.size
            vertexBuffer = self.device!.makeBuffer(bytes: vertexData!, length: dataSize, options: [])
            
            let library = self.device!.makeDefaultLibrary()!
            let vertex_func = library.makeFunction(name: "vertex_func")
            let frag_func = library.makeFunction(name: "fragment_func")
            let rpld = MTLRenderPipelineDescriptor()
            rpld.vertexFunction = vertex_func
            rpld.fragmentFunction = frag_func
            rpld.colorAttachments[0].pixelFormat = .bgra8Unorm
            do {
                try rps = self.device!.makeRenderPipelineState(descriptor: rpld)
            } catch let error {
                print("[MetalKit]: \(error)")
            }
        } else {
            print("[MetalKit]: Your device is not supported Metal 🤪")
        }
        
    }

}
