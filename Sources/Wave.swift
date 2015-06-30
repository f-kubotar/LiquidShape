import SpriteKit

class Wave {
    struct Spring {
        var height: CGFloat = 0
        var velocity: CGFloat = 0
        
        mutating func update(density: CGFloat, rippleSpeed: CGFloat) {
            self.velocity += (-rippleSpeed * self.height - density * self.velocity)
            self.height += self.velocity
        }
    }
    
    var size: CGSize
    var density: CGFloat = 0.02
    var rippleSpeed: CGFloat = 0.1
    var springs: [Spring]
    var numNeighbours = 8
    
    private var leftDeltas = [CGFloat]()
    private var rightDeltas = [CGFloat]()
    
    init(size: CGSize, waveLength: Int = 340) {
        self.size = size
        self.springs = [Spring](count: waveLength, repeatedValue: Spring())
        self.leftDeltas = [CGFloat](count: self.springs.count, repeatedValue: 0)
        self.rightDeltas = [CGFloat](count: self.springs.count, repeatedValue: 0)
    }
    
    func updateSprings(spread: CGFloat) {
        let count = self.springs.count
        for i in 0..<count {
            self.springs[i].update(self.density, rippleSpeed: self.rippleSpeed)
        }
        
        for t in 0..<self.numNeighbours {
            self.leftDeltas[0] = 0
            self.leftDeltas[count - 1] = 0
            
            self.rightDeltas[0] = 0
            self.rightDeltas[count - 1] = 0

            for i in 0..<count {
                if i > 0 {
                    leftDeltas[i] = spread * (self.springs[i].height - self.springs[i - 1].height)
                    self.springs[i - 1].velocity += leftDeltas[i - 1]
                }
                if i < self.springs.count - 1 {
                    rightDeltas[i] = spread * (self.springs[i].height - self.springs[i + 1].height)
                    self.springs[i + 1].velocity += rightDeltas[i]
                }
            }
            
            for i in 0..<count {
                if i > 0 {
                    self.springs[i - 1].height += leftDeltas[i]
                }
                if i < count - 1 {
                    self.springs[i + 1].height += rightDeltas[i]
                }
            }
        }
    }
    
    func createPath() -> CGPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        for i in 0..<self.springs.count {
            let spring = self.springs[i]
            
            let x = CGFloat(i) * (self.size.width / CGFloat(self.springs.count))
            let y = self.size.height - spring.height
            path.addLineToPoint(CGPoint(x: x, y: y))
        }
        path.addLineToPoint(CGPoint(x: self.size.width, y: 0))
        path.closePath()
        return path.CGPath
    }
}
