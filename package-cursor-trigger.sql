--1. Write a procedure to calculate factorial of a number 
--and return the value to parameter of procedure:
--- Factorial (in val, out result)
CREATE OR REPLACE PROCEDURE calFac (x in INT, y OUT NUMBER)
AS
  kq NUMBER :=1;
BEGIN
  FOR i IN 1..x LOOP
    kq := kq*i;
  END LOOP;
  y := kq;
END;
/
set serveroutput on
DECLARE 
  a NUMBER;
BEGIN
  calFac(5,a);
  dbms_output.put_line('KET QUA: ' || a);
END;

--- Factorial (inout val)
CREATE OR REPLACE PROCEDURE calFac2 (x in out number)
AS
  kq NUMBER :=1;
BEGIN
  FOR i IN 1..x LOOP
    kq := kq*i;
  END LOOP;
  x := kq;
END;
/
DECLARE 
  a NUMBER:=10;
BEGIN
  calFac2(a);
  dbms_output.put_line('KET QUA: ' || a);
END;
--2. Write a procedure to find name, address of a student 
--and output these values to the parameters of the
--procedure. Write a pl/sql block to call this 
--procedure with parameter is 114 and print out these 
--values on the screen.
CREATE OR REPLACE PROCEDURE findStudent (sid STUDENT.STUDENT_ID%TYPE,
                   sname OUT VARCHAR2, sadd OUT student.street_address%TYPE)
AS
BEGIN
     SELECT first_name || last_name, street_address INTO sname, sadd
     FROM STUDENT
     WHERE STUDENT_ID = sid;
     -- TU VIET THEM EXEPTION (NO DATA FOUND)
     EXCEPTION
      WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE ('khong co du lieu gi');
END;
/
DECLARE
   sn VARCHAR2(100);
   sa student.street_address%TYPE;
BEGIN
   findStudent(114, sn, sa);
   DBMS_OUTPUT.PUT_LINE('NAME: ' || sn || ' address' || sa);
END;
--3. Write a procedure to print out name, address of a 
--student and how many courses this student is 
--enrolled. Use procedure above (question 2) to get 
--information about name and address of this student.
--Write a pl/sql block to call this procedure with 
--parameter is 106.
CREATE OR REPLACE PROCEDURE printStudent( stuid STUDENT.STUDENT_ID%TYPE)
AS
   sn VARCHAR2(100);
   sa student.street_address%TYPE;
   x INT;
BEGIN
   findStudent(stuid, sn, sa);
   DBMS_OUTPUT.PUT_LINE('NAME: ' || sn || ' address: ' || sa);
   SELECT COUNT(COURSE_NO) INTO x
   FROM ENROLLMENT e JOIN SECTION s ON e.SECTION_ID=s.section_id
   WHERE STUDENT_ID = stuid;
   DBMS_OUTPUT.PUT_LINE('NUMBER OF COURSE ENROLLED: ' || x);
END;
/
BEGIN
   printStudent(106);
END;

--Packages
--5. Create a package that contains functions for
--a. Adding three integers
--b. Subtracting two integers
--c. Multiplying three integers
CREATE OR REPLACE PACKAGE Math_action AS
  FUNCTION addInt (x INT , y INT, z INT ) RETURN INT;
  FUNCTION subInt (a INT, b INT) RETURN INT;
  FUNCTION mulInt (a INT, b INT, c INT) RETURN NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY math_action AS
  FUNCTION addInt (x INT , y INT, z INT ) RETURN INT
  AS
  BEGIN
    RETURN x+y+z;
  END;
  FUNCTION subInt (a INT, b INT) RETURN INT
  AS
  BEGIN
    RETURN a-b;
  END;
  FUNCTION mulInt (a INT, b INT, c INT) RETURN NUMBER
  AS
  BEGIN
    RETURN a*b*c;
  END;
END;


BEGIN
  DBMS_OUTPUT.PUT_LINE(math_action.mulInt(4,2,7));
END;
  
--Cursor
--7. Write a pl/sql block to prints out instructor_id, 
--salutation, first_name, last_name of all the 
--instructors. (using cursor)
--SQL CURSOR FOR LOOP
BEGIN
  FOR ins IN (SELECT * FROM instructor) LOOP
  dbms_output.put_line ('ID: '|| ins.instructor_id || ' salutation: '|| ins.salutation || 
  ' name: ' || ins.first_name || ' ' || ins.last_name);
  END LOOP;
END;

--EXPLICIT CURSOR FOR LOOP
DECLARE
  CURSOR c_instructor IS SELECT * FROM instructor;
BEGIN
  FOR ins IN (SELECT * FROM instructor) LOOP
  dbms_output.put_line ('ID: '|| ins.instructor_id || ' salutation: '|| ins.salutation || 
  ' name: ' || ins.first_name || ' ' || ins.last_name);
  END LOOP;
END;

--10. Write a PL/SQL block with two cursor for loops. The 
--parent cursor will call the student_id, first_name, 
--and last_name from the student table for students 
--with a student_id less than 110 and output one line 
--with this information. For each student, the child 
--cursor will loop through all the courses that the 
--student is enrolled in, outputting the course_no and 
--the description

BEGIN
  FOR stu IN (SELECT * FROM STUDENT WHERE STUDENT_ID<110) LOOP
  dbms_output.put_line ('ID: '|| stu.STUDENT_ID ||
  ' name: ' || stu.first_name || ' ' || stu.last_name);
  
    FOR cour IN (SELECT DISTINCT c.* 
      FROM enrollment e, section s, course c
      WHERE e.section_id = s.section_id AND s.course_no = c.course_no
      AND student_id = stu.student_id)
    LOOP
      dbms_output.put_line ('COURSE_NO: '|| cour.course_no ||
    ' des: ' || cour.description );
    END LOOP;
  END LOOP;
END;

--EXPLICIT CURSOR FOR LOOP
DECLARE
  CURSOR c_student IS SELECT * FROM student where student_id<110;
  CURSOR c_course (stuid STUDENT.STUDENT_ID%TYPE) is 
  SELECT DISTINCT c.* 
      FROM enrollment e, section s, course c
      WHERE e.section_id = s.section_id AND s.course_no = c.course_no
      AND student_id = stuid;
      
BEGIN
  FOR stu IN c_student LOOP
    dbms_output.put_line ('id: '|| stu.student_id ||
    ' name: ' || stu.first_name || ' ' || stu.last_name );
     FOR cour IN c_course(stu.student_id) LOOP
      dbms_output.put_line ('COURSE_NO: '|| cour.course_no ||
    ' des: ' || cour.description );
    END LOOP; 
  END LOOP;
END;

--Trigger
--13. Write a trigger:
--When inserting data into employee table, 
--created_date is the sysdate.
--When updating data of employee table, modified_date 
--is the sysdate.

create or replace trigger trg_emp
BEFORE INSERT OR UPDATE ON EMPLOYEE
FOR EACH ROW
-- kHAI BAO BIEN
BEGIN
  IF(INSERTING) THEN
    :NEW.CREATED_DATE :=SYSDATE;
  ELSIF(UPDATING) THEN
    :NEW.MODIFIED_DATE :=SYSDATE;
  END IF;
END;
/
INSERT INTO EMPLOYEE (EMPLOYEE_ID,NAME,SALARY, TITLE) VALUES (30,'SAHARA',9999,'PRESIDENT')
UPDATE EMPLOYEE SET NAME='BLUE' WHERE employee_id = 30;
SELECT * FROM employee

--14. Write a trigger: when updating name, salary, title 
--of an employee in employee table, old data of this 
--employee will be inserted into employee_change 
--table.
create or replace trigger trg_emp2
BEFORE UPDATE OF NAME, SALARY, TITLE ON EMPLOYEE
FOR EACH ROW
BEGIN
  INSERT INTO employee_change VALUES (:OLD.EMPLOYEE_ID, :OLD.NAME,:OLD.SALARY,:OLD.TITLE);
END;
/
UPDATE EMPLOYEE SET SALARY=777777 WHERE EMPLOYEE_ID = 30;

--15. Write a trigger to guarantee that: Salary of a new 
--employee cannot below 100.
CREATE OR REPLACE TRIGGER TRG_EMP3
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
  IF(:NEW.SALARY<100) THEN
    RAISE_APPLICATION_ERROR(-20000,'LUONG QUA THAP');
  END IF;
END;
/
INSERT INTO employee (employee_id, NAME, salary, title) VALUES (33, 'MARY', 14, 'CLERK');

--16. Write a trigger: when inserting data into employee 
--table, the first letter of name of employee will be 
--capitalized (initcap)
CREATE OR REPLACE TRIGGER TRG_EMP4
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
  :NEW.NAME := initcap(:NEW.NAME);
END;

INSERT INTO employee (employee_id, NAME, salary, title) VALUES (34, 'luan', 114, 'CLERK');

SELECT * FROM employee_change;
SELECT * FROM employee;
