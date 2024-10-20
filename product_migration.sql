delete FROM products WHERE products_status=0;

INSERT INTO wp_posts (
    post_author, 
    post_date, 
    post_date_gmt, 
    post_content,  -- Description
    post_title,  -- Product name
    post_excerpt,  -- Short description
    post_status,  -- Publish or draft
    comment_status, 
    ping_status, 
    post_name,  -- Slug
    post_modified,  -- Post last modified date
    post_modified_gmt,  -- Post last modified GMT
    post_type, 
    to_ping, 
    pinged, 
    post_content_filtered
)
SELECT 
    1,  -- Author ID
    p.products_date_added, 
    p.products_date_added, 
    COALESCE(pd.products_description, ''),  -- Ensure post_content is not NULL
    COALESCE(pd.products_name, 'Unnamed Product'),  -- Ensure post_title is not NULL
    '',  -- Short description (if available)
    CASE 
        WHEN p.products_status = 1 THEN 'publish'
        ELSE 'draft'
    END,  -- Publish status based on ZenCart's products_status
    'open',  -- Comment status
    'closed',  -- Ping status
    COALESCE(p.products_model, CONCAT('product-', p.products_id)),  -- Post slug, fallback to product ID if model is NULL
    COALESCE(p.products_last_modified, p.products_date_added),  -- Use products_date_added if products_last_modified is NULL
    COALESCE(p.products_last_modified, p.products_date_added),  -- Use products_date_added if products_last_modified is NULL (GMT version)
    'product',  -- Post type (WooCommerce product)
    '',  -- to_ping (Empty string as no pinging is needed for products)
    '',  -- pinged (Empty string)
    ''  -- post_content_filtered (Empty string as it's not relevant for products)
FROM products p
JOIN products_description pd ON p.products_id = pd.products_id
WHERE pd.language_id = 1;  -- Adjust for the desired language_id


INSERT INTO wp_postmeta (post_id, meta_key, meta_value)
SELECT wp.ID, '_regular_price', p.products_price
FROM wp_posts wp
JOIN products p ON wp.post_name = p.products_model
WHERE wp.post_type = 'product';

INSERT INTO wp_postmeta (post_id, meta_key, meta_value)
SELECT wp.ID, '_stock', p.products_quantity
FROM wp_posts wp
JOIN products p ON wp.post_name = p.products_model
WHERE wp.post_type = 'product';

-- Additional meta fields (e.g., weight, virtual status)
INSERT INTO wp_postmeta (post_id, meta_key, meta_value)
SELECT wp.ID, '_weight', p.products_weight
FROM wp_posts wp
JOIN products p ON wp.post_name = p.products_model
WHERE wp.post_type = 'product';

INSERT INTO wp_postmeta (post_id, meta_key, meta_value)
SELECT wp.ID, '_virtual', p.products_virtual
FROM wp_posts wp
JOIN products p ON wp.post_name = p.products_model
WHERE wp.post_type = 'product';


-- Insert Categories (Assumes you already have categories created)
INSERT INTO wp_term_relationships (object_id, term_taxonomy_id, term_order)
SELECT wp.ID, (SELECT term_taxonomy_id FROM wp_term_taxonomy WHERE term_id = p.categories_id AND taxonomy = 'product_cat'), 0
FROM wp_posts wp
JOIN products p ON wp.post_name = p.products_model
WHERE wp.post_type = 'product';


-- Insert product image (assuming you have migrated images and mapped them to the correct location)
INSERT INTO wp_posts (post_author, post_date, post_date_gmt, post_content, post_title, post_status, post_name, post_modified, post_modified_gmt, post_type, post_mime_type, guid)
SELECT 
    1,  -- Author ID
    NOW(), 
    NOW(), 
    '',  -- No content for images
    p.products_image,  -- Image file name
    'inherit',  -- Image status
    p.products_image,  -- Image slug
    NOW(), 
    NOW(), 
    'attachment',  -- Post type (attachment for images)
    'image/jpeg',  -- Mime type (adjust based on actual image type)
    CONCAT('http://yourstore.com/wp-content/uploads/', p.products_image)  -- Image URL
FROM products p
WHERE p.products_image IS NOT NULL;

-- Link the image to the product in wp_postmeta
INSERT INTO wp_postmeta (post_id, meta_key, meta_value)
SELECT wp.ID, '_thumbnail_id', (SELECT ID FROM wp_posts WHERE post_name = p.products_image AND post_type = 'attachment')
FROM wp_posts wp
JOIN products p ON wp.post_name = p.products_model
WHERE wp.post_type = 'product';
