function verif(evt) 
{
	var keyCode = evt.which ? evt.which : evt.keyCode;
	var accept = ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-éèàêâôîûù'; // @|&#28&#29\'€$£#&ç%-+<>&#5F\r\b
	if (accept.indexOf(String.fromCharCode(keyCode)) >= 0) {
		return true;
	} else {
		return false;
	}
}