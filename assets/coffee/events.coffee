mouseIsDown = false
mouseElStart = false
mouseElFinish = false
mouseElCurrent = false
monthMouse = 0
monthMouseLeft = 0
currentLabel = false
labelDrag = false
labelTdLevel = false
labelTrLevel = false
labelIndex = 0
statuses = ['green', 'blue', 'red', 'yellow']
# xMove = false

# Busy
busytd = []

# Set table position
currentDate = new Date()
currentYear = new Date(2015, 0, 1)
currentDay = (Math.floor((currentDate.getTime()-currentYear.getTime())/1000/60/60/24))
monthMouseLeft = -currentDay*60
$('#schedule').css('left', monthMouseLeft)

# allow_self
# Если да, то не будет проверять сталкивается ли сам собой
# По умолчнию false
check_collision = (currentLabelTr, currentLabelTd, allow_self) ->
	if allow_self
		allow_self = true
	else
		allow_self = false

	# console.log 'allow_self:', allow_self

	for i of busytd
		for n of busytd[i]
			# console.info busytd[i][n][0], currentLabelTr
			# console.log busytd[i][n][1], currentLabelTd
			# console.log parseInt(i), parseInt(currentLabel.data('index'))

			if !allow_self && currentLabel
				if busytd[i][n][0] == currentLabelTr && busytd[i][n][1] == currentLabelTd && parseInt(i) != parseInt(currentLabel.data('index'))
					return true
			else
				if busytd[i][n][0] == currentLabelTr && busytd[i][n][1] == currentLabelTd
					return true
	return false

###delete_poisition = ->
	for i of busytd
		if busytd[i][0] == currentLabelTr && busytd[i][1] == currentLabelTd
			busytd[i] = []###

# New Instance
$('#schedule tbody').on 'mousedown', 'td', (e) -> 
	# console.info 'newinit'
	if e.which == 1

		tr_level = $(this).closest('tr').index()
		td_level = $(this).index()

		check_laterout = false
		$('#schedule tbody tr:eq('+tr_level+') .label-td.laterout').each ->
			currentLabel = $(this)
			if check_collision(tr_level, td_level-1, 1)
				check_laterout = true

		if check_laterout
			alert 'В этом дне выезд будет позже'
			return false


		# console.warn tr_level, td_level
		if !check_collision(tr_level, td_level, 1)
			mouseIsDown = true
			mouseElStart = $(this)

			currentLabel = $('<div class="label label-primary label-td"><span class="text">&nbsp;</span></div>')
			$(this).append(currentLabel)

			currentLabel.css('left', '50%')

			# range = $(this).width()/2-e.offsetX
			# if range > 0
			# 	currentLabel.css('left', '25%')
			# else
			# 	currentLabel.css('left', '75%')
		else
			currentLabel = null

$('#schedule tbody').on 'mouseup', 'td', (e) ->
	if e.which == 1
		if labelDrag
			tr_level = level_index()
			td_level = first_index()
			currentLabel.appendTo($('#schedule tbody tr:eq('+tr_level+') td:eq('+td_level+')'))
			###			len = Math.floor(parseInt(currentLabel[0].style.width)/100)
			i = 0
			isCollision = false
			while i<len
				if check_collision(tr_level, labelTdLevel+i)
					isCollision = true
				i++

			if !isCollision
				currentLabel.appendTo($('#schedule tbody tr:eq('+tr_level+') td:eq('+td_level+')'))

			###
			busytd[currentLabel.data('index')] = []
			i = first_index()
			while i < last_index()
				busytd[currentLabel.data('index')].push([tr_level, i])
				# console.warn tr_level, i
				i++
			labelDrag = false

			if mouseElStart.closest('tr').index() != tr_level
				api.call_move()

		else if mouseIsDown
			mouseElFinish = $(this)
			if mouseElFinish && mouseElStart && currentLabel
				tr_level = level_index()
				# width = (mouseElFinish.index()-mouseElStart.index())*100
				# currentLabel.css('width', width+'%')
				currentLabel.css('z-index', 100)

				# left = currentLabel[0].style.left
				# range = $(this).width()/2-e.offsetX
				# if range > 0
				# 	if (left == '25%')
				# 		width-=0
				# 	else
				# 		width-=50
				# else
				# 	if (left == '25%')
				# 		width+=25
				# 	else
				# 		width-=25
				# currentLabel.css('width', width+'%')

				create_label()

				busytd[labelIndex] = []
				i = first_index() # mouseElStart.index()
				while i < last_index() # mouseElFinish.index()
					busytd[labelIndex].push([tr_level, i])
					i++

				currentLabel.attr('data-index', labelIndex)
				labelIndex++
		mouseIsDown = false

$('#schedule tbody').on 'mousemove', 'td', (e) ->
	if mouseIsDown
		# console.log labelDrag
		if labelDrag
			tr_level = $(this).closest('tr').index()
			td_level = labelTdLevel

			len = Math.floor(parseInt(currentLabel[0].style.width)/100)
			i = 0
			isCollision = false
			while i<len
				if check_collision(tr_level, labelTdLevel+i)
					isCollision = true
				i++

			if $('#schedule tbody tr:eq('+tr_level+') td:eq('+(last_index())+') .label-td.earlyin').length
				isCollision = true


			if !isCollision
				currentLabel.appendTo($('#schedule tbody tr:eq('+tr_level+') td:eq('+td_level+')'))
			
		else
			mouseElCurrent = $(this)

			isCollision = false

			tr_level = currentLabel.closest('tr').index()

			len = Math.floor(parseInt(currentLabel[0].style.width)/100)
			i = 0
			isCollision = false
			while i<len
				i++
				if check_collision(tr_level, first_index()+i, 1)
					isCollision = true


			if $('#schedule tbody tr:eq('+tr_level+') td:eq('+(first_index()+len+1)+') .label-td.earlyin').length
				isCollision = true

			if $(this).index() < first_index()+len
				isCollision = false
			

			if !isCollision
				width = (mouseElCurrent.index()-mouseElStart.index())*100
				# left = currentLabel[0].style.left
				# range = $(this).width()/2-e.offsetX
				# if range > 0
				# 	if (left == '25%')
				# 		width-=0
				# 	else
				# 		width-=50
				# else
				# 	if (left == '25%')
				# 		width+=25
				# 	else
				# 		width-=25
				currentLabel.css('width', width+'%')
			

# $('#schedule tbody').on 'mousemove', '.label-td', (e) ->
# 	console.info e


# Label
dbl = 0

$('#schedule tbody').on 'mousedown', '.label-td', (e) ->
	setTimeout (->
		dbl = 0
	), 700
	dbl++
	e.stopPropagation()
	if dbl > 1
		dbl = 0
		edit_label()
	else
		labelDrag = true
		if e.which == 1
			mouseIsDown = true
			currentLabel = $(this)
			labelTdLevel = $(this).closest('td').index()

$('#schedule tbody').on 'dblclick', '.label-td', (e) ->
	if e.which == 1
		currentLabel = $(this)
		edit_label()

first_index = ->
	currentLabel.parent().index()

last_index = ->
	currentLabel.parent().index()+(parseInt(currentLabel[0].style.width)/100)

level_index = ->
	currentLabel.closest('tr').index()

label_width = ->
	parseInt(currentLabel[0].style.width)/100

edit_label = -> 
	api.call_edit(currentLabel.data('index'))
	$('#schedule_form').modal 'show'
	$('#schedule_form').addClass 'edit'
	$('#schedule_form #input-name').val(currentLabel.children('.text').text())
	$('#input-earlyin').prop 'checked', currentLabel.hasClass 'earlyin'
	$('#input-laterout').prop 'checked', currentLabel.hasClass 'laterout'
	i = 0
	while i < statuses.length
		if currentLabel.hasClass 'label-td-'+statuses[i]
			$('#input-status').val('label-td-'+statuses[i])
		i++

create_label = ->
	$('#schedule_form').modal 'show'
	$('#schedule_form').addClass 'create'
	$('#schedule_form input').val('')
	$('#input-earlyin').prop 'checked', false
	$('#input-laterout').prop 'checked', false


$('#input-earlyin').click ->
	if check_collision(currentLabel.closest('tr').index(), first_index()-1, 1)
		alert 'Ранний заезд невозможен!'
		$(this).prop 'checked', false

$('#input-laterout').click ->
	if check_collision(currentLabel.closest('tr').index(), last_index()+1, 1)
		alert 'Поздний выезд невозможен!'
		$(this).prop 'checked', false


# Month
$('#schedule thead').on 'mousedown', 'th', (e) ->
	# console.info 'pageX:' + e.pageX
	monthMouse = e.pageX
	monthMouseLeft = parseInt $('#schedule').css 'left'

$('#schedule thead').mousemove (e) ->
	# console.info monthMouse
	if monthMouse
		$('#schedule').css
			'left': e.pageX - monthMouse + monthMouseLeft


$('#schedule').on 'mouseup', 'thead', ->
	monthMouse = 0

$('#schedule').on 'mouseleave', 'thead', ->
	monthMouse = 0


# Form
$('#schedule_form form').submit ->

	$('#schedule_form').modal 'hide'
	currentLabel.children('.text').text($(this).find('#input-name').val())
	currentLabel.attr 'class', 'label label-primary label-td'
	currentLabel.addClass 'label-td-'+$(this).find('#input-status').val()

	if $('#input-earlyin').prop('checked')
		currentLabel.addClass 'earlyin'
	else
		currentLabel.removeClass 'earlyin'

	if $('#input-laterout').prop('checked')
		currentLabel.addClass 'laterout'
	else
		currentLabel.removeClass 'laterout'

	$('#schedule_form').removeClass('create').removeClass('edit')
	return false

$('#schedule_form form .action_cancel').click ->
	$('#schedule_form').modal 'hide'
	if $('#schedule_form').hasClass 'create'
		currentLabel.remove()
		busytd[currentLabel.data('index')] = []
	$('#schedule_form').removeClass('create').removeClass('edit')

$('#schedule_form form .action_remove').click ->
	$('#schedule_form').modal 'hide'
	$('#schedule_form').removeClass('create').removeClass('edit')
	currentLabel.remove()
	busytd[currentLabel.data('index')] = []

$('#schedule_form').click ->
	$('#schedule_form').modal 'hide'
	if $('#schedule_form').hasClass 'create'
		currentLabel.remove()
		busytd[currentLabel.data('index')] = []
	$('#schedule_form').removeClass('create').removeClass('edit')

$('#schedule_form .modal-dialog').click (e) ->
	e.stopPropagation();

$(document).keyup (e) ->
	if e.keyCode == 27
		$('#schedule_form .action_cancel').click()