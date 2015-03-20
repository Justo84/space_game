require 'gosu'
require_relative 'player'
require_relative 'star'

module ZOrder
  # Background, Stars, Player, UI = *0..3
  Star = 1
  Shot = 2
  Ship = 3
  UI = 4
end

class GameWindow < Gosu::Window

  def initialize

    super(640, 480, false)
    self.caption = "Space'um!"

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @counter = 0

    @background_image = Gosu::Image.new(self, "media/space.png", true)

    @star_anim = Gosu::Image::load_tiles(self, "media/star.png", 25, 25, false)

    @ship_image = Gosu::Image.new(self, "media/starfighter.png")

    @shield_image = Gosu::Image.new(self, "media/shield.png", false)

    @player = Player.new(self)
    @player.warp(320, 240)

    @stars = Array.new

  end

  def update

    @counter += 1

    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end

    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end

    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
    end

    @player.move
    @player.collect_stars(@stars)

    if rand(100) < 4 and @stars.size < 25 then
      @stars.push(Star.new(@star_anim))
    end

  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    # @stars.each { |star| star.draw }
    # @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)

    @font.draw("Updates: #{@counter}", 0, 0, ZOrder::UI, 1.0, 1.0, 0xffffff00)

    @star_anim.each_with_index do |tile, i|
      tile.draw(100 + (40 *i), 50, ZOrder::Star)
    end

    img = @star_anim[(Gosu::milliseconds / 100) % @star_anim.size]
    img.draw(100, 120, ZOrder::Star)

    img.draw(100, 220, ZOrder:Star, 2.0, 2.0, 0xff1199dd)

    img.draw_rot(100, 340, ZOrder::Star, -90, 0.5, 0.5, 3.0, 3.0, 0xff99dd33)

    x = 400
    y = 120
    draw_quad(x - 2, y, 0xffd936f1,
              x + 2, y, 0xffd936f1,
              x - 2, y + 20, 0xff000000,
              x + 2, y + 20, 0xff000000, ZOrder::Shot)

    x = 400
    y = 220
    draw_quad(x - 4, y, 0xffaa0000,
              x + 4, y, 0xffaa0000,
              x - 4, y + 20, 0xffaacc00,
              x + 4, y + 20, 0xffaacc00, ZOrder::Shot)

    @ship_image.draw_rot(400, 360, ZOrder::Ship, 0)

    angle = (Gosu::milliseconds / 15) % 360
    @shield_image.draw_rot(400, 360, ZOrder::Shot, angle, 0.5, 0.5, 0.75, 0.75, 0xff3366ff)
  end

  def button_down(id)
    # if id == Gosu::KbEscape
    case id
    when Gosu::KbEscape
        close
    end
  end

end

window = GameWindow.new
window.show
