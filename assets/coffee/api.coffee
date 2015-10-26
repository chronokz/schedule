api = {}

# Создать бронь
# y - линия куда будет установлена бронь
# day - день месяца куда будет установлена бронь (Формат: d)
# month - месяц где будет начинатся бронь (Формат: m)
# w - длина, сколько дней будет забронировано
# data.name - имя
# data.email - e-mail
# data.earlyin - ранний заезд (формат 1/0)
# data.laterout - поздний выезд (формат 1/0)
# data.status - статус брони (на данный момент есть следующие css-классы 'green', 'blue', 'red', 'yellow')
api.create = (y, day, month, w, data) ->
	earlyin = (data.earlyin) ? 'earlyin' : ''
	laterout = (data.laterout) ? 'laterout' : ''
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
	currentLabel.children('.text').text($(this).find('#input-name').val())
	currentLabel.attr 'class', 'label label-primary label-td'
	currentLabel.addClass 'label-td-'+status

	if data.earlyin
		currentLabel.addClass 'earlyin'
	else
		currentLabel.removeClass 'earlyin'

	if data.laterout
		currentLabel.addClass 'laterout'
	else
		currentLabel.removeClass 'laterout'
	

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
