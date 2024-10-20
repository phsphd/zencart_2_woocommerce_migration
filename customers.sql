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
