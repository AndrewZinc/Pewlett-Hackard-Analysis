select first_name, last_name
from employees
where birth_date between '1952-01-01' and '1955-12-31';

select first_name, last_name
from employees
where birth_date between '1952-01-01' and '1952-12-31';

select first_name, last_name
from employees
where birth_date between '1953-01-01' and '1953-12-31';

select first_name, last_name
from employees
where birth_date between 0'1954-01-01' and '1954-12-31';

select first_name, last_name
from employees
where birth_date between '1955-01-01' and '1955-12-31';

select first_name, last_name
from employees
where (birth_date between '1952-01-01' and '1955-12-31')
and (hire_date between '1985-01-01' and '1988-12-31');

select count(first_name)
from employees
where (birth_date between '1952-01-01' and '1955-12-31')
and (hire_date between '1985-01-01' and '1988-12-31');


select first_name, last_name
into retirement_info
from employees
where (birth_date between '1952-01-01' and '1955-12-31')
and (hire_date between '1985-01-01' and '1988-12-31');

--Joining retirement_info and dept_emp tables
select retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
	from retirement_info
	left join dept_emp
	on retirement_info.emp_no = dept_emp.emp_no;

--Refactoring - Joining retirement_info and dept_emp tables
select ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
	from retirement_info as ri
	left join dept_emp as de
	on ri.emp_no = de.emp_no;

--Joining departments and dept_manager tables
select d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
	from departments as d
	inner join dept_manager as dm
	on d.dept_no = dm.dept_no;

--Select retirement-eligible current employees
select ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
	into current_emp
	from retirement_info as ri
	left join dept_emp as de
	on ri.emp_no = de.emp_no
	where de.to_date = ('9999-01-01');

--Employee count by department number
select count(ce.emp_no), de.dept_no
	into emp_count
	from current_emp as ce
	left join dept_emp as de
	on ce.emp_no = de.emp_no
	group by de.dept_no
	order by de.dept_no;

-- Employee list 1
select e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
into emp_info
from employees as e
inner join salaries as s
on (e.emp_no = s.emp_no)
inner join dept_emp as de
on (e.emp_no = de.emp_no)
where (e.birth_date between '1952-01-01' and '1955-12-31')
and (e.hire_date between '1985-01-01' and '1988-12-31')
and (de.to_date = '9999-01-01');

-- List (2) of managers per department
select dm.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.last_name,
	ce.first_name,
	dm.from_date,
	dm.to_date
into manager_info
from dept_manager as dm
	inner join departments as d
		on (dm.dept_no = d.dept_no)
	inner join current_emp as ce
		on (dm.emp_no = ce.emp_no);
	
-- list (3) department retirees
select ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
into dept_info
from current_emp as ce
	inner join dept_emp as de
		on (ce.emp_no = de.emp_no)
	inner join departments as d
		on (de.dept_no = d.dept_no);

--skill drill 1	- employees in Sales department	
select * from dept_info
where dept_name = 'Sales'
order by emp_no ASC;

--skill drill 2	- employees in Sales and Development departments	
select * from dept_info
where dept_name in ('Development','Sales')
order by dept_name, emp_no ASC;
	
select e.emp_no, e.first_name, e.last_name, e.hire_date,
	t.title, t.from_date, t.to_date
--into retirement_titles
from employees as e
left join titles as t
	on (e.emp_no = t.emp_no)
where (e.birth_date between '1952-01-01' and '1955-12-31');
--and (e.hire_date between '1985-01-01' and '1988-12-31');	
	
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
--INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER By emp_no ASC, to_date DESC;	



select count(title), title
into retiring_titles
from unique_titles
group by title
order by count(title) desc;
	
select * from retiring_titles

select distinct on (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date,
	de.from_date, de.to_date, t.title
into mentorship_eligibility
from employees as e
join dept_emp as de
	on (e.emp_no = de.emp_no)
join titles as t
	on (e.emp_no = t.emp_no)
where (de.to_date = '9999-01-01') and
	(e.birth_date between '1965-01-01' and '1965-12-31')
order by e.emp_no;


