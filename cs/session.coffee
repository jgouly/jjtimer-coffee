class Session
	@DNF: -1
	
	constructor: -> @solves = []

	length: -> @solves.length
	reset: -> @solves = [] 

	add: (solve) -> @solves[@solves.length] = solve
	delete: (index) -> @solves.splice index, 1

	current_average: (n) -> @average(@solves.length - n, n)

	session_average: -> @average(0, @solves.length)

	toggle_dnf: (index) ->
		index = @solves.length - 1 if index == null
		@solves[index]['DNF'] = !@solves[index]['DNF']

	toggle_plus_two: (index) ->
		index = @solves.length - 1 if index == null
		@solves[index]['plus_two'] = !@solves[index]['plus_two']
		@solves[index]['time'] += `this.solves[index]['plus_two'] ? 2000 : -2000`

	trim_count = (n) -> Math.ceil n / 20.0

	average: (index, length) ->
		return Session.DNF if (length - index) < 3

		trim = trim_count length
		copy = @solves.slice index, index + length
		copy.sort session_sort
		copy.splice 0, trim
		copy.splice copy.length - trim, trim

		return Session.DNF if copy[copy.length - 1]['DNF']

		sum = copy.reduce ((a, b) -> a + b['time']), 0
		sum / (length - (2 * trim))

	session_mean : ->
		return Session.DNF if @solves.length < 1

		dnfs = 0
		sum = @solves.reduce ((t, s) ->
			t + `s['DNF'] ? (++dnfs, 0) : s['time']`), 0

		return Session.DNF if @solves.length == dnfs
		sum / (@solves.length - dnfs)

	session_sort = (a, b) ->
		return 1  if a['DNF']
		return -1 if b['DNF']
		return a['time'] - b['time']

	best_average : (length, find_best_singles) ->
		best_avg = Infinity
		best_avg_index = -1
		best_single_index = -1
		worst_single_index = -1
		i = 0
		end = @solves.length - (length - 1)
		while i < end
			a = @average i, length
			if a < best_avg
				best_avg = a
				best_avg_index = i
			++i

		if find_best_singles && best_avg_index != -1
			best_single = Infinity
			worst_single = -Infinity
			
			i = best_avg_index
			end = best_avg_index + length
			while i < end
				if @solves[i]['time'] < best_single
					best_single = @solves[i]['time']
					best_single_index = i
				
				if @solves[i]['time'] > worst_single
					worst_single = @solves[i]['time']
					worst_single_index = i

		'avg': best_avg, 'index': best_avg_index, 
		'best_single_index': best_single_index,
		'worst_single_index': worst_single_index

	load: ->
		if localStorage
			local_solves = localStorage.getItem 'session.solves'
			if local_solves != null
				@solves = JSON.parse local_solves

	save: ->
		if localStorage
			localStorage.setItem 'session.solves', JSON.stringify @solves
