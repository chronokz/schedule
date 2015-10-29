api = {}

# Создать бронь
# id - желаемый id брони, если указывать (0/false/null) то будет задаваться автоматически
# y - линия куда будет установлена бронь
# day - день месяца куда будет установлена бронь (Формат: d)
# month - месяц где будет начинатся бронь (Формат: m)
# w - длина, сколько дней будет забронировано
# data.name - имя
# data.email - e-mail
# data.earlyin - ранний заезд (формат 1/0)
# data.laterout - поздний выезд (формат 1/0)
# data.status - статус брони (на данный момент есть следующие css-классы 'green', 'blue', 'red', 'yellow')
api.create = (id, y, day, month, w, data) ->
	if (id)
		labelIndex = id

	earlyin = ''
	if (data.earlyin)
		earlyin = 'earlyin'

	laterout = ''
	if (data.laterout)
		laterout = 'laterout'

	currentLabel = $('<div class="label label-primary label-td '+laterout+' '+earlyin+'"><span class="text">'+data.name+'</span></div>')
	currentLabel.addClass 'label-td-'+data.status
	parent_td = $('#schedule tbody tr:eq('+y+') td[data-day="'+day+'"][data-month="'+month+'"]')
	parent_td.append(currentLabel)
	currentLabel.css('left', '50%')
	currentLabel.css('width', w*100+'%')
	currentLabel.css('z-index', 100)
	currentLabel.attr('data-index', labelIndex)
	busytd[labelIndex] = []
	i = parent_td.index()
	while i < parent_td.index()+w
		busytd[labelIndex].push([y, i])
		i++
	labelIndex++
	currentLabel

# Отредактировать бронь
api.edit = (id) ->
	currentLabel = $('.label-td[data-index='+id+']')
	edit_label()

# Получить вызов брони по вызову редактирования
api.call_edit = (id) ->
	console.log 'Demo:', id

# Сохранение брони
# id - id брони, хранится в аттрибуте data-index
# data.name - имя
# data.email - email
# data.earlyin - ранний заезд (формат 1/0)
# data.laterout - поздний выезд (формат 1/0)
# data.status - статус брони (на данный момент есть следующие css-классы 'green', 'blue', 'red', 'yellow')
api.update = (id, data) ->
	currentLabel = $('.label-td[data-index='+id+']')
	currentLabel.children('.text').text(data.name)
	currentLabel.attr 'class', 'label label-primary label-td'
	currentLabel.addClass 'label-td-'+data.status

	if data.earlyin
		currentLabel.addClass 'earlyin'
	else
		currentLabel.removeClass 'earlyin'

	if data.laterout
		currentLabel.addClass 'laterout'
	else
		currentLabel.removeClass 'laterout'

# Получить вызов брони по вызову редактирования
# y - линия куда будет установлена бронь
# checkin - дата заезда
# checkout - дата выезда
api.call_create = (y, checkin, checkout) ->
	console.log 'Demo:', y, checkin, checkout
	

# Удаление брони
# id (int) - id брони, хранится в аттрибуте data-index
api.remove = (id) ->
	currentLabel = $('.label-td[data-index='+id+']')
	currentLabel.remove()
	busytd[currentLabel.data('index')] = []

# Перемещение брони (callback)
# data.id (int) - id брони, хранится в аттрибуте data-index
# data.x (int) - конечная позиция брони в ячейке по x
# data.y (int) - конечная позиция брони в ячейке по y
# use: api.move = function(data){ console.log(data) }
api.move = (data) ->
	console.log 'Demo:', data

# Вызов callback
api.call_move = ->
	data =
		id: currentLabel.data('index')
		y: level_index()
		x: first_index()
	api.move(data)


# Создать таблицу по запросу
# start - Генерировать таблицу начиная с даты Y-m-d
# end - Генерировать таблицу начиная до даты Y-m-d
api.generate = (start, end) ->

	# reset to default
	$('#schedule').css 'left', 0
	$('#schedule thead tr, #schedule tbody').html('')



	st = start.split '-'
	en = end.split '-'
	start_date = new Date(st[0], st[1], st[2])
	end_date = new Date(en[0], en[1], en[2])

	variants = $('#variants tbody tr').length

	v = 0
	while v < variants
		$('#schedule tbody').append('<tr></tr>')
		v++

	start_y = parseInt(st[0])
	start_m = parseInt(st[1])
	end_y = parseInt(en[0])
	end_m = parseInt(en[1])
 
	while start_y <= end_y

		if start_y == end_y
			month_count = end_m
		else
			month_count = 12

		# Months
		while start_m <= month_count
			dayInMonth = new Date(start_y,start_m,0).getDate()
			td = $('<th colspan="'+dayInMonth+'">'+month[start_m-1]+'</th>')
			$('#schedule thead tr:first').append(td)

			d = 0
			while d < dayInMonth
				d++
				dayOfWeek = new Date(start_y,start_m-1,d).getDay()
				$('#schedule thead tr:last').append('<th>'+'<span class="dayOfWeek">'+weeks[dayOfWeek]+'</span> <span class="dayInMonth">'+d+'</span></th>')
				$('#schedule tbody tr').append('<td data-day="'+d+'" data-month="'+start_m+'" data-year="'+start_y+'"></td>')

			start_m++
			
		
		if start_m >= 12
			start_m = 1
		start_y++

	$('#schedule tbody td[data-day="'+currentDate.getDate()+'"][data-month="'+(currentDate.getMonth()+1)+'"]').addClass('today')
	# centering = $('.limiter').width()/2-30
	$('#schedule').css 'left', -($('#schedule tbody td.today').index()-3)*60
	api.call_generate()


api.call_generate = ->
	console.log 'Calendar was generated'