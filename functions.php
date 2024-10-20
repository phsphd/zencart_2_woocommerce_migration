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
