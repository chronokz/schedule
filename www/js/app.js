var busytd, check_collision, currentDate, currentDay, currentLabel, currentYear, dbl, labelDrag, labelIndex, labelTdLevel, labelTrLevel, monthMouse, monthMouseLeft, mouseElCurrent, mouseElFinish, mouseElStart, mouseIsDown;

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

busytd = [];

currentDate = new Date();

currentYear = new Date(2015, 0, 1);

currentDay = Math.floor((currentDate.getTime() - currentYear.getTime()) / 1000 / 60 / 60 / 24);

monthMouseLeft = -currentDay * 35;

$('#schedule').css('left', monthMouseLeft);

check_collision = function(currentLabelTr, currentLabelTd) {
  var i, n;
  for (i in busytd) {
    for (n in busytd[i]) {
      if (busytd[i][n][0] === currentLabelTr && busytd[i][n][1] === currentLabelTd && parseInt(i) !== parseInt(currentLabel.data('index'))) {
        return true;
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
  var range, td_level, tr_level;
  if (e.which === 1) {
    currentLabel = $('<div class="label label-primary label-td">&nbsp;</div>');
    td_level = $(this).index();
    tr_level = $(this).closest('tr').index();
    if (!check_collision(tr_level, td_level)) {
      mouseIsDown = true;
      mouseElStart = $(this);
      $(this).append(currentLabel);
      range = $(this).width() / 2 - e.offsetX;
      if (range > 0) {
        return currentLabel.css('left', '25%');
      } else {
        return currentLabel.css('left', '75%');
      }
    } else {
      return currentLabel = null;
    }
  }
});

$('#schedule tbody').on('mouseup', 'td', function(e) {
  var i, left, range, td_level, tr_level, width;
  if (e.which === 1) {
    mouseIsDown = false;
    if (labelDrag) {
      tr_level = $(this).closest('tr').index();
      td_level = labelTdLevel;
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
      i = mouseElStart.index();
      while (i < mouseElFinish.index()) {
        busytd[currentLabel.data('index')].push([tr_level, i]);
        i++;
      }
      return labelDrag = false;
    } else {
      mouseElFinish = $(this);
      if (mouseElFinish && mouseElStart && currentLabel) {
        tr_level = $(this).closest('tr').index();
        width = (mouseElFinish.index() - mouseElStart.index()) * 100;
        currentLabel.css('width', width + '%');
        currentLabel.css('z-index', 100);
        left = currentLabel[0].style.left;
        range = $(this).width() / 2 - e.offsetX;
        if (range > 0) {
          if (left === '25%') {
            width -= 0;
          } else {
            width -= 50;
          }
        } else {
          if (left === '25%') {
            width += 25;
          } else {
            width -= 25;
          }
        }
        currentLabel.css('width', width + '%');
        $('#schedule_form').modal('show');
        $('#schedule_form').addClass('create');
        $('#schedule_form input').val('');
        busytd[labelIndex] = [];
        i = mouseElStart.index();
        while (i < mouseElFinish.index()) {
          busytd[labelIndex].push([tr_level, i]);
          i++;
        }
        currentLabel.attr('data-index', labelIndex);
        return labelIndex++;
      }
    }
  }
});

$('#schedule tbody').on('mousemove', 'td', function(e) {
  var i, isCollision, left, len, range, td_level, tr_level, width;
  if (mouseIsDown) {
    console.log(labelDrag);
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
      if (!isCollision) {
        return currentLabel.appendTo($('#schedule tbody tr:eq(' + tr_level + ') td:eq(' + td_level + ')'));
      }
    } else {
      mouseElCurrent = $(this);
      tr_level = $(this).closest('tr').index();
      i = currentLabel.parent().index();
      isCollision = false;
      while (i < $(this).index()) {
        i++;
        if (check_collision(tr_level, $(this).index())) {
          isCollision = true;
        }
      }
      if (!isCollision) {
        width = (mouseElCurrent.index() - mouseElStart.index()) * 100;
        left = currentLabel[0].style.left;
        range = $(this).width() / 2 - e.offsetX;
        if (range > 0) {
          if (left === '25%') {
            width -= 0;
          } else {
            width -= 50;
          }
        } else {
          if (left === '25%') {
            width += 25;
          } else {
            width -= 25;
          }
        }
        return currentLabel.css('width', width + '%');
      }
    }
  }
});

dbl = 0;

setInterval((function() {
  dbl = 0;
}), 500);

$('#schedule tbody').on('mousedown', '.label-td', function(e) {
  console.log('mousedown');
  dbl++;
  if (dbl > 1) {
    return $(this).dblclick();
  } else {
    if (e.which === 1) {
      labelDrag = true;
      mouseIsDown = true;
      e.stopPropagation();
      currentLabel = $(this);
      return labelTdLevel = $(this).closest('td').index();
    }
  }
});

$('#schedule tbody').on('dblclick', '.label-td', function(e) {
  if (e.which === 1) {
    currentLabel = $(this);
    $('#schedule_form').modal('show');
    $('#schedule_form').addClass('edit');
    return $('#schedule_form #input-name').val($(this).text());
  }
});

$('#schedule thead').on('mousedown', 'th', function(e) {
  monthMouse = e.pageX;
  return monthMouseLeft = parseInt($('#schedule').css('left'));
});

$('#schedule thead').mousemove(function(e) {
  if (monthMouse) {
    return $('#schedule').css({
      'left': e.pageX - monthMouse + monthMouseLeft
    });
  }
});

$('#schedule thead').on('mouseup', 'th', function(e) {
  return monthMouse = 0;
});

$('#schedule thead').on('mouseout', 'th', function(e) {
  return monthMouse = 0;
});

$('#schedule_form form').submit(function() {
  var newLeft, newWidth;
  $('#schedule_form').modal('hide');
  currentLabel.text($(this).find('#input-name').val());
  currentLabel.attr('class', 'label label-primary label-td');
  currentLabel.addClass('label-td-' + $(this).find('#input-status').val());
  if ($('#input-earlyin').prop('checked')) {
    newLeft = parseInt(currentLabel[0].style.left) + 25;
    newWidth = parseInt(currentLabel[0].style.width) - 25;
    currentLabel.css('left', newLeft + '%');
    currentLabel.css('width', newWidth + '%');
  }
  if ($('#input-laterout').prop('checked')) {
    newWidth = parseInt(currentLabel[0].style.width) + 25;
    currentLabel.css('width', newWidth + '%');
  }
  $('#schedule_form').removeClass('create').removeClass('edit');
  return false;
});

$('#schedule_form form .action_cancel').click(function() {
  $('#schedule_form').modal('hide');
  if ($('#schedule_form').hasClass('create')) {
    currentLabel.remove();
    busytd[currentLabel.data('index')] = [];
  }
  return $('#schedule_form').removeClass('create').removeClass('edit');
});

$('#schedule_form form .action_remove').click(function() {
  $('#schedule_form').modal('hide');
  $('#schedule_form').removeClass('create').removeClass('edit');
  currentLabel.remove();
  return busytd[currentLabel.data('index')] = [];
});

var d, date, dayInMonth, dayOfWeek, m, month, td, v, variants, weeks, y, yd;

month = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'];

weeks = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

date = new Date(Date.parse('January 1, 2015'));

y = 2015;

m = 0;

variants = $('#variants tbody tr').length;

v = 0;

while (v < variants) {
  $('#schedule tbody').append('<tr></tr>');
  v++;
}

yd = 0;

while (m < 12) {
  dayInMonth = new Date(y, m, 0).getDate();
  td = $('<th colspan="' + dayInMonth + '">' + month[m] + '</th>');
  $('#schedule thead tr:first').append(td);
  d = 0;
  m++;
  while (d < dayInMonth) {
    d++;
    yd++;
    dayOfWeek = new Date(y, m, d).getDay();
    $('#schedule thead tr:last').append('<th>' + '<span class="dayOfWeek">' + weeks[dayOfWeek] + '</span> <span class="dayInMonth">' + d + '</span></th>');
    $('#schedule tbody tr').append('<td data-day="' + d + '" data-month="' + m + '"></td>');
  }
}

$('#schedule tbody td[data-day="' + currentDate.getDate() + '"][data-month="' + (currentDate.getMonth() + 1) + '"]').css('background', '#f69c55');
