1068.产品销售分析 I
select p.product_name,year,price
from sales as s,product as p
where s.product_id = p.product_id

1069. 产品销售分析 II
select  product_id,
        sum(quantity) 'total_quantity'
from sales as s
group by product_id

1070. 产品销售分析 III
select product_id,year 'first_year',quantity,price
from sales
where (product_id,year)
in (select product_id,
    min(year) 
    from sales 
    group by product_id)

1303. 求团队人数
select e1.employee_id,e2.team_size
from employee as e1,
    (select team_id,
    count(team_id) 'team_size'
    from employee 
    group by team_id ) as e2
where e1.team_id = e2.team_id

1251. 平均售价
select product_id,round(sum(price*units)/sum(units),2) 'average_price'
from
    (select p.product_id,p.price,u.units
    from prices as p,unitssold as u
    where p.product_id=u.product_id and (purchase_date between start_date and end_date))
as a group by product_id

584. 寻找用户推荐人
select name 
from
    (select name,ifnull(referee_id,1) 'id'from customer) as a 
where id !=2 

613. 直线上的最近距离
select min(abs(p1.x-p2.x)) 'shortest'
from point as p1,point as p2
where p1.x<p2.x

1173. 即时食物配送 I
select round
    ((select count(delivery_id)from delivery 
    where order_date = customer_pref_delivery_date)/
    (select count(delivery_id) from delivery)*100
    ,2) as immediate_percentage 

1174. 即时食物配送 II
select round(
(select count(customer_id) from 
(select customer_id,order_date 'o_d',customer_pref_delivery_date 'c_d',
row_number() over(partition by customer_id order by order_date) 'rank1'
from delivery) as a
where rank1 = 1 and o_d=c_d)
/
(select count(distinct customer_id) from delivery)*100,2) as immediate_percentage 

1050. 合作过至少三次的演员和导演
select actor_id,director_id
from ActorDirector 
group by actor_id,director_id
where having(*)>=3

1082. 销售分析
select seller_id from
(select 
        seller_id,
        dense_rank() over(order by sales desc) 'rank1'
from  
(select seller_id,sum(price) 'sales' 
    from Sales 
    group by seller_id) as a) as b
where rank1 = 1

586. 订单最多的客户
select customer_number
from orders
group by customer_number
order by count(customer_number) desc
limit 1

511. 游戏玩法分析 I
法一：
select player_id,event_date 'first_login'
from(
    select player_id,event_date,
    row_number() over(partition by player_id order by event_date) 'rank1'
    from Activity) as a 
where rank1 = 1 
法二：
select player_id,min(event_date) first_login
from Activity
group by player_id

1148. 文章浏览 I
select distinct(author_id) 'id'
from views
where author_id = viewer_id
order by id asc

577. 员工奖金
select e.name,bonus
from employee as e left join bonus as b 
on e.empid = b.empid 
where bonus is null or bonus<1000

603. 连续空余座位(重点：连续id的问题)
select distinct(a.seat_id) 'seat_id'
from cinema as a,cinema as b
where abs(a.seat_id-b.seat_id)=1 and a.free = b.free and a.free =1
order by seat_id

1075. 项目员工 I
select project_id,round(sum(experience_years)/count(employee_id),2) 'average_years'
from
    (select project_id,p.employee_id,experience_years 
    from project as p,employee as e
    where p.employee_id = e.employee_id) as a 
group by project_id

607. 销售员
select name
from salesperson
where sales_id not in 
    (select sales_id
    from company as c,orders as o
    where c.com_id = o.com_id and name = 'RED')

1294. 不同国家的天气类型(中等难度)
select country_name,
(case 
    when type<=15 then 'Cold'
    when type>=25 then 'Hot' 
    else 'Warm' 
end) 'weather_type'
from
(select country_name,sum(weather_state)/count(country_name) 'type'
from
(select country_name,weather_state
from countries as c,weather as w
where c.country_id = w.country_id and month(day) = 11) as a 
group by country_name) as b

610. 判断三角形
法一：
select x,y,z,
(case 
    when (x+y>z and x+z>y and y+z>x and x-y<z and x-z<y and z-y<x) then 'Yes'
    else 'No'
end) 'triangle'
from triangle
法二：
select *,if(x+y>z and x+z>y and y+z>x,'Yes','No') 'triangle'
from triangle

1211. 查询结果的质量和占比
select query_name,
round(sum(rating/position)/count(*),2) 'quality',
round(sum(if(rating<3,1,0))*100/count(*),2) 'poor_query_percentage'
from queries
group by query_name

1241. 每个帖子的评论数
select b.sub_id 'post_id',ifnull(count,0) 'number_of_comments'
from 
    (select parent_id,count(distinct(sub_id)) 'count'
    from submissions group by parent_id) as a 
right join 
    (select distinct(sub_id),ifnull(parent_id,0) 'parent_id' from submissions) 
    as b 
on a.parent_id = b.sub_id
where b.parent_id = 0
order by post_id 

select t.sub_id 'post_id',ifnull(count(distinct s.sub_id),0) 'number_of_comments'
from submissions as s 
right join
    (select sub_id 
        from submissions 
        where parent_id is null) as t
on s.parent_id = t.sub_id
group by t.sub_id

1113. 报告的记录
select extra 'report_reason',count(distinct(post_id)) 'report_count'
from  actions 
where action_date = '2019-07-04' 
and extra is not null 
and action = 'report'
group by extra

1084. 销售分析III
select product_id,product_name 
from product 
where product_id not in 
    (select product_id  
    from sales 
    where sale_date not between '2019-01-01' and '2019-03-31')

512. 游戏玩法分析 II
select player_id,device_id
from
    (select player_id,device_id,
    row_number() over(partition by player_id order by event_date) 'rank1'
from Activity) as a
where rank1 = 1

1280. 学生们参加各科测试的次数(较难)
select  t1.student_id,
        t1.student_name,
        t2.subject_name,
        ifnull(t3.count,0) 'attended_exams'
from 
    students as t1 join subjects as t2
    left outer join
    (select *,count(*) 'count' 
    from examinations 
    group by student_id,subject_name) as t3
on t1.student_id = t3.student_id
and t2.subject_name = t3.subject_name
order by t1.student_id,t2.subject_name

1083. 销售分析 II
法一：先去除买iphone的buyer
select buyer_id
from (
    select p.product_id,product_name,buyer_id
    from Sales as s join product as p 
    on s.product_id = p.product_id) as a 
where buyer_id not in (
    select buyer_id
    from Sales as s join product as p 
    on s.product_id = p.product_id
    where p.product_name = 'iPhone')
and product_name = 'S8'

法二：列转行
select buyer_id
from(
    select s.product_id,buyer_id,
    case when product_name='S8' then 1 else 0 end 'S8',
    case when product_name='iPhone' then 1 else 0 end 'iPhone'
    from Sales as s left join product as p
    on s.product_id = p.product_id) as a 
group by buyer_id
where sum(S8) >= 1 and sum(iPhone) = 0

1141. 查询近30天活跃用户数
select  activity_date 'day',
        count(distinct(user_id)) 'active_users'
from Activity 
where activity_date between '2019-06-28' and '2019-07-27'
-- where datediff('2019-07-27',activity_date) < 30
group by activity_date

1076. 项目员工II
select project_id
from(
    select project_id,
        dense_rank() over(order by count(employee_id) desc) 'rank1'
    from project
    group by project_id) as a 
where rank1 = 1

619. 只出现一次的最大数字
select max(num) 'num'
from(
    select num
    from my_numbers 
    group by num 
    having count(num) <= 1) as a

597. 好友申请 I：总体通过率
select 
round(
    ifnull(
        (select count(*)
        from(select distinct requester_id,accepter_id from requestAccepted) as a)
        /
        (select count(*)
        from(select distinct sender_id,send_to_id from friendrequest) as b),
        0)
,2) as accept_rate 

1142. 过去30天的用户活动 II
select ifnull(round(sum(count)/count(user_id),2),0) as average_sessions_per_user 
from(
    select  user_id,
            count(distinct session_id) as count
    from activity
    where datediff('2019-07-27',activity_date) < 30
    group by user_id
    ) as a 

1270. 向公司CEO汇报工作的所有人
select e1.employee_id
from employees as e1 join employees as e2
on e1.manager_id = e2.employee_id
left join employees e3 
on e2.manager_id = e3.employee_id
where e1.employee_id != 1 and e3.manager_id = 1

1285. 找到连续区间的开始和结束数字(连续数字问题)
select min(log_id) 'start_id',
       max(log_id) 'end_id' 
from(
    select log_id,
           row_number() over(order by log_id),
           log_id - row_number() over(order by log_id) 'ran'
    from logs) as a
group by ran 

1308. 不同性别每日分数总计
select gender,
        day,
        sum(score_points) over(partition by gender order by day) 'toatl'
from scores

1204. 最后一个能进入电梯的人(较难)
select a.person_name 
from queue as a,queue as b
where a.turn >= b.turn
group by a.person_id having sum(b.weight) <=1000
order by a.turn desc
limit 1

1077.项目员工 III
select project_id,employee_id
from(
    select  project_id,
            p.employee_id,
            dense_rank() over(partition by project_id 
            order by experience_years desc) 'rank1'
    from project as p,employee as e
    where p.employee_id = e.employee_id) as a
where rank1 = 1

1126. 查询活跃业务
select business_id
from Events as a 
join
    (select event_type,avg(occurences) 'avg_occurences'
    from Events
    group by event_type) as b
on a.event_type = b.event_type
where occurences > avg_occurences
group by business_id
having count(a.event_type) >= 2

608. 树节点
#根节点（父节点为空）
select id,'Root' as type
from tree 
where p_id is null
union
#叶子节点（无孩子节点，有父节点）
select id,'Leaf' as type
from tree 
where id not in (select distinct p_id from tree where p_id is not null)
and p_id is not null
union
#内节点（有孩子节点，有父节点）
select id,'Inner' as type
from tree
where id in (select distinct p_id from tree where p_id is not null)
and p_id is not null
order by id

570. 至少有5名直接下属的经理
select name from employee where id in
(select managerid
from employee 
group by managerid 
having count(*) >=5)

534. 游戏玩法分析 III
select player_id,event_date,
        sum(games_played) 
        over(partition by player_id order by event_date) 'games_played_so_far'
from activity 

612. 平面上的最近距离

select 
    round(sqrt(min(power((a.x-b.x),2)+power((a.y-b.y),2))),2) 'shortest'
from 
    point_2d as a,point_2d as b
where 
    a.x !=b.x or a.y != b.y

1045. 买下所有产品的客户(有问题)
select customer_id
from customer
group by customer_id
having count(distinct product_key) in 
(select count(distinct product_key) from product)

574. 当选者
select name 
from candidate
where id = 
(select CandidateId from
(select CandidateId,(count(id)) 'count' from vote group by CandidateId) as a
order by count desc limit 1)

好友申请 II ：谁有最多的好友
select id,sum(num) 'num'
from 
((select requester_id 'id',count(*) 'num'
from request_accepted
group by requester_id)
union all
(select accepter_id 'id',count(*) 'num'
from request_accepted
group by accepter_id)) as a
group by id 
order by num desc
limit 1

1164. 指定日期的产品价格
select a.product_id,ifnull(new_price,10) 'price'
from(
    select distinct product_id 
    from products) as a 
left join (
    select product_id,new_price 
    from products 
    where (product_id,change_date) in
    (select product_id,max(change_date) 'change_date'
    from products
    where change_date <= '2019-08-16'
    group by product_id)) as b 
on a.product_id = b.product_id

1193. 每月交易 I
select c.month,trans_count,approved_count,trans_total_amount,approved_total_amount
from
(select month,country,count(state) 'approved_count',sum(amount) 'approved_total_amount'
from(
    select id,country,state,amount,
    date_format(trans_date,'%Y-%m') 'month'
    from transactions) as c
where state = 'approved'
group by month,country) as a Inner join
(select month,count(state) 'trans_count',sum(amount) 'trans_total_amount'
from(
    select id,country,state,amount,
    date_format(trans_date,'%Y-%m') 'month'
    from transactions) as d
group by month,country) as b
on a.month = b.month

select  date_format(trans_date,'%Y-%m') as month,
        country,
        count(*) as trans_count,
        count(if(state = 'approved',1,null)) as approved_count,
        sum(amount) as trans_total_amount,
        sum(if(state = 'approved',amount,0)) as approved_total_amount
from transactions
group by month,country

1112. 每位学生的最高成绩
select student_id,course_id as course_id,grade
from(
    select student_id,course_id,grade,
            row_number() over(partition by student_id order by grade desc,course_id) as rank1
    from enrollments) as a 
where rank1 = 1
order by student_id

1321. 餐馆营业额变化增长(高难度)
SELECT visited_on, amount, average_amount
FROM
(SELECT visited_on, SUM(amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount, 
    ROUND(AVG(amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS average_amount, 
    ROW_NUMBER() OVER (ORDER BY visited_on) AS rn
FROM
(SELECT DISTINCT visited_on, SUM(amount) over (PARTITION BY visited_on ORDER BY visited_on) AS amount
FROM Customer ) a ) b
WHERE b.rn >= 7

1264. 页面推荐
select distinct page_id as recommended_page 
from likes 
where (user_id in (select user1_id from friendship where user2_id = 1)
or user_id in (select user2_id from friendship where user1_id = 1))
and page_id not in (select page_id from likes where user_id = 1)

585. 2016年的投资
select sum(tiv_2016) as TIV_2016 
from insurance 
where tiv_2015 in (select tiv_2015 
                    from insurance 
                    group by tiv_2015 
                    having count(tiv_2015)>1)
and concat(lat,lon) in (select concat(lat,lon) as concat
                        from insurance
                        group by lat,lon
                        having count(concat) = 1)

1158. 市场分析 I
select user_id as buyer_id,join_date,ifnull(orders_in_2019,0) as orders_in_2019
from users as a     
left join(
        select buyer_id,count(buyer_id) as orders_in_2019 
        from orders
        where year(order_date) = 2019
        group by buyer_id) as b
on a.user_id = b.buyer_id

580. 统计各专业学生人数
select dept_name,ifnull(student_number,0) as student_number
from(
    select dept_id,count(*) as student_number
    from student
    group by dept_id) as a
right join department as b
on a.dept_id = b.dept_id
order by student_number desc,dept_name

1212. 查询球队积分(较难)
select t.team_id,t.team_name,ifnull(score,0) num_points
from (
    select team_id,sum(score) score
    from(
        select host_team team_id,
        sum(case 
        when host_goals > guest_goals then 3
        when host_goals = guest_goals then 1
        else  0 end ) score
        from matches 
        group by host_team
        union all
        select guest_team team_id,
        sum(case 
        when host_goals < guest_goals then 3
        when host_goals = guest_goals then 1
        else  0 end ) as score   
        from matches 
        group by guest_team) as b
    group by team_id ) as a
right join teams t on t.team_id = a.team_id
order by num_points desc,t.team_id

578. 查询回答率最高的问题
select question_id as survey_log
from survey_log
group by question_id
order by sum(if(action = 'answer',1,0))/sum(if(action = 'show',1,0)) desc   
limit 1

1205. 每月交易II(较难)
select 
from transactions as a
left join chargebachs as b
on a.id = b.trans_id

1098. 小众书籍
select b.book_id,name
from books as b left join orders as o
on b.book_id = o.book_id and dispatch_date >= '2018-06-23'
where available_from < '2019-05-23'
group by b.book_id
having ifnull(sum(quantity),0) < 10

1149. 文章浏览 II
select distinct viewer_id as id
from views 
group by view_date,viewer_id
having count(distinct article_id) >=2
order by id 

550. 游戏玩法分析 IV
select round(count(b.player_id)/count(a.player_id),2) as fraction  
from
    (select player_id,min(event_date) event_date
    from activity
    group by player_id) as a
left join activity as b
on a.player_id = b.player_id and datediff(b.event_date,a.event_date) = 1











































 



































