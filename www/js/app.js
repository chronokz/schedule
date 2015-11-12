var api;

api = {};

api.create = function(id, y, day, month, w, data) {
  var currentLabel, earlyin, i, labelIndex, laterout, parent_td;
  if (id) {
    labelIndex = id;
  }
  earlyin = '';
  if (data.earlyin) {
    earlyin = 'earlyin';
  }
  laterout = '';
  if (data.laterout) {
    laterout = 'laterout';
  }
  currentLabel = $('<div class="label label-primary label-td ' + laterout + ' ' + earlyin + '"><span class="text">' + data.name + '</span></div>');
  currentLabel.addClass('label-td-' + data.status);
  parent_td = $('#schedule tbody tr:eq(' + y + ') td[data-day="' + day + '"][data-month="' + month + '"]');
  parent_td.append(currentLabel);
  currentLabel.css('left', '50%');
  currentLabel.css('width', w * 100 + '%');
  currentLabel.css('z-index', 100);
  currentLabel.attr('data-index', labelIndex);
  busytd[labelIndex] = [];
  i = parent_td.index();
  while (i < parent_td.index() + w) {
    busytd[labelIndex].push([y, i]);
    i++;
  }
  labelIndex++;
  return currentLabel;
};

api.edit = function(id) {
  var currentLabel;
  currentLabel = $('.label-td[data-index=' + id + ']');
  return edit_label();
};

api.call_edit = function(id) {
  return console.log('Demo:', id);
};

api.update = function(id, data) {
  var currentLabel;
  currentLabel = $('.label-td[data-index=' + id + ']');
  currentLabel.children('.text').text(data.name);
  currentLabel.attr('class', 'label label-primary label-td');
  currentLabel.addClass('label-td-' + data.status);
  if (data.earlyin) {
    currentLabel.addClass('earlyin');
  } else {
    currentLabel.removeClass('earlyin');
  }
  if (data.laterout) {
    return currentLabel.addClass('laterout');
  } else {
    return currentLabel.removeClass('laterout');
  }
};

api.call_create = function(y, checkin, checkout) {
  return console.log('Demo:', y, checkin, checkout);
};

api.remove = function(id) {
  var currentLabel;
  currentLabel = $('.label-td[data-index=' + id + ']');
  currentLabel.remove();
  return busytd[currentLabel.data('index')] = [];
};

api.move = function() {
  return api.call_move(currentLabel.data('index'), level_index());
};

api.call_move = function(id, y) {
  return console.log('Demo: {ID' + id + ', Y:' + y + '}');
};

api.confirm_move = function(id, y) {
  return confirm('Переместить ' + id + '?');
};

api.generate = function(start, end, offset) {
  var centering, dayInMonth, dayOfWeek, day_count, en, end_d, end_date, end_m, end_y, month_count, st, start_d, start_date, start_m, start_y, td, v, variants;
  $('#schedule').css('left', 0);
  $('#schedule thead tr, #schedule tbody').html('');
  st = start.split('-');
  en = end.split('-');
  start_date = new Date(st[0], st[1], st[2]);
  end_date = new Date(en[0], en[1], en[2]);
  variants = $('#variants tbody tr').length;
  v = 0;
  while (v < variants) {
    $('#schedule tbody').append('<tr></tr>');
    v++;
  }
  start_y = parseInt(st[0]);
  start_m = parseInt(st[1]);
  end_y = parseInt(en[0]);
  end_m = parseInt(en[1]);
  start_d = parseInt(st[2]);
  end_d = parseInt(en[2]);
  while (start_y <= end_y) {
    if (start_y === end_y) {
      month_count = end_m;
    } else {
      month_count = 12;
    }
    while (start_m <= month_count) {
      dayInMonth = new Date(start_y, start_m, 0).getDate();
      if (start_y === end_y && start_m === end_m) {
        day_count = end_d;
      } else {
        day_count = dayInMonth;
      }
      td = $('<th colspan="' + (day_count - start_d + 1) + '">' + month[start_m - 1] + '</th>');
      $('#schedule thead tr:first').append(td);
      while (start_d <= day_count) {
        dayOfWeek = new Date(start_y, start_m - 1, start_d).getDay();
        $('#schedule thead tr:last').append('<th>' + '<span class="dayOfWeek">' + weeks[dayOfWeek] + '</span> <span class="dayInMonth">' + start_d + '</span></th>');
        $('#schedule tbody tr').append('<td data-day="' + start_d + '" data-month="' + start_m + '" data-year="' + start_y + '"></td>');
        start_d++;
      }
      start_d = 1;
      start_m++;
    }
    start_m = 1;
    start_y++;
  }
  $('#schedule tbody td[data-day="' + currentDate.getDate() + '"][data-month="' + (currentDate.getMonth() + 1) + '"]').addClass('today');
  if ($('#schedule tbody td.today').length) {
    if (offset !== 'undefined') {
      if (offset === 'center') {
        centering = $('.limiter').width() / 2 - 30;
        $('#schedule').css('left', -$('#schedule tbody td.today').index() * 60 + centering);
      }
      if (parseInt(offset) % 1 === 0) {
        $('#schedule').css('left', -($('#schedule tbody td.today').index() - offset) * 60);
      }
    }
  }
  return api.call_generate();
};

api.call_generate = function() {
  return console.log('Calendar was generated');
};

var busytd, check_collision, create_label, currentDate, currentDay, currentLabel, currentYear, dbl, edit_label, first_index, labelDrag, labelIndex, labelTdLevel, labelTrLevel, label_width, last_index, level_index, monthMouse, monthMouseLeft, mouseElCurrent, mouseElFinish, mouseElStart, mouseIsDown, statuses, zerofill;

mouseIsDown = false;

mouseElStart = false;

mouseElFinish = false;

mouseElCurrent = false;

monthMouse = 0;

monthMouseLeft = 0;

currentLabel = false;

labelDrag = false;

labelTdLevel = false;

labelTrLevel = false;

labelIndex = 0;

statuses = ['green', 'blue', 'red', 'yellow'];

busytd = [];

currentDate = new Date();

currentYear = new Date(2015, 0, 1);

currentDay = Math.floor((currentDate.getTime() - currentYear.getTime()) / 1000 / 60 / 60 / 24);

monthMouseLeft = -currentDay * 60;

$('#schedule').css('left', monthMouseLeft);

zerofill = function(num, length) {
  if (length === void 0) {
    length = 2;
  }
  length -= num.toString().length;
  if (length > 0) {
    return new Array(length + (/\./.test(num) ? 2 : 1)).join('0') + num;
  }
  return num + '';
};

check_collision = function(currentLabelTr, currentLabelTd, allow_self) {
  var i, n;
  if (allow_self) {
    allow_self = true;
  } else {
    allow_self = false;
  }
  for (i in busytd) {
    for (n in busytd[i]) {
      if (!allow_self && currentLabel) {
        if (busytd[i][n][0] === currentLabelTr && busytd[i][n][1] === currentLabelTd && parseInt(i) !== parseInt(currentLabel.data('index'))) {
          return true;
        }
      } else {
        if (busytd[i][n][0] === currentLabelTr && busytd[i][n][1] === currentLabelTd) {
          return true;
        }
      }
    }
  }
  return false;
};


/*delete_poisition = ->
	for i of busytd
		if busytd[i][0] == currentLabelTr && busytd[i][1] == currentLabelTd
			busytd[i] = []
 */

$('#schedule tbody').on('mousedown', 'td', function(e) {
  var check_laterout, td_level, tr_level;
  if (e.which === 1) {
    tr_level = $(this).closest('tr').index();
    td_level = $(this).index();
    check_laterout = false;
    $('#schedule tbody tr:eq(' + tr_level + ') .label-td.laterout').each(function() {
      currentLabel = $(this);
      if (check_collision(tr_level, td_level - 1, 1)) {
        return check_laterout = true;
      }
    });
    if (check_laterout) {
      alert('В этом дне выезд будет позже');
      return false;
    }
    if (!check_collision(tr_level, td_level, 1)) {
      mouseIsDown = true;
      mouseElStart = $(this);
      currentLabel = $('<div class="label label-primary label-td"><span class="text">&nbsp;</span></div>');
      $(this).append(currentLabel);
      return currentLabel.css('left', '50%');
    } else {
      return currentLabel = null;
    }
  }
});

$('#schedule tbody').on('mouseup', 'td', function(e) {
  var checkin, checkout, i, td_level, tr_level;
  if (e.which === 1) {
    if (labelDrag) {
      tr_level = level_index();
      td_level = first_index();
      if (tr_level !== currentLabel.data('current-level')) {
        if (!api.confirm_move(currentLabel.data('index'), tr_level)) {
          tr_level = currentLabel.data('current-level');
        }
      }
      currentLabel.removeAttr('data-current-level');
      currentLabel.appendTo($('#schedule tbody tr:eq(' + tr_level + ') td:eq(' + td_level + ')'));

      /*			len = Math.floor(parseInt(currentLabel[0].style.width)/100)
      			i = 0
      			isCollision = false
      			while i<len
      				if check_collision(tr_level, labelTdLevel+i)
      					isCollision = true
      				i++
      
      			if !isCollision
      				currentLabel.appendTo($('#schedule tbody tr:eq('+tr_level+') td:eq('+td_level+')'))
       */
      busytd[currentLabel.data('index')] = [];
      i = first_index();
      while (i < last_index()) {
        busytd[currentLabel.data('index')].push([tr_level, i]);
        i++;
      }
      labelDrag = false;
      if (mouseElStart && mouseElStart.closest('tr').index() !== tr_level) {
        api.move();
      }
    } else if (mouseIsDown) {
      mouseElFinish = $(this);
      if (mouseElFinish && mouseElStart && currentLabel) {
        tr_level = level_index();
        currentLabel.css('z-index', 100);
        currentLabel.attr('data-index', labelIndex);
        labelIndex++;
        checkin = zerofill(mouseElStart.data('day')) + '.' + zerofill(mouseElStart.data('month')) + '.' + mouseElStart.data('year');
        checkout = zerofill(mouseElFinish.data('day')) + '.' + zerofill(mouseElFinish.data('month')) + '.' + mouseElFinish.data('year');
        api.call_create(tr_level, checkin, checkout);
        currentLabel.remove();
      }
    }
    return mouseIsDown = false;
  }
});

$('#schedule tbody').on('mousemove', 'td', function(e) {
  var i, isCollision, len, td_level, tr_level, width;
  if (mouseIsDown) {
    if (labelDrag) {
      tr_level = $(this).closest('tr').index();
      td_level = labelTdLevel;
      len = Math.floor(parseInt(currentLabel[0].style.width) / 100);
      i = 0;
      isCollision = false;
      while (i < len) {
        if (check_collision(tr_level, labelTdLevel + i)) {
          isCollision = true;
        }
        i++;
      }
      if ($('#schedule tbody tr:eq(' + tr_level + ') td:eq(' + (last_index()) + ') .label-td.earlyin').length) {
        isCollision = true;
      }
      if (!isCollision) {
        return currentLabel.appendTo($('#schedule tbody tr:eq(' + tr_level + ') td:eq(' + td_level + ')'));
      }
    } else {
      mouseElCurrent = $(this);
      isCollision = false;
      tr_level = currentLabel.closest('tr').index();
      len = Math.floor(parseInt(currentLabel[0].style.width) / 100);
      i = 0;
      isCollision = false;
      while (i < len) {
        i++;
        if (check_collision(tr_level, first_index() + i, 1)) {
          isCollision = true;
        }
      }
      if ($('#schedule tbody tr:eq(' + tr_level + ') td:eq(' + (first_index() + len + 1) + ') .label-td.earlyin').length) {
        isCollision = true;
      }
      if ($(this).index() < first_index() + len) {
        isCollision = false;
      }
      if (!isCollision) {
        width = (mouseElCurrent.index() - mouseElStart.index()) * 100;
        return currentLabel.css('width', width + '%');
      }
    }
  }
});

dbl = 0;

$('#schedule tbody').on('mousedown', '.label-td', function(e) {
  setTimeout((function() {
    return dbl = 0;
  }), 700);
  dbl++;
  e.stopPropagation();
  if (dbl > 1) {
    dbl = 0;
    api.call_edit(currentLabel.data('index'));
    return mouseIsDown = false;
  } else {
    labelDrag = true;
    if (e.which === 1) {
      mouseIsDown = true;
      mouseElStart = $(this).parent();
      currentLabel = $(this);
      labelTdLevel = $(this).closest('td').index();
      labelTrLevel = $(this).closest('tr').index();
      return currentLabel.attr('data-current-level', labelTrLevel);
    }
  }
});

$('#schedule tbody').on('dblclick', '.label-td', function(e) {
  if (e.which === 1) {
    currentLabel = $(this);
    return mouseIsDown = false;
  }
});

first_index = function() {
  return currentLabel.parent().index();
};

last_index = function() {
  return currentLabel.parent().index() + (parseInt(currentLabel[0].style.width) / 100);
};

level_index = function() {
  return currentLabel.closest('tr').index();
};

label_width = function() {
  return parseInt(currentLabel[0].style.width) / 100;
};

edit_label = function() {
  var i, results;
  $('#schedule_form').modal('show');
  $('#schedule_form').addClass('edit');
  $('#schedule_form #input-name').val(currentLabel.children('.text').text());
  $('#input-earlyin').prop('checked', currentLabel.hasClass('earlyin'));
  $('#input-laterout').prop('checked', currentLabel.hasClass('laterout'));
  i = 0;
  results = [];
  while (i < statuses.length) {
    if (currentLabel.hasClass('label-td-' + statuses[i])) {
      $('#input-status').val('label-td-' + statuses[i]);
    }
    results.push(i++);
  }
  return results;
};

create_label = function() {
  $('#schedule_form').modal('show');
  $('#schedule_form').addClass('create');
  $('#schedule_form input').val('');
  $('#input-earlyin').prop('checked', false);
  return $('#input-laterout').prop('checked', false);
};

$('#input-earlyin').click(function() {
  if (check_collision(currentLabel.closest('tr').index(), first_index() - 1, 1)) {
    alert('Ранний заезд невозможен!');
    return $(this).prop('checked', false);
  }
});

$('#input-laterout').click(function() {
  if (check_collision(currentLabel.closest('tr').index(), last_index() + 1, 1)) {
    alert('Поздний выезд невозможен!');
    return $(this).prop('checked', false);
  }
});

$('#schedule thead').on('mousedown', 'th', function(e) {
  monthMouse = e.pageX;
  return monthMouseLeft = parseInt($('#schedule').css('left'));
});

$('#schedule thead').mousemove(function(e) {
  var left, max_left, min_left;
  if (monthMouse) {
    left = e.pageX - monthMouse + monthMouseLeft;
    min_left = 0;
    if (left > min_left) {
      left = min_left;
    }
    max_left = -$('#schedule').width() + $('.limiter').width();
    if (left < max_left) {
      left = max_left;
    }
    return $('#schedule').css({
      'left': left
    });
  }
});

$('#schedule').on('mouseup', 'thead', function() {
  return monthMouse = 0;
});

$('#schedule').on('mouseleave', 'thead', function() {
  return monthMouse = 0;
});

$(document).on('mouseup', 'body', function() {
  if (mouseIsDown) {
    mouseIsDown = false;
    busytd[currentLabel.data('index')] = [];
    return currentLabel.remove();
  }
});

$('html').mouseleave(function() {
  mouseIsDown = false;
  busytd[currentLabel.data('index')] = [];
  return currentLabel.remove();
});


/*$('#schedule_form form').submit ->

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

$(document).keyup (e) ->
	if e.keyCode == 27
		$('#schedule_form .action_cancel').click()
 */

$('#schedule_form .modal-dialog').click(function(e) {
  return e.stopPropagation();
});

var month, weeks;

month = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'];

weeks = ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];


/*
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
 */
