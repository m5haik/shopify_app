create table apps_categories (
	app_id varchar(255),
	category_id varchar(255)
	);
	
COPY apps_categories FROM '/private/tmp/apps_categories.csv' DELIMITER ',' CSV HEADER;

create table apps (
	id varchar(255),
	url varchar(255),
	title varchar(100),
	developer varchar(100),
	developer_link varchar(100),
	icon varchar(500),
	rating real,
	reviews_count int,
	description_raw varchar(10000),
	description varchar(5000),
	tagline varchar(255),
	pricing_hint varchar(50),
	PRIMARY KEY (id)
	);
	
COPY apps FROM '/private/tmp/apps.csv' DELIMITER ',' CSV HEADER;

create table categories (
	id varchar(255),
	title varchar(255),
	PRIMARY KEY (id)
	);
	
COPY categories FROM '/private/tmp/categories.csv' DELIMITER ',' CSV HEADER;

create table key_benefits (
	app_id varchar(255),
	title varchar(255),
	description varchar(2500)
	);
	
COPY key_benefits FROM '/private/tmp/key_benefits.csv' DELIMITER ',' CSV HEADER;

create table pricing_plan_features (
	app_id varchar(255),
	pricing_plan_id varchar(255),
	feature varchar(1000)
	);
	
COPY pricing_plan_features FROM '/private/tmp/pricing_plan_features.csv' DELIMITER ',' CSV HEADER;

create table pricing_plans (
	id varchar(255),
	app_id varchar(255),
	title varchar(255),
	price varchar(255)
	);
	
COPY pricing_plans FROM '/private/tmp/pricing_plans.csv' DELIMITER ',' CSV HEADER;

create table reviews (
	app_id varchar(255),
	author varchar(500),
	rating int,
	posted_at varchar(25),
	body varchar(20000),
	helpful_count int,
	developer_reply varchar(10000),
	developer_reply_posted_at varchar(25)
	);
	
COPY reviews FROM '/private/tmp/reviews.csv' DELIMITER ',' CSV HEADER;
