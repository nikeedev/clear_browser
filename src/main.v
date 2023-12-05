module main

import gg
import gx
import os
import net.html
import encoding.xml
import net.http
import term

struct Element {
mut:
	text         string
	size         int // pixel font
	pos_x        int
	pos_y        int
	element_type string
}

struct App {
mut:
	ctx      &gg.Context = unsafe { nil }
	image    []gg.Image
	elements []Element
}

const (
	// win_title  = 'Clear Browser - by nikeedev'
	win_width  = 800
	win_height = 600
	fpath      = os.resource_abs_path('JetBrainsMono-Regular.ttf')
)

fn main() {

	mut win_title := ""

	if os.args.len < 2 {
		println(term.blue('Clear Browser- v0.1.0a'))
		println(term.cyan('\nUsage: clear_browser <HTML source code file>.html'))
		exit(0)
	}

	if os.args[1].starts_with('https://') || os.args[1].starts_with('http://') {
		println(term.green('HTTP requests to a website is not yet available'))
		exit(0)
	} else if !os.args[1].ends_with('.html') {
		println(term.red("The file doesn't end with .html"))
		exit(-1)
	}

	file := os.read_lines(os.args[1])!
	mut html_file := ''

	for line in file {
		html_file += line.trim_space()
		// println(line)
	}
	// println(html_file)

	mut doc := html.parse(html_file).get_root()

	// println(doc)

	win_title = doc[0].get_tags("title")[0].text()
	mut body := doc[0].get_tags("body")

	mut elements := []Element{}
	for i := 2; i < body.len; i++ {
		mut tag := body[i]

		// println(tag.name)
		mut element := match tag.name {
			'h1' {
				Element{
					text: tag.text()
					size: 22
					pos_x: 20 // same as size
					pos_y: 10 * int(f32(i) * 0.15) + 22
					element_type: 'h1'
				}
			}
			'h2' {
				Element{
					text: tag.text()
					size: 18
					pos_x: 20
					pos_y: 10 * int(f32(i) * 0.25) + 18
					element_type: 'h2'
				}
			}
			'h3' {
				Element{
					text: tag.text()
					size: 15
					pos_x: 20
					pos_y: 10 * int(f32(i) * 0.35) + 15
					element_type: 'h3'
				}
			}
			'p' {
				Element{
					text: tag.text()
					size: 12
					pos_x: 20
					pos_y: 10 * i + 12
					element_type: 'p'
				}
			}
			'title' {
				win_title = tag.text()
				Element{
					text: "",
					element_type: 'title'
				}
			}
			else {
				Element{
					text: tag.text()
					size: 12
					pos_x: 20
					pos_y: 10 * i + 12
					element_type: 'text'
				}
			}
		}

		elements.insert(i - 2, element)
	}

	// for element in elements {
	// 	println(element)
	// }
	mut app := &App{
		ctx: 0
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
		init_fn: init
		resized_fn: resize_window
		font_path: fpath
	)

	app.ctx.run()
}

fn resize_window(e &gg.Event, mut app App) {
	app.ctx.width = e.window_width
	app.ctx.height = e.window_height
}

fn init(mut app App) {
}

// [live]
fn (app &App) draw() {
	if app.ctx.pressed_keys[int(gg.KeyCode.escape)] {
		app.ctx.quit()
	}

	for i, element in app.elements {
		println("${i}: ${element}")

		app.ctx.draw_text(element.pos_x, element.pos_y, element.text, gx.TextCfg{
			size: element.size
		})
	}
}

fn frame(app &App) {
	app.ctx.begin()

	app.draw()

	app.ctx.end()
}

fn render_html(doc html.DocumentObjectModel) {
}
