class UI
	constructor: ->
		@timer = new Timer this
		@timer_label = @$ "timer_label"

	get_timer: -> @timer

	$: (id) -> document.getElementById id

	running_fn: (t) ->
		@timer_label.innerHTML = t
		@timer_label.style.color="black"

	inspecting_fn: (t) ->
		@timer_label.innerHTML = t
		@timer_label.style.color="red"
