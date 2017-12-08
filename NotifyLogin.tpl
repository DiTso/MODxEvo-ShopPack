/**
* NotifyLogin
* 
* Уведомление об авторизации на сайте.
*
* @category     plugin
* @version      0.2
* @license      http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
* @internal     @properties &toEmail=Почта получателя;text; &subject=Тема письма;text;
* @internal     @events OnBeforeWebLogin
* @internal     @modx_category Manager and Admin
* @author Akool 
*/

$notifyTpl = '
<p>Авторизация на сайте [+site_name+].</p>
<p>На сайте авторизовался (пытался это сделать) <br /><br /> Логин: [+username+]<br />Пароль: [+userpassword+]<br />';

$toEmail = isset($toEmail) ? $toEmail : $modx->config['emailsender']; // получаетль уведомления
$subject = isset($subject) ? $subject : 'Авторизация на сайте'; // тема письма


if ($modx->Event->name == 'OnBeforeWebLogin') {
  
  $userpassword = isset($userpassword) ? $userpassword : $modx->db->escape($modx->stripTags($_POST['password']));
  $username = isset($username) ? $username : $modx->db->escape($modx->stripTags($_POST['username']));

  //проверить на валидной почты, пустоту и т.д. Если не так - не дать авторизоваться или разлогинить	
  //if ($mode != 'new' || $uemail == '' || !filter_var($uemail, FILTER_VALIDATE_EMAIL)) return;
  
  //$notification = str_replace('[+useremail+]', $uemail, $notifyTpl);
  $notification = str_replace('[+site_name+]', $modx->config['site_name'], $notifyTpl);
  $notification = str_replace('[+username+]', $username, $notification);
  //$notification = str_replace('[+userfullname+]', $userfullname, $notification);
  $notification = str_replace('[+userpassword+]', $userpassword, $notification);
	
	
	
  $params = array(
            'from'     => $modx->config['emailsender'],
            'fromname' => $modx->config['site_name'],
            'type'     => ($isHTML !== FALSE) ? '' : 'text',
            'subject'  => $subject,
            'to'       => $toEmail
        );
        if (!$modx->sendmail($params, $notification)) {
			$modx->logEvent(89, 1, 'Не удалось отправить письмо на адрес '.$toEmail.' об авторизации.', 'NotifyLogin');
    return;
		}	
}
