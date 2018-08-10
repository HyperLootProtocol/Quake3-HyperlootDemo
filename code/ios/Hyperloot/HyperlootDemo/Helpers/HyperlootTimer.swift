//
//  HyperlootTimer.swift
//  Hyperloot-iOS
//

import Foundation

class HyperlootTimer {
    
    enum State {
        case stopped
        case running
    }
    
    private var state: State = .stopped
    
    private var timer: Timer?
    private var thread: Thread?
    
    func start(timeInterval: TimeInterval, block: @escaping (() -> Void)) {
        guard state == .stopped else {
            return
        }
        
        state = .running
        
        let thread = Thread { [weak self] in
            let runLoop = RunLoop.current
            self?.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (timer) in
                DispatchQueue.main.async {
                    block()
                }
            })
            runLoop.run()
        }
        thread.start()
        
        self.thread = thread
    }
    
    func stop() {
        guard state == .running else {
            return
        }
        state = .stopped
        timer?.invalidate(); timer = nil
        thread?.cancel(); thread = nil
    }
}
