-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER By emp_no ASC, to_date DESC;	

-- Identify the number of retiring employees by title
select count(title), title
into retiring_titles
from unique_titles
group by title
order by count(title) desc;

--Identify the employees eligible for participation in a mentorship program
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