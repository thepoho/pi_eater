if Gem::Platform.local.cpu == "arm"
  require 'pi_piper'
else
  require './poho_pi_piper_emulator.rb'
end

require './pin.rb'
require 'sinatra'
require 'yaml'
require 'json'

DATA_FILE = "pin_data.yml"
pin_data = YAML::load(File.open(DATA_FILE)) rescue {}

pins = {}

pin_data[:pins].each do |data|
  pins[data[:pin]] = Pin.new(data) 
end

Thread.new do
  get '/' do
    @pins = pins
    haml :index
  end

  get '/pin_states' do
    content_type :json
    ret = {}
    pins.each do |k,v|
      next unless v.gpio?
      ret[k] = {initialised: v.initialised?}
      if v.initialised?
        ret[k][:direction] = v.direction
        if v.direction == :in
          ret[k][:value] = v.read
        else #direction is out
          ret[k][:value] = v.on?
        end
      end
    end
    ret.to_json
  end

  get '/set_pin_direction/:pin/:dir' do
    #accepts 'in' or 'out'
    #pin no is actual number, not GPIO no
    if pin = pins[params[:pin].to_i]
      begin
        pin.set_direction(params[:dir])
      rescue => e
        puts "==============================="
        puts e.message
        puts "==============================="
      end
    else
      puts "==============================="
      puts "Pin #{params[:pin]} is invalid"
      puts "==============================="
    end
  end

  get '/set_output_pin/:pin/:state' do
    if pin = pins[params[:pin].to_i]
      begin
        pin.set_output_state(params[:state])
      rescue => e
        puts "==============================="
        puts e.message
        puts "==============================="
      end
    else
      puts "==============================="
      puts "Pin #{params[:pin]} is invalid"
      puts "==============================="
    end
  end

end
