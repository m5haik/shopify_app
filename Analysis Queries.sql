
--- Number of Apps by Category
select 
	distinct c.title as category,
	count(a.id) over (partition by c.title) as Number_of_Apps,
	round(100.0 * count(a.id) over (partition by c.title) / count(a.id) over(), 2) as category_pct_share
from 
	apps a
join
	apps_categories ac on a.id = ac.app_id
join
	categories c on c.id = ac.category_id
order by
	2 desc
;

-- Category and Paid Apps
select 
	c.title,
	count(distinct case when p.price = 'Free' then a.id End) as Free_Apps,
	count(distinct case when p.price != 'Free' then a.id End) as Paid_Apps,
	round(100.0 * count(distinct case when p.price != 'Free' then a.id End) / count(distinct a.id), 2) as Paid_Share_Pct
from 
	apps a
join
	apps_categories ac on a.id = ac.app_id
join
	categories c on c.id = ac.category_id
join
	pricing_plans p on p.app_id = a.id
group by
	1
;

-- Category and Reviews
select 
	c.title,
	sum(reviews_count) as Total_Reviews,
	sum(reviews_count) / count(distinct a.id) as Reviews_per_App
from 
	apps a
join
	apps_categories ac on a.id = ac.app_id
join
	categories c on c.id = ac.category_id
group by
	1
order by
	3 desc
;


-- Reviews Distribution (reviews with 3 or less are more skewed towards higher rating than the rest)
select 
	distinct reviews_count, rating,
	count(a.id) over (partition by reviews_count, rating) as Number_of_Apps,
	round(100.0 * count(a.id) over (partition by reviews_count, rating) / count(a.id) over (partition by reviews_count), 2) as Percentage
from
	apps a
order by
	1, 2 desc
;

-- with app categories
select 
	distinct c.title as category, reviews_count, rating,
	count(a.id) over (partition by c.title, reviews_count, rating) as Number_of_Apps,
	round(100.0 * count(a.id) over (partition by c.title, reviews_count, rating) / count(a.id) over (partition by c.title), 2) as Percentage
from
	apps a
join
	apps_categories ac on a.id = ac.app_id
join
	categories c on c.id = ac.category_id
order by
	1, 3, 4 desc
;

-- Rating Distribution of Top Categories

select
	distinct category, rating_category,
	count(app_id) over (partition by category, rating_category) as Number_of_Apps,
	round(100.0 * count(app_id) over (partition by category, rating_category) / count(app_id) over (partition by category), 2) as Pct_in_Category
from
(
select 
	c.title as category, a.id as app_id, a.title as app_title, rating,
	CASE
	when rating >= 4.5 then 'Rating 4.5 - 5'
	when rating >= 4.0 and rating < 4.5 then 'Rating 4.0 - 4.4'
	when rating >= 4.0 and rating < 4.5 then 'Rating 4.0 - 4.4'
	when rating >= 3.0 and rating < 4.0 then 'Rating 3.0 - 3.9'
	when rating >= 2.0 and rating < 3.0 then 'Rating 2.0 - 2.9'
	when rating >= 1.0 and rating < 2.0 then 'Rating 1.0 - 1.9'
	else 'Rating < 1.0'
	END as rating_category
from 
	apps a
join
	apps_categories ac on a.id = ac.app_id
join
	categories c on c.id = ac.category_id
where
	c.title in ('Store design', 'Sales and conversion optimization', 'Marketing', 'Orders and shipping') -- top categories
) temp
order by
	1, 2 desc
;

-- Rating Distribution of Top Categories (with more than 3 reviews)
select
	distinct category, rating_category,
	count(app_id) over (partition by category, rating_category) as Number_of_Apps,
	round(100.0 * count(app_id) over (partition by category, rating_category) / count(app_id) over (partition by category), 2) as Pct_in_Category
from
(
select 
	c.title as category, a.id as app_id, a.title as app_title, rating,
	CASE
	when rating >= 4.5 then 'Rating 4.5 - 5'
	when rating >= 4.0 and rating < 4.5 then 'Rating 4.0 - 4.4'
	when rating >= 4.0 and rating < 4.5 then 'Rating 4.0 - 4.4'
	when rating >= 3.0 and rating < 4.0 then 'Rating 3.0 - 3.9'
	when rating >= 2.0 and rating < 3.0 then 'Rating 2.0 - 2.9'
	when rating >= 1.0 and rating < 2.0 then 'Rating 1.0 - 1.9'
	else 'Rating < 1.0'
	END as rating_category
from 
	apps a
join
	apps_categories ac on a.id = ac.app_id
join
	categories c on c.id = ac.category_id
where
	reviews_count > 3
and
	c.title in ('Store design', 'Sales and conversion optimization', 'Marketing', 'Orders and shipping') -- top categories
) temp
order by
	1, 2 desc
;

-- Top players in orders and shipping
select
	a.title, developer, reviews_count, rating, round(reviews_count * rating) as popularity
from 
	apps a
join
	apps_categories ac on a.id = ac.app_id
join
	categories c on c.id = ac.category_id
where
	c.title = 'Orders and shipping'
order by
	5 desc
limit 15
;

-- Pricing Plans (Free Trials and Tiered Pricing are popular)
select
	a.title, developer, reviews_count, rating, round(reviews_count * rating) as popularity,
	a.pricing_hint, p.title as pricing_title, p.price
from 
	apps a
join
	apps_categories ac on a.id = ac.app_id
join
	categories c on c.id = ac.category_id
join
	pricing_plans p on p.app_id = a.id
where
	c.title = 'Orders and shipping'
order by
	5 desc
;

-- Reviews Dataset for Orders and Shipping category
select 
	a.id as app_id, a.rating as app_rating, a.title as app_title, a.developer as app_developer,
	a.reviews_count, a.description, c.title as category, author, r.rating as review_rating, r.body as comment,
	r.helpful_count
from 
	apps a
join
	apps_categories ac on a.id = ac.app_id
join
	categories c on c.id = ac.category_id
join
	reviews r on a.id = r.app_id
where
	c.title = 'Orders and shipping'
;

-- Reviews Distribution of Orders and Shipping
select 
	distinct r.rating as review_rating, 
	count(a.id) over (partition by r.rating) as count,
	round(100.0 * count(a.id) over (partition by r.rating) / count(a.id) over (), 2) as pct
from 
	apps a
join
	apps_categories ac on a.id = ac.app_id
join
	categories c on c.id = ac.category_id
join
	reviews r on a.id = r.app_id
where
	c.title = 'Orders and shipping'
order by 
	1
;

