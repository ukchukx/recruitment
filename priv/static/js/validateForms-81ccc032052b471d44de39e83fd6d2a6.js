function validateSignupForm() {
	var password = document.getElementById('signup-password').value;

	if (password.length < 6) {
		document.getElementById('signup-password-error').innerHTML = 'Password must have at least 6 characters.';
		return false;
	}

	return true;
}


function validateLoginForm() {	
	return true;
}