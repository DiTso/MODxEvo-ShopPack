<?php
/* Выводит примерную дату отправки заказа, исходя из того, что отправка происходит в рабочие дни до 20:00 включительно или до указанного в $do часа, напр., 14:00 */
if (empty($do)) {$do=20;}
if (empty($price)) {$price=200;}
$date_time_array = getdate( time() );
$day=$date_time_array['wday'];
$time = ($date_time_array['hours']+($modx->config['server_offset_time']/3600));
if ($day<=4 && $time>=$do) {$d= "Завтра"; $dd=getdate( time()+(24*3600) ); $next=$dd; }
if ($day<=5 && $time<$do) {$d= "Сегодня"; $dd=getdate( time()); $next=$dd;}
//if ($day==5 && $time>=$do) {$d= "В понедельник"; $dd=getdate( time()+(72*3600) ); $next=$dd;}
if ($day==5 && $time>=$do) {$d= "Завтра"; $dd=getdate( time()+(24*3600) ); $next=$dd;}
if ($day==6 && $time>=$do) {$d= "В понедельник"; $dd=getdate( time()+(48*3600) ); $next=$dd;}
if ($day==6 && $time<$do) {$d= "Сегодня"; $dd=getdate( time()); $next=$dd;}
if ($day==7 && $time>=$do) {$d= "В понедельник"; $dd=getdate( time()+(24*3600) ); $next=$dd;}

switch ($next['mon']) {
    case '01':
        $pubMonth = 'января';
        break;
    case '02':
        $pubMonth = 'февраля';
        break;
    case '03':
        $pubMonth = 'марта';
        break;
    case '04':
        $pubMonth = 'апреля';
        break;
    case '05':
        $pubMonth = 'мая';
        break;
    case '06':
        $pubMonth = 'июня';
        break;
    case '07':
        $pubMonth = 'июля';
        break;
    case '08':
        $pubMonth = 'августа';
        break;
    case '09':
        $pubMonth = 'сентября';
        break;
    case '10':
        $pubMonth = 'октября';
        break;
    case '11':
        $pubMonth = 'ноября';
        break;
    case '12':
        $pubMonth = 'декабря';
        break;
}

if (!empty($p)) {$ppp="Стоимость: <b>".$price." руб.</b>";}
return "<p>Отправка: <b>".$d.", ".$next['mday']." ".$pubMonth."</b><br />".$ppp.'</p>';
