
--1. Write a pl/sql block to assign value to a variable and print 
--out the value.
SET SERVEROUTPUT ON
DECLARE
  x INT;
  y VARCHAR2(50) := 'HELLO WORLD';
BEGIN
  x:=9;
  DBMS_OUTPUT.PUT_LINE('GIA TRI CUA X: ' || x);
  DBMS_OUTPUT.PUT_LINE('GIA TRI CUA Y: ' || y);
END;
--2. Write a pl/sql block to check number is Odd or Even.
DECLARE
  x INT := 18;
BEGIN
  IF (MOD(x,2)=0) THEN
    DBMS_OUTPUT.PUT_LINE(x || ' la so chan');
  ELSE 
    DBMS_OUTPUT.PUT_LINE(x || ' la so le');
  END IF;
END;

--3. Write a pl/sql block to check a number is greater or lower 
--than 0.

DECLARE
  x INT := -95;
  BEGIN
    IF(x>0) THEN
      DBMS_OUTPUT.PUT_LINE(x || ' LON HON 0');
    ELSIF(x<0) THEN
      DBMS_OUTPUT.PUT_LINE(x || ' NHO HON 0');
    ELSE
      DBMS_OUTPUT.PUT_LINE(x || '= 0');
    END IF;
END;

--4. Using database Student Management, write a PL/SQL block to 
--check how many students are enrolled in section id 85. If 15 
--or more students are enrolled, section 85 is full. Otherwise, 
--section 85 is not full. In both cases, a message should be 
--displayed to the user, indicating whether section 85 is full.
DECLARE
  numofStu INT;
BEGIN
  SELECT COUNT(STUDENT_ID) INTO numofStu
  FROM ENROLLMENT
  WHERE SECTION_ID = 85;
  DBMS_OUTPUT.PUT_LINE('SO LUONG SINH VIEN DANG KY: ' || numofStu);
  IF(numofStu>=15) THEN
    DBMS_OUTPUT.PUT_LINE('THIS SECTION IS FULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('THIS SECTION IS NOT FULL');
  END IF;
END;
--5. Do question 4 again using a procedure with 1 parameter: 
--section number. Write a PL/SQL block to call the procedure
--with parameters section 85.
CREATE OR REPLACE PROCEDURE checkSection (secId SECTION.section_id%TYPE)
AS
  numofStu INT;
BEGIN
  SELECT COUNT(STUDENT_ID) INTO numofStu
    FROM ENROLLMENT
    WHERE SECTION_ID = secId;
    DBMS_OUTPUT.PUT_LINE('SO LUONG SINH VIEN DANG KY: ' || numofStu);
    IF(numofStu>=15) THEN
      DBMS_OUTPUT.PUT_LINE('THIS SECTION IS FULL');
    ELSE
      DBMS_OUTPUT.PUT_LINE('THIS SECTION IS NOT FULL');
    END IF;
END;

BEGIN
  checkSection(20);
END;
--6. Use a numeric FOR loop to calculate a factorial of 10 (10! = 
--1*2*3...*10). Write a PL/SQL block.

DECLARE
  x INT := 4;
  kq NUMBER :=1;
BEGIN
  FOR i IN 1..x LOOP
    kq :=kq*i;
END LOOP;
  DBMS_OUTPUT.PUT_LINE ( x || '!= ' || kq);
END;

--7. Write a procedure to calculate the factorial of a number.
--Write a PL/SQL block to call this procedure.
CREATE OR REPLACE PROCEDURE calculateFactorial (x int)
AS
  kq NUMBER := 1;
BEGIN
  FOR i IN 1..x LOOP
    kq :=kq*i;
END LOOP;
  DBMS_OUTPUT.PUT_LINE ( x || '!= ' || kq);
END;

BEGIN
  calculateFactorial(5);
END;
--8. Write a function to calculate the factorial of a 
--number. Write a PL/SQL block to call this function.

CREATE OR REPLACE FUNCTION calFac (x int) RETURN NUMBER
  IS
  kq NUMBER := 1;
BEGIN
  FOR i IN 1..x LOOP
    kq :=kq*i;
END LOOP;
 RETURN kq;
END;

DECLARE
  s NUMBER;
begin
  s := calFac(5);
  DBMS_OUTPUT.PUT_LINE ( 's= ' || s);
end;

--9. Write a procedure to calculate and print out the 
--result of a division. If the denominator is 0 then 
--adding exception. Write a PL/SQL block to call this 
--procedure.
--EXCEPTION
--WHEN ZERO_DIVIDE THEN 
--DBMS_OUTPUT.PUT_LINE ('A number cannot be divided by zero.');
CREATE OR REPLACE PROCEDURE calculateDivision (x int, y int)
AS
  kq NUMBER;
BEGIN
  kq :=x/y;
  DBMS_OUTPUT.PUT_LINE ( 'Ket qua cua phep chia = ' || kq);
EXCEPTION
  WHEN ZERO_DIVIDE THEN
  DBMS_OUTPUT.PUT_LINE ('A number cannot be divided by zero.');
END;

BEGIN
  calculateDivision(10,0);
END;

DECLARE 
  tuso INT:=4;
  mauso INT:=0;
  chia_0 EXCEPTION;
  kq NUMBER;
BEGIN
  IF(mauso=0) THEN
    RAISE chia_0;
    ELSE
      kq:=tuso/mauso;
      DBMS_OUTPUT.PUT_LINE ( 'KQ= ' || kq);
    END IF;
    EXCEPTION
    WHEN chia_0 THEN
      DBMS_OUTPUT.PUT_LINE ( 'KHONG THE CHIA CHO 0 ');
END;
--10.Write a function to calculate the result of a 
--division. Write a PL/SQL block to call this function.
create or replace FUNCTION calDiv (x int, y int) return NUMBER
AS
  kq NUMBER;
BEGIN
  kq :=x/y;
  RETURN kq;
  EXCEPTION
    WHEN ZERO_DIVIDE THEN RETURN NULL;
END;

--execute

DECLARE
  s NUMBER;
begin
  s := calDiv(6,2);
  DBMS_OUTPUT.PUT_LINE ( 's= ' || s);
end;
--11.Using database Student Management, write a procedure 
--to display the student’s name, street_address on the 
--screen. If no record in the STUDENT table 
--corresponds to the value of student_id provided by 
--the user, the exception NO_DATA_FOUND is raised.
--Write a PL/SQL block to call this procedure with 
--parameter is 25, 105.

CREATE OR REPLACE PROCEDURE printStu (stuId STUDENT.STUDENT_ID%TYPE)
AS
  sName VARCHAR2(100);
  sAdd STUDENT.STREET_ADDRESS%TYPE;
BEGIN
  SELECT FIRST_NAME||LAST_NAME, STREET_ADDRESS INTO sName, sAdd
  FROM STUDENT
  WHERE STUDENT_ID= stuId;
  DBMS_OUTPUT.PUT_LINE ( 'Name: '|| sName || 'address: ' || sAdd);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('This student does not exist.');
END;
-- EXECUTE
BEGIN
  printStu(167);
END;

Select * from student;
--12.Do the question 11 using function to return the 
--student’s record (declare a rowtype variable). Write 
--a PL/SQL block to call this function and print out 
--student’s name, address, phone.
CREATE OR REPLACE FUNCTION getStu (stuId STUDENT.STUDENT_ID%TYPE)
  RETURN STUDENT%ROWTYPE
AS
  stu STUDENT%ROWTYPE;
BEGIN
  SELECT * INTO stu
  FROM STUDENT
  WHERE STUDENT_ID= stuId;
    RETURN stu;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;
-- EXECUTE

DECLARE 
  s student%ROWTYPE;
BEGIN
  s := getStu(167);
  dbms_output.put_line(s.first_name || ' ' || s.last_name);
  dbms_output.put_line(s.street_address || ' ' || s.phone);
END;

--13.Write a procedure to check if the student is 
--enrolled. If no record in the ENROLLMENT table 
--corresponds to the value of v_student_id provided by 
--the user, the exception NO_DATA_FOUND is raised. And 
--if more than one record in the ENROLLMENT table then 
--exception TOO_MANY_ROWS is raised.
--Write a pl/sql block to call procedure above with 
--different values of student ID: 102, 103, 319

CREATE OR REPLACE PROCEDURE checkEnroll (stuId STUDENT.STUDENT_ID%TYPE)
AS
  en ENROLLMENT%ROWTYPE;
BEGIN
  SELECT * INTO en
  FROM ENROLLMENT
  WHERE STUDENT_ID= stuId;
  DBMS_OUTPUT.PUT_LINE ( 'sv nay enroll vao duy nhat 1 section ');
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('sv nay chua enroll vao section nao');
  WHEN TOO_MANY_ROWS THEN
  DBMS_OUTPUT.PUT_LINE ('sv nay enroll vao nhieu hon 1 section');
END;
-- EXECUTE
BEGIN
  checkEnroll(319);
END;

--17.Write a function to calculate how many courses that 
--student enrolled. Student_id provided by the user.
--Write a procedure to find name of student and how 
--many courses this user enrolled.
--Write a pl/sql block to call procedure above with 
--different values of student_id: 109, 530
CREATE OR REPLACE FUNCTION getNumofCourse (stuId STUDENT.STUDENT_ID%TYPE) RETURN INT
AS
  x INT;
BEGIN
  SELECT COUNT(COURSE_NO) INTO x
  FROM ENROLLMENT e JOIN SECTION s ON e.section_id = s.section_id 
  WHERE e.student_id = stuId;
  RETURN x;
END;
/
create or replace
PROCEDURE getStudent (stuId STUDENT.STUDENT_ID%TYPE)
AS
  sName VARCHAR2(100);
  x int ;
BEGIN
  SELECT first_name || last_name into sName
  FROM STUDENT 
  WHERE student_id = stuId;
  DBMS_OUTPUT.PUT_LINE ('name of student: ' || sname);
  x := getNumofCourse(stuId);
  DBMS_OUTPUT.PUT_LINE ('name of course enrolled: ' || x);
  EXCEPTION 
  WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('STUDENT NOT FOUND ');
END;
-- EXECUTE
BEGIN
  getStudent(530);
END;