-- Insert categories into wp_terms
INSERT INTO wp_terms (name, slug, term_group)
SELECT 
    c.categories_name, 
    LOWER(REPLACE(c.categories_name, ' ', '-')),  -- Slug
    0  -- term_group default is 0
FROM categories_description c
JOIN categories cat ON c.categories_id = cat.categories_id
WHERE c.language_id = 1;

-- Insert taxonomy for categories in wp_term_taxonomy, ignoring duplicates
INSERT IGNORE INTO wp_term_taxonomy (term_id, taxonomy, description, parent, count)
SELECT 
    t.term_id, 
    'product_cat',  -- WooCommerce product category taxonomy
    '',  -- Description is optional
    cat.parent_id, 
    0  -- Initial count set to 0
FROM wp_terms t
JOIN categories_description c ON t.name = c.categories_name
JOIN categories cat ON c.categories_id = cat.categories_id;


INSERT INTO wp_term_relationships (object_id, term_taxonomy_id, term_order)
SELECT 
    p.products_id,  -- WooCommerce product ID
    tt.term_taxonomy_id,  -- Attribute term taxonomy ID
    0  -- Term order
FROM products_attributes pa
JOIN wp_term_taxonomy tt ON pa.options_values_id = tt.term_id
JOIN products p ON pa.products_id = p.products_id;
