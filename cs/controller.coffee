class Controller
	constructor: ->
		@ui = new UI
		@timer = new Timer @ui
		@shortcuts = new Shortcuts

		@shortcuts.add_down Shortcuts.space, {fn: @timer.trigger_down}
		@shortcuts.add_up Shortcuts.space, {fn: @timer.trigger_up}

window.onload = ->
	new Controller()
