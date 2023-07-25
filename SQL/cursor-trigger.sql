--3. Write a PL/SQL block with two cursor for loops. The parent cursor will call the employee_id, name, 
--salary from the employee table and output one line with this information. For each employee, the child 
--cursor will loop through all the employee_change and outputting the salary, title of this employee.
DECLARE
    CURSOR emp IS SELECT * FROM EMPLOYEE;
    CURSOR emp_change (stuid EMPLOYEE.EMPLOYEE_ID%TYPE) 
    IS
            SELECT e.*
            FROM EMPLOYEE_CHANGE e
            WHERE ec.EMPLOYEE_ID = STUID;
BEGIN
    FOR empp IN emp LOOP
            DBMS_OUTPUT.PUT_LINE('employeeId: ' || empp.EMPLOYEE_ID
                                || ' name: ' || empp.NAME || empp.SALARY);
             FOR empp_c IN emp_change(empp.EMPLOYEE_ID) LOOP
                    DBMS_OUTPUT.PUT_LINE('salary' || empp_c.SALARY
                                        || ' title: ' || empp_c.TITLE);
            END LOOP;
        END LOOP;
END;

--4. Write a trigger: When inserting or updating data of employee_change table, title of employee is always 
--converted to lowercase letter.Write two statements to insert and update data of employee_change table
CREATE OR REPLACE TRIGGER ToLowerCaseTitle
BEFORE INSERT OR UPDATE ON EMPLOYEE_CHANGE
FOR EACH ROW
BEGIN
    CASE    
    WHEN INSERTING THEN
        :NEW.TITLE := LOWER(:NEW.TITLE);
    WHEN UPDATING('TITLE') THEN
        :NEW.TITLE := LOWER(:NEW.TITLE);
    END CASE;
END;
/
INSERT INTO EMPLOYEE_CHANGE (EMPLOYEE_ID, NAME, SALARY, TITLE) VALUES (500,'Katy', 10000, 'QA/QC');
UPDATE EMPLOYEE_CHANGE SET TITLE='TESTER' WHERE EMPLOYEE_ID=500;
SELECT * FROM EMPLOYEE_CHANGE;
