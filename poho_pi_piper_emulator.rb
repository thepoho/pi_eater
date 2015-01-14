#emulates the rpi library
module PiPiper
  class Pin
    def initialize(opts)
      @opts = opts
      @opts[:state] = 0
    end
    def on
      @opts[:state] = 1
    end
    def off
      @opts[:state] = 0
    end
    def read
      @opts[:state]
    end
    def on?
      @opts[:state] == 1
    end
    def off?
      !on?
    end
  end
end
