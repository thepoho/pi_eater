class Pin
  attr_accessor :pin_object, :direction, :pin, :name, :gpio, :desc, :out_state

  def initialize(options={})
    @pin         = options[:pin]
    @name        = options[:name]
    @gpio        = options[:gpio]
    @description = options[:description]
    #puts "created pin #{@pin}: #{options}"
  end

  def gpio?
    @gpio != nil
  end

  def set_direction(dir)
    raise "Not a GPIO pin" unless gpio?
    raise "Invalid direction" unless %w{in out}.include? dir.to_s
    @direction = dir.to_sym
    @pin_object = PiPiper::Pin.new(pin: @pin, direction: @direction)
  end 

  def initialised?
    !!@pin_object
  end

  def set_output_state(state)
    raise "Not a GPIO pin" unless gpio?
    raise "Invalid state #{state}" unless %w{on off}.include? state.to_s
    raise "Pin has not had a direction set" unless @pin_object
    raise "Pin is not set to out" unless @direction == :out
   
    @out_state = state.to_sym
    if @out_state == :on
      @pin_object.on
    else
      @pin_object.off
    end
  end

  def on?
    if @pin_object
      @pin_object.on?
    else
      nil
    end 
  end
  
  def off?
    if @pin_object
      @pin_object.off?
    else
      nil
    end 
  end
end
