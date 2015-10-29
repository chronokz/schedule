month = [
	'Январь'
	'Февраль'
	'Март'
	'Апрель'
	'Май'
	'Июнь'
	'Июль'
	'Август'
	'Сентябрь'
	'Октябрь'
	'Ноябрь'
	'Декабрь'
]

weeks = [
	'Вс'
	'Пн'
	'Вт'
	'Ср'
	'Чт'
	'Пт'
	'Сб'
]

###
date = new Date Date.parse 'January 1, 2015'
y = 2015
m = 0
variants = $('#variants tbody tr').length

v = 0
while v < variants
	$('#schedule tbody').append('<tr></tr>')
	v++

yd = 0
while m < 12
	dayInMonth = new Date(y,m+1,0).getDate()
	td = $('<th colspan="'+dayInMonth+'">'+month[m]+'</th>')
	$('#schedule thead tr:first').append(td)
	d = 0
	m++
	while d < dayInMonth
		d++
		yd++
		dayOfWeek = new Date(y,m,d).getDay()
		$('#schedule thead tr:last').append('<th>'+'<span class="dayOfWeek">'+weeks[dayOfWeek]+'</span> <span class="dayInMonth">'+d+'</span></th>')
		$('#schedule tbody tr').append('<td data-day="'+d+'" data-month="'+m+'" data-year="'+y+'"></td>')


$('#schedule tbody td[data-day="'+currentDate.getDate()+'"][data-month="'+(currentDate.getMonth()+1)+'"]').addClass('today')
###