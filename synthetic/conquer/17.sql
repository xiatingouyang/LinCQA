WITH Candidates as (
select distinct R_1.A13 as R_1_3, R_1.A11 as R_1_1
from R_1, R_2, R_7
where (R_2.A22 = R_7.A71) and (R_1.A12 = R_2.A21)),

Filter as (
select R_1_1
from Candidates C join R_1 on C.R_1_1 = R_1.A11
left outer join R_2 on R_1.A12 = R_2.A21 
left outer join R_7 on R_2.A22 = R_7.A71
where (R_2.A21 is null OR R_7.A71 is null)
union all select C.R_1_1 from Candidates C
group by C.R_1_1
having count(*) > 1)

select distinct R_1_3
from Candidates C
where not exists
(select * from Filter F where C.R_1_1 = F.R_1_1)
