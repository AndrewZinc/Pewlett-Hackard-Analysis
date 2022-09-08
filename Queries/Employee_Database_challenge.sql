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