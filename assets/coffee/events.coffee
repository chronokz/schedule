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
			if busytd[i][n][0] == currentLabelTr && busytd[i][n][1] == currentLabelTd && parseInt(i) != parseInt(currentLabel.data('index'))
				return true
	return false

###delete_poisition = ->
	for i of busytd
		if busytd[i][0] == currentLabelTr && busytd[i][1] == currentLabelTd
			busytd[i] = []###

# New Instance
$('#schedule tbody').on 'mousedown', 'td', (e) -> 
	if e.which == 1
		mouseIsDown = true
		mouseElStart = $(this)
		currentLabel = $('<div class="label label-primary label-td">&nbsp;</div>')
		labelTrLevel = $(this).closest('tr').index()
		$(this).append(currentLabel)
		# range = $(this).width()/2-e.offsetX
		# if range > 0
		# 	currentLabel.css('left', '25%')
		# else
		# 	currentLabel.css('left', '75%')
		

$('#schedule tbody').on 'mouseup', 'td', (e) ->
	if e.which == 1
		mouseIsDown = false
		if labelDrag
			tr_level = $(this).closest('tr').index()
			td_level = labelTdLevel
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
			if mouseElFinish && mouseElStart
				tr_level = labelTrLevel
				width = (mouseElFinish.index()-mouseElStart.index()+1)*100
				currentLabel.css('width', width+'%')
				currentLabel.css('z-index', 100)
				# range = $(this).width()/2-e.offsetX
				# if range > 0
				# 	width-=50
				# else
				# 	width+=0
				currentLabel.css('width', width+'%')
				$('#schedule_form').modal 'show'
				$('#schedule_form').addClass 'create'
				$('#schedule_form input').val('')

				busytd[labelIndex] = []
				i = mouseElStart.index()
				while i < mouseElFinish.index()
					busytd[labelIndex].push([tr_level, i])
					i++

				currentLabel.attr('data-index', labelIndex)
				labelIndex++

				

$('#schedule tbody').on 'mousemove', 'td', (e) ->
	if mouseIsDown
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
			tr_level = $(this).closest('tr').index()

			if !check_collision(tr_level, $(this).index())
				width = (mouseElCurrent.index()-mouseElStart.index()+1)*100
				# range = $(this).width()/2-e.offsetX
				# if range > 0
				# 	width-=50
				# else
				# 	width+=0
				currentLabel.css('width', width+'%')


# Label
$('#schedule tbody').on 'mousedown', '.label-td', (e) ->
	console.info 'mousedown'
	if e.which == 1
		labelDrag = true
		mouseIsDown = true
		e.stopPropagation()
		currentLabel = $(this)
		labelTdLevel = $(this).closest('td').index()

$('#schedule tbody').on 'dblclick', '.label-td', (e) ->
	console.info 'dblclick'
	if e.which == 1
		currentLabel = $(this)
		$('#schedule_form').modal 'show'
		$('#schedule_form').addClass 'edit'
		$('#schedule_form #input-name').val($(this).text())

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


# Form
$('#schedule_form form').submit ->
	$('#schedule_form').modal 'hide'
	currentLabel.text($(this).find('#input-name').val())
	currentLabel.attr 'class', 'label label-primary label-td'
	currentLabel.addClass 'label-td-'+$(this).find('#input-status').val()

	if $('#input-laterin').prop('checked')
		newLeft = parseInt(currentLabel[0].style.left)+25
		newWidth = parseInt(currentLabel[0].style.width)-25
		currentLabel.css('left', newLeft+'%')
		currentLabel.css('width', newWidth+'%')

	if $('#input-laterout').prop('checked')
		newWidth = parseInt(currentLabel[0].style.width)+25
		currentLabel.css('width', newWidth+'%')

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