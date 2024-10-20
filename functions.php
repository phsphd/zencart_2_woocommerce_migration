add_filter('wp_check_password', 'check_legacy_md5_passwords', 10, 4);

function check_legacy_md5_passwords($check, $password, $hash, $user_id) {
    // If the current hash doesn't match the WordPress hash format
    if (strlen($hash) == 32) { // Check if it's MD5
        // Check if the MD5 password matches
        if (md5($password) === $hash) {
            // If it's a match, rehash the password using the WordPress hashing algorithm
            wp_set_password($password, $user_id);
            return true; // Successful login
        } else {
            return false; // Invalid MD5 password
        }
    }
    return $check; // Default WordPress password handling
}

/*
Hook into WordPress Login Process: You can use WordPress's wp_check_password filter to handle MD5 hashes during the login process.

Add Custom Code to Handle MD5 Passwords: Add the following code to your functions.php file of your WordPress theme, or create a small plugin.
This filter checks if the stored password hash is 32 characters long (indicating it’s MD5).
If it matches, it verifies the password using MD5 and, upon success, updates the stored password with the more secure WordPress bcrypt hashing.
The next time the user logs in, their password will be securely hashed using the WordPress method.
*/
