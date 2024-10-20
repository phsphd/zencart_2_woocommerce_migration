INSERT INTO wp_users (
    user_login, 
    user_pass, 
    user_nicename, 
    user_email, 
    user_registered, 
    display_name
)
SELECT 
    c.customers_email_address AS user_login, 
    c.customers_password AS user_pass,  -- Assuming passwords need to be rehashed if stored as MD5 in ZenCart
    CONCAT(c.customers_firstname, '-', c.customers_lastname) AS user_nicename, 
    c.customers_email_address AS user_email, 
    c.customers_dob AS user_registered,  -- Date of birth used as the registration date
    CONCAT(c.customers_firstname, ' ', c.customers_lastname) AS display_name
FROM customers c;





INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
SELECT 
    u.ID, 
    'first_name', 
    c.customers_firstname
FROM wp_users u
JOIN customers c ON u.user_login = c.customers_email_address;

INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
SELECT 
    u.ID, 
    'last_name', 
    c.customers_lastname
FROM wp_users u
JOIN customers c ON u.user_login = c.customers_email_address;

INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
SELECT 
    u.ID, 
    'billing_phone', 
    c.customers_telephone
FROM wp_users u
JOIN customers c ON u.user_login = c.customers_email_address;


INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
SELECT 
    u.ID, 
    'billing_address_1', 
    ab.entry_street_address
FROM wp_users u
JOIN customers c ON u.user_login = c.customers_email_address
JOIN address_book ab ON c.customers_id = ab.customers_id;

INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
SELECT 
    u.ID, 
    'billing_city', 
    ab.entry_city
FROM wp_users u
JOIN customers c ON u.user_login = c.customers_email_address
JOIN address_book ab ON c.customers_id = ab.customers_id;

INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
SELECT 
    u.ID, 
    'billing_postcode', 
    ab.entry_postcode
FROM wp_users u
JOIN customers c ON u.user_login = c.customers_email_address
JOIN address_book ab ON c.customers_id = ab.customers_id;

INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
SELECT 
    u.ID, 
    'billing_state', 
    ab.entry_state
FROM wp_users u
JOIN customers c ON u.user_login = c.customers_email_address
JOIN address_book ab ON c.customers_id = ab.customers_id;

INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
SELECT 
    u.ID, 
    'billing_country', 
    ab.entry_country_id  -- Replace this with country code mapping if needed
FROM wp_users u
JOIN customers c ON u.user_login = c.customers_email_address
JOIN address_book ab ON c.customers_id = ab.customers_id;

INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
SELECT 
    u.ID, 
    'last_login', 
    ci.customers_info_date_of_last_logon
FROM wp_users u
JOIN customers_info ci ON u.ID = ci.customers_info_id;

