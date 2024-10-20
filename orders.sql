-- Insert into wp_posts (WooCommerce orders)
INSERT INTO wp_posts (post_author, post_date, post_date_gmt, post_content, post_title, post_excerpt, post_status, comment_status, ping_status, post_name, post_modified, post_modified_gmt, post_type, to_ping, pinged, post_content_filtered)
SELECT 
    1,  -- Author ID (assuming admin)
    o.date_purchased,  -- Order date as post_date
    o.date_purchased,  -- Order date as post_date_gmt
    '',  -- Post content (empty for orders)
    CONCAT('Order #', o.orders_id),  -- Post title (Order #)
    '',  -- Post excerpt
    'wc-completed',  -- Post status (assuming completed orders)
    'closed',  -- Comment status
    'closed',  -- Ping status
    CONCAT('order-', o.orders_id),  -- Post slug
    IFNULL(o.last_modified, o.date_purchased),  -- Post modified
    IFNULL(o.last_modified, o.date_purchased),  -- Post modified GMT
    'shop_order',  -- Post type (WooCommerce order)
    '',  -- to_ping field, explicitly setting it as empty
    '',  -- pinged field, explicitly setting it as empty
    ''  -- post_content_filtered (empty)
FROM orders o;

-- Insert billing first name for all orders, but only if it doesn't already exist
INSERT INTO wp_postmeta (post_id, meta_key, meta_value)
SELECT 
    wp.ID, 
    '_billing_first_name', 
    c.customers_firstname
FROM 
    wp_posts wp
JOIN 
    orders o ON wp.ID = o.orders_id
JOIN 
    customers c ON o.customers_id = c.customers_id
WHERE 
    wp.post_type = 'shop_order'
    AND NOT EXISTS (
        SELECT 1 FROM wp_postmeta wpm 
        WHERE wpm.post_id = wp.ID AND wpm.meta_key = '_billing_first_name'
    );

-- Insert billing last name for all orders, but only if it doesn't already exist
INSERT INTO wp_postmeta (post_id, meta_key, meta_value)
SELECT 
    wp.ID, 
    '_billing_last_name', 
    c.customers_lastname
FROM 
    wp_posts wp
JOIN 
    orders o ON wp.ID = o.orders_id
JOIN 
    customers c ON o.customers_id = c.customers_id
WHERE 
    wp.post_type = 'shop_order'
    AND NOT EXISTS (
        SELECT 1 FROM wp_postmeta wpm 
        WHERE wpm.post_id = wp.ID AND wpm.meta_key = '_billing_last_name'
    );

-- Insert billing address for all orders, but only if it doesn't already exist
INSERT INTO wp_postmeta (post_id, meta_key, meta_value)
SELECT 
    wp.ID, 
    '_billing_address_1', 
    o.customers_street_address
FROM 
    wp_posts wp
JOIN 
    orders o ON wp.ID = o.orders_id
WHERE 
    wp.post_type = 'shop_order'
    AND NOT EXISTS (
        SELECT 1 FROM wp_postmeta wpm 
        WHERE wpm.post_id = wp.ID AND wpm.meta_key = '_billing_address_1'
    );

-- Insert billing city for all orders, but only if it doesn't already exist
INSERT INTO wp_postmeta (post_id, meta_key, meta_value)
SELECT 
    wp.ID, 
    '_billing_city', 
    o.customers_city
FROM 
    wp_posts wp
JOIN 
    orders o ON wp.ID = o.orders_id
WHERE 
    wp.post_type = 'shop_order'
    AND NOT EXISTS (
        SELECT 1 FROM wp_postmeta wpm 
        WHERE wpm.post_id = wp.ID AND wpm.meta_key = '_billing_city'
    );

-- Insert billing postcode for all orders, but only if it doesn't already exist
INSERT INTO wp_postmeta (post_id, meta_key, meta_value)
SELECT 
    wp.ID, 
    '_billing_postcode', 
    o.customers_postcode
FROM 
    wp_posts wp
JOIN 
    orders o ON wp.ID = o.orders_id
WHERE 
    wp.post_type = 'shop_order'
    AND NOT EXISTS (
        SELECT 1 FROM wp_postmeta wpm 
        WHERE wpm.post_id = wp.ID AND wpm.meta_key = '_billing_postcode'
    );

-- Insert billing country for all orders, but only if it doesn't already exist
INSERT INTO wp_postmeta (post_id, meta_key, meta_value)
SELECT 
    wp.ID, 
    '_billing_country', 
    o.customers_country
FROM 
    wp_posts wp
JOIN 
    orders o ON wp.ID = o.orders_id
WHERE 
    wp.post_type = 'shop_order'
    AND NOT EXISTS (
        SELECT 1 FROM wp_postmeta wpm 
        WHERE wpm.post_id = wp.ID AND wpm.meta_key = '_billing_country'
    );

-- Insert billing email for all orders, but only if it doesn't already exist
INSERT INTO wp_postmeta (post_id, meta_key, meta_value)
SELECT 
    wp.ID, 
    '_billing_email', 
    o.customers_email_address
FROM 
    wp_posts wp
JOIN 
    orders o ON wp.ID = o.orders_id
WHERE 
    wp.post_type = 'shop_order'
    AND NOT EXISTS (
        SELECT 1 FROM wp_postmeta wpm 
        WHERE wpm.post_id = wp.ID AND wpm.meta_key = '_billing_email'
    );

-- Insert billing phone for all orders, but only if it doesn't already exist
INSERT INTO wp_postmeta (post_id, meta_key, meta_value)
SELECT 
    wp.ID, 
    '_billing_phone', 
    o.customers_telephone
FROM 
    wp_posts wp
JOIN 
    orders o ON wp.ID = o.orders_id
WHERE 
    wp.post_type = 'shop_order'
    AND NOT EXISTS (
        SELECT 1 FROM wp_postmeta wpm 
        WHERE wpm.post_id = wp.ID AND wpm.meta_key = '_billing_phone'
    );
