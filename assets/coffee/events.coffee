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
# xMove = false

# Busy
busytd = []

# Set table position
currentDate = new Date()
currentYear = new Date(2015, 0, 1)
currentDay = (Math.floor((currentDate.getTime()-currentYear.getTime())/1000/60/60/24))
monthMouseLeft = -currentDay*35
$('#schedule').css('left', monthMouseLeft)

check_collision = (currentLabelTr, currentLabelTd) ->
	for i of busytd
		for n of busytd[i]
			console.info busytd[i][n][0], currentLabelTr
			console.log busytd[i][n][1], currentLabelTd
			console.log parseInt(i), parseInt(currentLabel.data('index'))
			if busytd[i][n][0] == currentLabelTr && busytd[i][n][1] == currentLabelTd# && parseInt(i) != parseInt(currentLabel.data('index'))
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
		currentLabel = $('<div class="label label-primary label-td">&nbsp;</div>')
		td_level = $(this).index()
		tr_level = $(this).closest('tr').index()

		if !check_collision(tr_level, td_level)
			mouseIsDown = true
			mouseElStart = $(this)

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
		mouseIsDown = false
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
			i = mouseElStart.index()
			while i < mouseElFinish.index()
				busytd[currentLabel.data('index')].push([tr_level, i])
				i++
			labelDrag = false
		else
			mouseElFinish = $(this)
			if mouseElFinish && mouseElStart && currentLabel
				tr_level = level_index()
				width = (mouseElFinish.index()-mouseElStart.index())*100
				currentLabel.css('width', width+'%')
				currentLabel.css('z-index', 100)

				left = currentLabel[0].style.left
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

				create_label()

				busytd[labelIndex] = []
				i = first_index() # mouseElStart.index()
				while i < last_index() # mouseElFinish.index()
					busytd[labelIndex].push([tr_level, i])
					i++

				currentLabel.attr('data-index', labelIndex)
				labelIndex++

				

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
			if !isCollision
				currentLabel.appendTo($('#schedule tbody tr:eq('+tr_level+') td:eq('+td_level+')'))
			
		else
			mouseElCurrent = $(this)
			# tr_level = $(this).closest('tr').index()
			# i = currentLabel.parent().index()
			# i = 0
			# len = $(this).index()-currentLabel.parent().index()
			# console.warn len
			isCollision = false
			# while i<len
			# 	i++
			# 	td_level = $(this).index()+i
			# 	# console.log tr_level, td_level
			# 	if check_collision(tr_level, td_level)
			# 		isCollision = true
			# console.info isCollision
			# if isCollision
			# 	console.log 'aaa'

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

edit_label = -> 
	$('#schedule_form').modal 'show'
	$('#schedule_form').addClass 'edit'
	$('#schedule_form #input-name').val(currentLabel.text())
	$('#input-earlyin').prop 'checked', currentLabel.hasClass 'earlyin'
	$('#input-laterout').prop 'checked', currentLabel.hasClass 'laterout'

create_label = ->
	$('#schedule_form').modal 'show'
	$('#schedule_form').addClass 'create'
	$('#schedule_form input').val('')
	$('#input-earlyin').prop 'checked', false
	$('#input-laterout').prop 'checked', false


$('#input-earlyin').click ->
	if check_collision(currentLabel.closest('tr').index(), first_index())
		alert 'Ранний заезд невозможен!'
		$(this).prop 'checked', false

$('#input-laterout').click ->
	if check_collision(currentLabel.closest('tr').index(), last_index())
		alert 'Поздний выезд невозможен!'
		$(this).prop 'checked', false


# Month
$('#schedule thead').on 'mousedown', 'th', (e) ->
	monthMouse = e.pageX
	monthMouseLeft = parseInt $('#schedule').css 'left'

$('#schedule thead').mousemove (e) ->
	if monthMouse
		$('#schedule').css
			'left': e.pageX - monthMouse + monthMouseLeft


$('#schedule thead').on 'mouseup', 'th', (e) ->
	monthMouse = 0

$('#schedule thead').on 'mouseout', 'th', (e) ->
	monthMouse = 0


# Form
$('#schedule_form form').submit ->

	$('#schedule_form').modal 'hide'
	currentLabel.text($(this).find('#input-name').val())
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