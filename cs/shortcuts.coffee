class Shortcuts
	@space = 32
	@esc = 27

	constructor: ->
		@down = {}
		@up = {}
		document.onkeydown = @key_down
		document.onkeyup = @key_up

	add_key: (key, shortcut, dir) ->
		shortcut['shift'] = !!shortcut['shift']
		if isNaN(key)
			key = key.charCodeAt(0)
		if !dir[key]
			dir[key] = []
		dir[key][dir[key].length] = shortcut

	add_down: (key, shortcut) ->
		@add_key key, shortcut, @down

	add_up: (key, shortcut) ->
		@add_key key, shortcut, @up

	key_down: (ev) => do_key(ev, @down)
	key_up: (ev) => do_key(ev, @up)

	do_key = (ev, dir) ->
		callbacks = dir[ev.keyCode]
		return if !callbacks

		for s in callbacks
			s['fn'](ev) if s['shift'] == ev.shiftKey
		null
