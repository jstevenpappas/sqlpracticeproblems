create schema public;

comment on schema public is 'standard public schema';

alter schema public owner to sunyata;

create sequence cateries_seq;

alter sequence cateries_seq owner to sunyata;

create table categories
(
	categoryid bigint not null
		constraint categories_pkey
			primary key,
	categoryname varchar(15) not null,
	description varchar(100)
);

alter table categories owner to sunyata;

create table customergroupthresholds
(
	customergroupname varchar(15) not null,
	rangebottom bigint,
	rangetop bigint
);

alter table customergroupthresholds owner to sunyata;

create table customers
(
	customerid varchar(5) not null
		constraint customers_pkey
			primary key,
	companyname varchar(40) not null,
	contactname varchar(30),
	contacttitle varchar(30) not null,
	address varchar(60),
	city varchar(15) not null,
	region varchar(15),
	postalcode varchar(10) not null,
	country varchar(15),
	phone varchar(24) not null,
	fax varchar(24)
);

alter table customers owner to sunyata;

create table employees
(
	employeeid bigint not null
		constraint employees_pkey
			primary key,
	lastname varchar(20) not null,
	firstname varchar(10) not null,
	title varchar(30) not null,
	birthdate date
		constraint ck_birthdate
			check (birthdate < now()),
	hiredate date,
	address varchar(60),
	city varchar(15),
	region varchar(15),
	postalcode varchar(10),
	country varchar(15),
	homephone varchar(24),
	extension varchar(4),
	notes varchar(1000),
	reportsto bigint
		constraint employees_reportsto_fkey
			references employees,
	photopath varchar(255),
	titleofcourtesy varchar default 25
);

alter table employees owner to sunyata;

create table shippers
(
	shipperid bigint not null
		constraint shippers_pkey
			primary key,
	companyname varchar(40) not null,
	phone varchar(24)
);

alter table shippers owner to sunyata;

create table orders
(
	orderid bigint not null
		constraint orders_pkey
			primary key,
	employeeid bigint not null
		constraint orders_employeeid_fkey
			references employees,
	customerid varchar(5) not null
		constraint orders_customerid_fkey
			references customers,
	orderdate date,
	requireddate date,
	shippeddate date,
	shipvia bigint
		constraint orders_shipvia_fkey
			references shippers,
	freight bigint default 0,
	shipname varchar(60),
	shipaddress varchar(60),
	shipcity varchar(15),
	shipregion varchar(15),
	shippostalcode varchar(10),
	shipcountry varchar(15)
);

alter table orders owner to sunyata;

create table suppliers
(
	supplierid bigint not null
		constraint suppliers_pkey
			primary key,
	companyname varchar(60),
	contactname varchar(60),
	contacttitle varchar(30),
	address varchar(60),
	city varchar(15),
	region varchar(15),
	postalcode varchar(10),
	country varchar(15),
	phone varchar(24),
	fax varchar(24),
	homepage varchar(256)
);

alter table suppliers owner to sunyata;

create table products
(
	productid bigint not null
		constraint products_pkey
			primary key,
	productname varchar(40) not null,
	supplierid bigint not null
		constraint products_supplierid_fkey
			references suppliers,
	categoryid bigint not null
		constraint products_categoryid_fkey
			references categories,
	quantityperunit varchar(40),
	unitprice bigint default 0
		constraint ck_products_unitprice
			check (unitprice >= 0),
	unitsinstock bigint default 0
		constraint ck_unitsinstock
			check (unitsinstock >= 0),
	unitsonorder bigint default 0
		constraint ck_unitsonorder
			check (unitsonorder >= 0),
	reorderlevel bigint default 0
		constraint ck_reorderlevel
			check (reorderlevel >= 0),
	discontinued char default 0 not null
);

alter table products owner to sunyata;

create table orderdetails
(
	orderid bigint not null
		constraint orderdetails_orderid_fkey
			references orders,
	productid bigint not null
		constraint orderdetails_productid_fkey
			references products,
	unitprice bigint default 0 not null
		constraint ck_unitprice
			check (unitprice >= 0),
	quantity bigint default 1 not null
		constraint ck_quantity
			check (quantity > 0),
	discount bigint default 0 not null
		constraint ck_discount
			check ((discount >= 0) AND (discount <= 1)),
	constraint orderdetails_pkey
		primary key (orderid, productid)
);

alter table orderdetails owner to sunyata;

create table cateries
(
	cateryid integer default nextval('cateries_seq'::regclass) not null
		constraint pk_cateries
			primary key,
	cateryname varchar(15) not null,
	description text
);

alter table cateries owner to sunyata;
