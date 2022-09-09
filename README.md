# Pewlett-Hackard Succession Planning Analysis

### Overview
A major employer has decided to modernize their employee-data systems, moving from spreadsheets to a relational database.  It is expected that this transition will enable better visibility into the employee population and allow succession planning around the retirement of older employees.

## Analysis Process
The analysis consisted of a review of the six comma-separated-value (CSV) files that the company has provided as input into the new database.  The review revealed that the majority of the files contain several thousands of entries and each includes data headers.

### CSV Input Files
The following files were provided for input:

* departments.csv - provides department names and an identification number for each department.
* dept_emp.csv -  identifies the employee numbers within each department number, with from & to dates.
* dept_manager.csv - identifies the department managers by employee number, with from & to dates.
* employees.csv - provides employee names, birthdates, gender, and their hire date with their employee number.
* salaries.csv - provides the employee salary with employee number and from & to dates.
* titles.csv - identifies the employee titles, by employee number with from & to dates.

### Entity Relationship Diagram
Using the CSV input files, an Entity Relationship Diagram was constructed to begin planning the database implementation. 

![Entity Relationship Diagram](EmployeeDB.png)


THe company selected the PostgreSQL database engine for their new system. Using PGAdmin4, a new database was created. The data tables were then built in accordance with the Entity Relationship Diagram.

As the CSV files were being imported, it was discovered that there were two tables that needed to be dropped and rebuilt without primary keys.  The data in the CSV files contained many instances of multiple entries within the data destined to be the primary key for the tables.  The diagram above was updated to its current state to reflect the table structure, as implemented.

# Results

It was necessary to query and build new tables to explore the accumulated data, and begin to provide answers to the questions from management.

The following queries were created:

* Determine the retirement eligible population, based on employee age and hire date.
	* 41,380 employees are eligible for retirement based on their age.
	* A new table ```retirement_info``` was created to contain the list of eligible employees.
	* The table data was exported into a CSV file - ```(Data\retirement_info.csv)```
	* This data requires additional investigation, as some or many of the employees may have already left the company.
	
* Determine the retirement eligible employee population that is still with the company.
	* A new table for current employees -  ```current_emp``` was created by joining the ```retirement_info``` table with the ```dept_emp``` table and filtering on whether the ```dept_emp.to_date``` indicates a current employee.
	
* Determine the number of retirement eligible employees by department.
	* A query using a left join was written to combine the data from the current employee table with the ```dept_emp``` table to identify the employee department and provide a count of these employees by department.
	* A new table ```employee_counts_by_dept``` was created during the query execution, and the data was exported into a CSV file - ```(Data\employee_counts_by_dept.csv)```
	
* Collect the retirement-eligible employee information into a single table
	* The following query was written to perform this task and store the results into a new ```emp_info``` table.
	
```
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
```

* Determine the number of retirement-eligible managers per department
	* The following query was written to perform this task and store the results into a new ```manager_info``` table.

```
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
```
* Determine the number of retiring employees by title


	
* Determine the employees available to participate in a mentorship program
	







The analysis should contain the following:

    Overview of the analysis: Explain the purpose of this analysis.
    Results: Provide a bulleted list with four major points from the two analysis deliverables. Use images as support where needed.
    Summary: Provide high-level responses to the following questions, then provide two additional queries or tables that may provide more insight into the upcoming "silver tsunami."
        How many roles will need to be filled as the "silver tsunami" begins to make an impact?
        Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?

