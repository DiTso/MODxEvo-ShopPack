/**
* NotiferNewUser
* 
* Уведомление о новой регистрации на сайте.
*
* @category     plugin
* @version      0.2
* @license      http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
* @internal     @properties &toEmail=Почта получателя;text; &subject=Тема письма;text;
* @internal     @events OnWebSaveUser
* @internal     @modx_category Manager and Admin
* @author Akool, edited by Serg28 (tsv.art.com@gmail.com) 
*/

$notifyTpl = '
<p>Новая регистрация на сайте [+site_name+].</p>
<p>Зарегистрирован новый пользователь<br /><br /> Имя: [+userfullname+]<br />Логин: [+username+]<br />Пароль: [+userpassword+]<br />Почта: [+useremail+]';

$toEmail = isset($toEmail) ? $toEmail : $modx->config['emailsender']; // получаетль уведомления
$subject = isset($subject) ? $subject : 'Новая регистрация на сайте'; // тема письма


if ($modx->Event->name == 'OnWebSaveUser') {
	
  //блокируем пользователя
  //$fields = array('blocked'=>'1');
  //$result = $modx->db->update( $fields, $modx->getFullTableName("web_user_attributes"), 'internalKey = "' . $userid . '"' ); 
	
  $userfullname = isset($userfullname) ? $userfullname : $modx->db->escape($modx->stripTags($_POST['fullname']));
  $userpassword = isset($userpassword) ? $userpassword : $modx->db->escape($modx->stripTags($_POST['password']));
  $username = isset($username) ? $username : $modx->db->escape($modx->stripTags($_POST['username']));
  $uemail = isset($useremail) ? $useremail : ($_POST['email'] != '' ? $modx->db->escape($modx->stripTags($_POST['email'])) : '');

  if ($mode != 'new' || $uemail == '' || !filter_var($uemail, FILTER_VALIDATE_EMAIL)) return;
  
  $notification = str_replace('[+useremail+]', $uemail, $notifyTpl);
  $notification = str_replace('[+site_name+]', $modx->config['site_name'], $notification);
  $notification = str_replace('[+username+]', $username, $notification);
  $notification = str_replace('[+userfullname+]', $userfullname, $notification);
  $notification = str_replace('[+userpassword+]', $userpassword, $notification);
	
  $params = array(
            'from'     => $modx->config['emailsender'],
            'fromname' => $modx->config['site_name'],
            'type'     => ($isHTML !== FALSE) ? '' : 'text',
            'subject'  => $subject,
            'to'       => $toEmail,
        );
        if (!$sss = $modx->sendmail($params, $notification)) {
			$modx->logEvent(89, 1, 'Не удалось отправить письмо на адрес '.$toEmail.' о новом пользователе.', 'NotiferNewUser');
      return;
		}	
}
