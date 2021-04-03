-- Select all the employees who were born between January 1, 1952 and December 31, 1955 and their titles and title date ranges
-- Order the results by emp_no
with retiring as (select * from employees 
where to_char(birth_date, 'YYYY-MM-DD') between '1952-01-01' and '1955-12-31')
select retiring.emp_no,
        retiring.first_name,
		retiring.last_name,
		titles.title,
		titles.from_date,
		titles.to_date,
		retiring.birth_date
		from retiring join titles 
		on retiring.emp_no=titles.emp_no
		order by emp_no;


-- Select only the current title for each employee	

with emp_fil as (
with retiring as (select * from employees 
where to_char(birth_date, 'YYYY-MM-DD') between '1952-01-01' and '1955-12-31')
	
select retiring.emp_no, 
		retiring.first_name,
		retiring.last_name,
		titles.title,
		titles.from_date,
		titles.to_date,
	    retiring.birth_date
		from retiring join titles 
		on retiring.emp_no=titles.emp_no
		order by emp_no),
		
cur_emp as (
select emp_no, max(from_date) as most_recent from titles group by emp_no)

select emp_fil.emp_no, emp_fil.first_name, emp_fil.last_name, emp_fil.title as current_title from emp_fil join cur_emp on ((emp_fil.emp_no=cur_emp.emp_no) and (emp_fil.from_date=cur_emp.most_recent));


-- Count the total number of employees about to retire by their current job title
with lat_title as (
with emp_fil as (
with retiring as (select * from employees 
where to_char(birth_date, 'YYYY-MM-DD') between '1952-01-01' and '1955-12-31')
	
select retiring.emp_no, 
		retiring.first_name,
		retiring.last_name,
		titles.title,
		titles.from_date,
		titles.to_date,
	    retiring.birth_date
		from retiring join titles 
		on retiring.emp_no=titles.emp_no
		order by emp_no),
		
cur_emp as (
select emp_no, max(from_date) as most_recent from titles group by emp_no)

select emp_fil.emp_no, emp_fil.first_name, emp_fil.last_name, emp_fil.title as current_title from emp_fil join cur_emp on ((emp_fil.emp_no=cur_emp.emp_no) and (emp_fil.from_date=cur_emp.most_recent)))

select current_title, count (*) as employee_count from lat_title group by current_title;


-- Count the total number of employees per department

with count_by_dept as(
select dept_no, count(emp_no) as num_of_employee from dept_emp group by dept_no )
select dept_name, count_by_dept.num_of_employee from departments join count_by_dept on (departments.dept_no=count_by_dept.dept_no);


-- Bonus: Find the highest salary per department and department manager
--Highest salary per department
with lat_emp_salary as (
with lat_emp_date as(
with lat_emp as (select emp_no, max(from_date) as from_date from dept_emp group by emp_no)
select lat_emp.emp_no, 
		lat_emp.from_date, 
		dept_emp.dept_no
		from lat_emp join dept_emp 
		on lat_emp.emp_no=dept_emp.emp_no
			and dept_emp.from_date=lat_emp.from_date)
			select lat_emp_date.emp_no,
					lat_emp_date.dept_no,
					salaries.salary
					from lat_emp_date join salaries
					on lat_emp_date.emp_no=salaries.emp_no
					and lat_emp_date.from_date=salaries.from_date
					order by emp_no)
		select dept_no, 
				max(salary) as highest_salary from
				lat_emp_salary
				group by dept_no
				order by dept_no 


--Highest salary per department manager
with lat_manager_salaries as (
with lat_salaries as (
with lat_emp as( 
select emp_no,
		max(from_date) as lat_appt 
		from salaries group by emp_no)
select lat_emp.*, 
		salaries.salary 
		from salaries join lat_emp 
		on salaries.emp_no=lat_emp.emp_no 
		and salaries.from_date=lat_emp.lat_appt
		order by emp_no),

current_managers as(
select dept_no, emp_no, from_date from dept_manager where to_date= '9999-01-01')
	
select current_managers.dept_no, 
		lat_salaries.emp_no, 
		lat_salaries.salary 
		from current_managers join
		lat_salaries on current_managers.emp_no=lat_salaries.emp_no)
select max(salary) from lat_manager_salaries