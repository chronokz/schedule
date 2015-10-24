api = {}

# Создать бронь
api.create = (x, y, w) ->
	alert 'create'

# Отредактировать бронь
api.edit = (id) ->
	currentLabel = $('.label-td[data-index='+id+']')
	edit_label()
	currentLabel

# Сохранение брони
api.update = ->	
	alert 'update'

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

api.call_move = ->
	data =
		id: currentLabel.data('index')
		y: level_index()
		x: first_index()
	api.move(data)
