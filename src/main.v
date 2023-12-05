module main

import gg
import gx
import os
import net.html
import net.http
import term


struct Element {
mut:
	text string
	size int // pixel font
	width int
	height int
	element_type string
}

struct App {
mut:
	ctx    &gg.Context = unsafe { nil }
	image []gg.Image
	elements html.DocumentObjectModel
}

const (
	win_title = "Clear Browser - by nikeedev"
	win_width = 800
	win_height = 600
)

fn main() {

	if os.args.len < 2 {

		println(term.blue('Clear Browser- v0.1.0a'))
		println(term.cyan('\nUsage: clear_browser <HTML source code file>.html'))
		exit(0)

	}

	if os.args[1].starts_with("https://") || os.args[1].starts_with("http://") {
		println(term.green("HTTP requests to a website is not yet available"))
		exit(0)
	} else if !os.args[1].ends_with(".html") {
		println(term.red("The file doesn't end with .html"))
		exit(-1)
	}

	file := os.read_lines(os.args[1]) !
	mut html_file := ""

	for line in file {
		html_file += line.trim_space()
		println(line)
	}
	println(html_file)

	mut doc := html.parse(html_file).get_tags()

	mut elements := []Element{}
	for i := 2; i < doc.len; i++ {
		mut tag := doc[i]

		mut element :=
			match tag.name {
				"h1" {
					Element{
						text: tag.text(),
						size: 22
						width: 6 * tag.text().len
						height: 6
						element_type: "h1"
					}
				}
				"h2" {
					Element{
						text: tag.text(),
						size: 18
						width: 6 * tag.text().len
						height: 6
						element_type: "h1"
					}
				}
				"h3" {
					Element{
						text: tag.text(),
						size: 15
						width: 6 * tag.text().len
						height: 6
						element_type: "h1"
					}
				}
				"p" {
					Element{
						text: tag.text(),
						size: 10
						width: 6 * tag.text().len
						height: 6
						element_type: "h1"
					}
				}
				else {
					Element{
						text: tag.text(),
						size: 10
						width: 6 * tag.text().len
						height: 6
						element_type: ""
					}
				}
			}

		elements.prepend(element)
	}

	mut app := &App{
		ctx: 0,
		// elements: elements
	}

	app.ctx = gg.new_context(
		bg_color: gx.white
		width: win_width
		height: win_height
		create_window: true
		window_title: win_title
		frame_fn: frame
		user_data: app
		init_fn: init,
		resized_fn: resize_window
	)

	// app.ctx.run()
}

fn resize_window(e &gg.Event, mut app &App) {
	app.ctx.width = e.window_width
	app.ctx.height = e.window_height
}

fn init(mut app &App) {

}

// [live]
fn (app &App) draw(ctx &gg.Context) {
	if ctx.pressed_keys[int(gg.KeyCode.escape)] {
		exit(0)
	}
}


fn frame(app &App) {
	app.ctx.begin()

	app.draw(app.ctx)

	app.ctx.end()
}


fn render_html(doc html.DocumentObjectModel) {

}

