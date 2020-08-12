### FDC 2020 ###
require "ruby2d"
$t=Time.new

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
    @mind = Depth.new
    @message = @mind.influence

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
    ml = @message.length
    @screentext.x = $rx-4*$bor-dl*@fw
    if @shift>$rx+21*(ml+1)
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
          @message=@mind.influence(self,symbol,a)
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

class Depth
  def influence(sk='init',symbol=NIL,action=NIL)
    if sk == 'init'
      self.greetings
    else
      case symbol
      when '0'
        msg = [['Emptiness',1],['Null',1],['Void',1],['Zero',0]]
      when '1'
        msg = [['First!!',0],['Unity',-1],['The One',-1],['The lonely number',1]]
      when '2'
        msg = [['A pair',0],['Double trouble!',4],
        ['The Duality',-1],['A couple',0]]
      when '3'
        msg = [['Start, middle and finish',0],['Triple!!',0],['3dom!!!!',0],
        ['Three is a charm',-1],['The power of triforce',4]]
      when '4'
        msg = [['Stable like a table',0],['four4ever!',0]]
      when '5'
        msg = [['High five!',0],['The quintessence!',2]]
      when '6'
        msg = [['Half a dozen, please!',0],['666',4]]
      when '7'
        msg = [['~777~ Lucky strike!',0],['Oh good Heavens!',3]]
      when '8'
        msg = [['Oi, m8!',0],['K8 8 some b8',3]]
      when '9'
        msg = [['NEIN!',3],['999',3]]
      when '+'
        msg = [['Keep it possitive!',0],["Don't get too greedy",2],
        ["Let's add something!",0],['More? MOAR!!',3]]
      when '-'
        msg = [["Don't get too negative...",2],['The number will go down!',1]]
      when 'x'
        msg = [['How many times?',0],['More x More!',0]]
      when ':'
        msg = [['[The division]',-1],['Into the pieces!',4]]
      when 'C'
        msg = [['ALL CLEAR!!',3]]
      when '='
        msg = [['Your results please!',0]]
      end
      msg=msg.sample
      #mood=msg[1]
      msg=msg[0]+self.emoticon(msg[1])
      return msg
    end
  end
  def greetings
    n=rand(4)
    case n
    when 0
      msg = 'Hello!'
    when 1
      msg = 'Hi!'
    when 2
      msg = 'Greetings!'
    when 3
      case $t.hour
      when  1..11
        msg = 'Good morning!'
      when 11..18
        msg = 'Good afternoon!'
      when 18..23
        msg = 'Good evening!'
      end
    end
    msg=msg+self.emoticon
    return msg
  end
  def emoticon(mood=0)
    case mood
    when 0 #friendly/joyful
      msg = [':)',';)','C:',':D','x)',':3','^^','uwu']
    when 1 #sad/depressed
      msg = [':(',":'(",':C',':/',':|','.-.','._.','unu']
    when 2 #surprised
      msg = [':o','o.0','o_0','D:']
    when 3 #annoyed
      msg = ['>_<','>.<','<_<','-_-','-_-"',':P','^^"','uwu"']
    when 4
      msg = ['>:)',':>','>:D','>:3']
    else
      msg = ['','']
    end
    msg=msg.sample
    msg= ' ' + msg
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
