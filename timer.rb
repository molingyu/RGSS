# encoding: utf-8
# author shitake
# date 16-5-30
# lisence MIT

# 简易计时器类。
# 类方法：
#   new 返回一个计时器。
#   update 更新。
# 实例方法：
#   after(time){ ... } 添加一个计时器任务，等待time秒后执行区块内的代码。
#   every(time){ ... } 添加一个计时器任务，每隔time秒后执行区块内的代码。
#   start 开始计时器。
#   stop 暂停计时器。
#   status 返回当前计时器的状态。
#   dispose 释放计时器。
# 说明：
#   通过new方法创建的计时器，会自动放入Timer的全局更新列表里。只需要调用Timer.update
#   而不需要调用每个计时器实例对象的update方法。

class Timer
  
  @@list = []
    
  def self.update
    @@list.each{|o| o.update if o != nil } if @@list != []
  end
  
  attr_reader :status
    
  def initialize
    @@list.push(self)
    @afters = []
    @everys = []
    @status = :run
    @stops_time = 0
    @timer_info = Struct.new(:start_time, :time, :block)
  end
  
  def start
    return if @status == :run
    @stops_time += Time.now - @stop_time
    @status = :run
  end
  
  def stop
    return if @status == :stop
    @stop_time = Time.now
    @status = :stop
  end
  
  def after(time, &block)
    @afters.push @timer_info.new(Time.now, time, block)
  end
  
  def every(time, &block)
    @everys.push @timer_info.new(Time.now, time, block)
  end
  
  def dispose
    @@list.delete(self)
  end
  
  def update_afters
    return if @afters == []
    @afters.each do |o|
      if Time.now - o.start_time - @stops_time >= o.time
        o.block.call
        @afters.delete(o)
      end
    end
  end
  
  def update_everys
    return if @everys == []
    @everys.each do |o|
      if Time.now - o.start_time - @stops_time >= o.time
        o.block.call
      end
    end
  end
    
  def update
    update_afters 
    update_everys 
  end
  
end
