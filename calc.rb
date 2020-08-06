### FDC 2020 ###
require "ruby2d"

$rx = 400; $ry = 600; $bor = 5; $mbr=0;
set title: "Sophie Calculator"
set background: 'gray'
set height: $ry; set width: $rx;

class Kalkulator
  def initialize
    @digits = '0'
    @message = 'subteal subteal subteal subteal'
    @buttons = []
    @shift = 0
    @number = 0
    @memory = 0
    @sign = ''
    @prev = ''
    @fw = 35

    @screen = Rectangle.new(
      x: $bor, y: $bor,
      width: $rx-$bor*2,
      height: $ry / 6,
      color: 'teal', z: 10
    )

    @screentext = Text.new(
      @digits,
      x: $rx-4*$bor-@fw, y: 2*$bor,
      font: 'data-latin.ttf',
      size: 72,
      color: 'black',
      z: 20
    )

    @subscreen = Rectangle.new(
      x: $bor, y: 4*$bor+$ry/6,
      width: $rx-$bor*2,
      height: $ry / 12,
      color: 'teal', z: 10
    )

    @subtext = Text.new(
      @message,
      x: 2*$bor+$rx, y: 4*$bor+$ry/6,
      font: 'data-latin.ttf',
      size: 42,
      color: 'black',
      z: 20
    )

    for i in [0,$rx-$bor]
      Rectangle.new(
        x:i , y: 0,
        width: $bor, height: $ry,
        color: 'gray', z: 30
      )
    end

    symbol = ['7','8','9','C','4','5','6','+','1','2','3','-','0','x',':','=']

    for i in 0..3
      for j in 0..3
        x = $bor+j*$rx/4
        y = i*$rx/4+$ry/3
        button = Button.new(x,y,symbol[j%4+i*4])
        @buttons.append(button)
      end
    end
  end

  def update
    @screentext.text=@digits
    @subtext.text=@message
    dl = @digits.length
    @screentext.x = $rx-4*$bor-dl*@fw
    if @shift>$rx*4
      @shift=0
    else
      @shift+=2
    end
    @subtext.x=$rx+2*$bor-@shift
  end

  def action(x,y,a)
    for i in 0..@buttons.length-1
      buff=@buttons[i].action(x,y,a)
      if a=='perform'
        if not buff.nil?
          symbol=buff
          f=true if Integer(symbol) rescue f=false
          if f
            if @number==0
              @digits=symbol
            elsif @digits.length<11
              @digits=@digits+symbol
            end
            @number=Integer(@digits)
          else
            if(symbol=='=')
              if @sign==@prev
                buff = @number
                @number=@memory
                @memory = buff
              end
              case @sign
              when '+'
                @number=@number+@memory
              when '-'
                @number=@number-@memory
              when 'x'
                @number=@memory*@number
              when ':'
                @number=@number/@memory
              end
              @digits=String(@number)
            else
              if symbol!='C'
                @sign=symbol
                @memory=@number
              end
              @number = 0
              @digits = '0'
            end
            @prev=symbol
          end
          break;
        end
      end
    end
  end

  def reset
    for i in 0..@buttons.length-1
      @buttons[i].reset
    end
  end
end

class Button
  def initialize(x,y,symbol)
    @symbol=symbol
    @x=x; @y=y;
    @sq = Square.new(
      x: x, y: y,
      size: $rx/4-$bor,
      color: 'black',
      z: 10
    )
    if @symbol=='=' or @symbol=='C'
      @sq.color='red'
    end
    @tag = Text.new(
      @symbol,
      x: x+$bor*2, y: y+$bor,
      font: 'data-latin.ttf',
      size: 36, color: 'white',
      z: 20
    )
    @color=@sq.color
  end

  def action(x,y,a)
    if @sq.x<x and x<@sq.x+@sq.size and @sq.y<y and y<@sq.y+@sq.size
      case a
      when 'click'
          @sq.color='silver'
      when 'perform'
        return @symbol
      end
    end
  end

  def reset
    @sq.color=@color
  end
end


kalk=Kalkulator.new
zegar = 0
update do
  if zegar % 1 == 0
    kalk.update
  end
    on :mouse_down do |event|
      if $mbr==0
        kalk.action(event.x,event.y,'click')
        kalk.action(event.x,event.y,'perform')
        $mbr=1
      end
    end
    on :mouse_up do
      kalk.reset; $mbr=0;
    end
    #puts event
  #end
  zegar += 1
end

show
