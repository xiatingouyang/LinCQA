with candidates as (
	select r_1.X1
	from r_1, r_2, r_3
	where r_1.Y1 = r_2.X2 and r_2.Y2 = r_3.X3
),

filter as (
	select r_1.X1
	from r_1
	left outer join r_2 on r_1.Y1 = r_2.X2
	left outer join r_3 on r_2.Y2 = r_3.X3
	where r_2.X2 is NULL or r_3.X3 is NULL
)

select distinct C.X1 
from candidates C
where not exists (
	select * from filter F where C.X1 = F.X1 
)
