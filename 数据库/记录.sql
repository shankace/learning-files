with a AS 
(
    select id
        ,virtual_card_num
        ,nvl(physical_card_num, virtual_card_num) as physical_card_num
    from lhdataintegration.ods_crm_member_card
)
,b as
(
select id
    ,CONCAT(virtual_card_num, ',', physical_card_num) as vir_phy
from a
)

select id, wm_concat(',', card)
from 
(
    select id
        , card 
    from b lateral view explode(split(vir_phy, ',')) b as card
)
group by id;

-- 窗口函数之组内TopN
select member_id
    ,area_name
from 
(
    select member_id
        ,area_name
        ,row_number() over(partition by member_id) as r
    from lhdataintegration.ods_crm_member_address
    where area_name is not null 
        and area_name !=""
)
where r=1;

--分组差值计算
select userid,
	time stime,
	lead(time) over(partition by userid order by time) etime, 
	url 
from test.user_log;
+---------+----------------------+----------------------+-------+--+
| userid  |        stime         |        etime         |  url  |
+---------+----------------------+----------------------+-------+--+
| Marry   | 2015-11-12 01:10:00  | 2015-11-12 01:15:10  | url1  |
| Marry   | 2015-11-12 01:15:10  | 2015-11-12 01:16:40  | url2  |
| Marry   | 2015-11-12 01:16:40  | 2015-11-12 02:13:00  | url3  |
| Marry   | 2015-11-12 02:13:00  | 2015-11-12 03:14:30  | url4  |
| Marry   | 2015-11-12 03:14:30  | NULL                 | url5  |
| Peter   | 2015-10-12 01:10:00  | 2015-10-12 01:15:10  | url1  |
| Peter   | 2015-10-12 01:15:10  | 2015-10-12 01:16:40  | url2  |
| Peter   | 2015-10-12 01:16:40  | 2015-10-12 02:13:00  | url3  |
| Peter   | 2015-10-12 02:13:00  | 2015-10-12 03:14:30  | url4  |
| Peter   | 2015-10-12 03:14:30  | NULL                 | url5  |
+---------+----------------------+----------------------+-------+--+
