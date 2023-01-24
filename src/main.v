module main

import gg
import gx
import os

struct App {
mut:
	ctx    &gg.Context = unsafe { nil }
	image []gg.Image
}

const (
	win_title = "Clear Browser - by nikeedev"
	win_width = 800
	win_height = 600
)

fn main() {
	// mut pos := playlib.Vec3{5, 5, 6}
	// mut vecs := [Vec2{5, 5}, Vec2{6, 6}, Vec2{7, 7}]
	// pos += playlib.Vec3{10, 10, 11}

	// for vec in vecs {
	// 	println(vec.str())
	// }

	mut app := &App{
		ctx: 0
	}

	app.ctx = gg.new_context(
		bg_color: gx.white
		width: win_width
		height: win_height
		create_window: true
		window_title: win_title
		frame_fn: frame
		user_data: app
		init_fn: init
	)

	// println(pos.str())

	app.ctx.run()
}

fn init(mut app &App) {

}

[live]
fn (app &App) draw() {
	mut rect := gg.Rect{x: 40, y: 40, width: 60, height: 40}

	app.ctx.draw_rect_filled(rect.x, rect.y, rect.width, rect.height, gx.rgb(100, 149, 237))

	app.ctx.draw_text_def(40+10, 40+12, 'game.')
}


fn frame(app &App) {
	app.ctx.begin()
	app.draw()
	app.ctx.end()
}
