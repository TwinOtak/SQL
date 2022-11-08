select *
from actor

select	'abc' like 'abc' as "true or false",
		'abc' like 'a%' as "true or false",
		'abc' like '_b_' as "true or false",
		'abc' like 'c' as "true or false";

select	table_name, constraint_name
from	information_schema.table_constraints
where 	constraint_schema = 'public'
	and	constraint_type = 'PRIMARY KEY'