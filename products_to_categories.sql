-- 1. Insert categories from ZenCart to WooCommerce wp_terms
INSERT INTO wp_terms (NAME, slug, term_group)
SELECT DISTINCT cd.categories_name, LOWER(REPLACE(cd.categories_name, ' ', '-')), 0
FROM categories_description cd
JOIN categories c ON c.categories_id = cd.categories_id
LEFT JOIN wp_terms wt ON wt.name = cd.categories_name
WHERE wt.term_id IS NULL;

-- 2. Insert categories into wp_term_taxonomy (associate with WooCommerce product categories)
INSERT INTO wp_term_taxonomy (term_id, taxonomy, DESCRIPTION, parent, COUNT)
SELECT wt.term_id, 'product_cat', '', c.parent_id, 0
FROM categories c
JOIN categories_description cd ON cd.categories_id = c.categories_id
JOIN wp_terms wt ON wt.name = cd.categories_name
LEFT JOIN wp_term_taxonomy wtt ON wtt.term_id = wt.term_id
WHERE wtt.term_id IS NULL;

-- 3. Establish relationships between products and categories in wp_term_relationships
INSERT INTO wp_term_relationships (object_id, term_taxonomy_id)
SELECT wp.ID, wtt.term_taxonomy_id
FROM wp_posts wp
JOIN products_to_categories ptc ON ptc.products_id = wp.ID
JOIN categories_description cd ON cd.categories_id = ptc.categories_id
JOIN wp_terms wt ON wt.name = cd.categories_name
JOIN wp_term_taxonomy wtt ON wtt.term_id = wt.term_id AND wtt.taxonomy = 'product_cat';

-- Find duplicate category names and their associated term_ids
SELECT name, MIN(term_id) as keep_term_id, GROUP_CONCAT(term_id) as duplicate_term_ids
FROM wp_terms
GROUP BY name
HAVING COUNT(*) > 1;
 UPDATE wp_term_relationships wtr
JOIN wp_term_taxonomy wtt ON wtr.term_taxonomy_id = wtt.term_taxonomy_id
JOIN (
    SELECT wt.name, MIN(wt.term_id) AS keep_term_id, GROUP_CONCAT(wt.term_id) AS duplicate_term_ids
    FROM wp_terms wt
    GROUP BY wt.name
    HAVING COUNT(*) > 1
) dup ON wtt.term_id = dup.keep_term_id
SET wtr.term_taxonomy_id = (
    SELECT wtt2.term_taxonomy_id
    FROM wp_term_taxonomy wtt2
    WHERE wtt2.term_id = dup.keep_term_id AND wtt2.taxonomy = 'product_cat'
)
WHERE FIND_IN_SET(wtt.term_id, dup.duplicate_term_ids);


DELETE wtt
FROM wp_term_taxonomy wtt
JOIN (
    SELECT wt.name, MIN(wt.term_id) AS keep_term_id, GROUP_CONCAT(wt.term_id) AS duplicate_term_ids
    FROM wp_terms wt
    GROUP BY wt.name
    HAVING COUNT(*) > 1
) dup ON FIND_IN_SET(wtt.term_id, dup.duplicate_term_ids)
WHERE wtt.term_id != dup.keep_term_id
AND wtt.taxonomy = 'product_cat';

-- Reassign duplicate term references in wp_term_taxonomy
UPDATE wp_term_taxonomy wtt
JOIN (
    SELECT wt.name, MIN(wt.term_id) AS keep_term_id, GROUP_CONCAT(wt.term_id) AS duplicate_term_ids
    FROM wp_terms wt
    GROUP BY wt.name
    HAVING COUNT(*) > 1
) dup ON FIND_IN_SET(wtt.term_id, dup.duplicate_term_ids)
SET wtt.term_id = dup.keep_term_id
WHERE FIND_IN_SET(wtt.term_id, dup.duplicate_term_ids);

