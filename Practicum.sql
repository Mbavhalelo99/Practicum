--Question 1--

CREATE TABLE Instructor 
(
 Ins_ID         NUMBER(4) NOT NULL,
 Ins_FName      VARCHAR2(15) NOT NULL,
 Ins_SName      VARCHAR2(15) NOT NULL,
 Ins_Contact    NUMBER(10) NOT NULL,
 Ins_Level      NUMBER(2) NOT NULL,
 CONSTRAINT Pk_Instructor PRIMARY KEY (Ins_ID)
);

CREATE TABLE Customer 
(
 Cust_ID        VARCHAR2(6) NOT NULL,
 Cust_FName     VARCHAR2(15) NOT NULL,
 Cust_SName     VARCHAR2(15) NOT NULL,
 Cust_Address   VARCHAR2(40) NOT NULL,
 Cust_Contact   NUMBER(10) NOT NULL,
 CONSTRAINT Pk_Customer PRIMARY KEY (Cust_ID)
);

CREATE TABLE Dive 
(
 Dive_ID        NUMBER(10) NOT NULL,
 Dive_Name      VARCHAR2(25) NOT NULL,
 Dive_Duration  VARCHAR2(20) NOT NULL,
 Dive_Location  VARCHAR2(30) NOT NULL,
 Dive_Exp_Level NUMBER(2) NOT NULL,
 Dive_Cost      NUMBER(5) NOT NULL,
 CONSTRAINT Pk_Dive PRIMARY KEY (Dive_ID)
);

CREATE TABLE Dive_Event 
(
 Dive_Event_ID      VARCHAR2(10) NOT NULL,
 Dive_Date          VARCHAR2(12) NOT NULL,
 Dive_Participants  NUMBER(3) NOT NULL,
 Ins_ID             NUMBER(4) NOT NULL,
 Cust_ID            VARCHAR2(6) NOT NULL,
 Dive_ID            NUMBER(10) NOT NULL,
 CONSTRAINT Pk_Dive_Event PRIMARY KEY (Dive_Event_ID),
 CONSTRAINT FK_Instructor FOREIGN KEY(Ins_ID) REFERENCES Instructor(Ins_ID),
 CONSTRAINT FK_Customer FOREIGN KEY(Cust_ID) REFERENCES Customer(Cust_ID),
 CONSTRAINT FK_Dive FOREIGN KEY(Dive_ID) REFERENCES Dive(Dive_ID)
);



INSERT ALL
INTO Instructor VALUES (101,'James','Willis',0843569851,7)
INTO Instructor VALUES (102,'Sam','Wait',0763698521,2)
INTO Instructor VALUES (103,'Sally','Gumede',0786598521,8)
INTO Instructor VALUES (104,'Bob','Du Preez',0796369857,3)
INTO Instructor VALUES (105,'Simon','Jones',0826598741,9)
SELECT * FROM DUAL;

INSERT ALL
INTO Customer VALUES ('C115','Heinrich','Willis','3 Main Road',0821253659)
INTO Customer VALUES ('C116','David','Watson','13 Cape Road',0769658547)
INTO Customer VALUES ('C117','Waldo','Smith','3 Mountain Road',0863256574)
INTO Customer VALUES ('C118','Alex','Hanson','8 Circle Road',0762356587)
INTO Customer VALUES ('C119','Kuhle','Bitterhout','15 Main Road',0821235258)
INTO Customer VALUES ('C120','Thando','Zolani','88 Summer Road',0847541254)
INTO Customer VALUES ('C121','Philip','Jackson','3 Long Road',0745556658)
INTO Customer VALUES ('C122','Sarah','Jonea','7 Sea Road',0814745745)
INTO Customer VALUES ('C123','Catherine','Howard','31 Lake Side Road',08222232521)
SELECT * FROM DUAL;

INSERT ALL
INTO Dive VALUES (550,'Shark Dive','3 hours','Shark Point',8,500)
INTO Dive VALUES (551,'Coral Dive','1 hour','Break Point',7,300)
INTO Dive VALUES (552,'Wave Crescent','2 hours','Ship wreck ally',3,800)
INTO Dive VALUES (553,'Underwater Exploration','1 hour','Coral ally',2,250)
INTO Dive VALUES (554,'Underwater Exploration','3 hours','Sandy Beach',3,750)
INTO Dive VALUES (555,'Deep Blue Ocean','30 minutes','Lazy Wave',2,120)
INTO Dive VALUES (556,'Rough Seas','1 hour','Pipe',9,700)
INTO Dive VALUES (557,'White Water','2 hours','Drifts',5,200)
INTO Dive VALUES (558,'Current Adventure','2 hours','Rock Lands',3,150)
SELECT * FROM DUAL;

INSERT ALL
INTO Dive_Event VALUES ('de_101','15/JUL/17',5,103,'C115',558)
INTO Dive_Event VALUES ('de_102','16/JUL/17',7,102,'C117',555)
INTO Dive_Event VALUES ('de_103','18/JUL/17',8,104,'C118',552)
INTO Dive_Event VALUES ('de_104','19/JUL/17',3,101,'C119',551)
INTO Dive_Event VALUES ('de_105','21/JUL/17',5,104,'C121',558)
INTO Dive_Event VALUES ('de_106','22/JUL/17',8,105,'C120',556)
INTO Dive_Event VALUES ('de_107','25/JUL/17',10,105,'C115',554)
INTO Dive_Event VALUES ('de_108','27/JUL/17',5,101,'C122',552)
INTO Dive_Event VALUES ('de_109','28/JUL/17',3,102,'C123',553)
SELECT * FROM DUAL;

SELECT * FROM Instructor;
SELECT * FROM Customer;
SELECT * FROM Dive;
SELECT * FROM Dive_Event;

--Question 2--

CREATE ROLE admin_role; -- Create administrator role
CREATE USER admin_user IDENTIFIED BY admin_user; -- Create user for administrator
GRANT admin_role TO admin_user; -- Grant administrator role to the user

GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO admin_role; -- Grant privileges to manage schema objects
GRANT INSERT, UPDATE, DELETE ON Instructor, Customer, Dive, Dive_Event TO admin_role; -- Grant privileges to insert, update, delete data
GRANT CREATE USER, ALTER USER, DROP USER, CREATE ROLE, DROP ROLE TO admin_role;  -- Grant privileges to manage users and roles
GRANT SELECT ANY TABLE TO admin_role;  -- Grant necessary system privileges


CREATE ROLE user_role;  -- Create general user role
CREATE USER general_user IDENTIFIED BY password;  -- Create user for general user
GRANT user_role TO general_user;  -- Grant general user role to the user

-- Grant privileges to select data
GRANT SELECT ON Instructor TO user_role;
GRANT SELECT ON Customer TO user_role;
GRANT SELECT ON Dive TO user_role;
GRANT SELECT ON Dive_Event TO user_role;

GRANT EXECUTE ON <procedure_name> TO user_role;  -- Grant privileges to execute procedures or functions, if applicable
GRANT SELECT, INSERT, UPDATE ON <table_name> TO user_role;  -- Grant usage privileges on necessary objects


--Question 3--

SELECT
    i.Ins_FName ||' '|| i.Ins_SName AS Instructor_Name,
    c.Cust_FName|| ' '||c.Cust_SName AS Customer_Name,
    d.Dive_Location,
    de.Dive_Participants
FROM
    Dive_Event DE
    JOIN Instructor i ON de.Ins_ID = i.Ins_ID
    JOIN Customer c ON de.Cust_ID = c.Cust_ID
    JOIN Dive d ON de.Dive_ID = d.Dive_ID
WHERE
    de.Dive_Participants BETWEEN 8 AND 10;

--Question 4--

SET SERVEROUTPUT ON; 
 
-- Declaring variables
DECLARE
    v_dive_name Dive.Dive_Name%TYPE;
    v_allocation_date Dive_Event.Dive_Date%TYPE;
    v_participants Dive_Event.Dive_Participants%TYPE;
BEGIN
    -- Creating a Cursor to fetch dive events with 10 or more participants
    FOR event IN (
        SELECT Dive.Dive_Name, Dive_Event.Dive_Date, Dive_Event.Dive_Participants
        FROM Dive_Event
        JOIN Dive ON Dive_Event.Dive_ID = Dive.Dive_ID
        WHERE Dive_Event.Dive_Participants >= 10
    )
    LOOP
        -- Assigning cursor values to variables
        v_dive_name := event.Dive_Name;
        v_allocation_date := event.Dive_Date;
        v_participants := event.Dive_Participants;
        
        --To Display dive name, allocation date, and number of participants
        DBMS_OUTPUT.PUT_LINE('DIVE NAME: ' || v_dive_name);
        DBMS_OUTPUT.PUT_LINE('DIVE DATE: ' || v_allocation_date);
        DBMS_OUTPUT.PUT_LINE('PARTICIPANTS: ' || v_participants);
        DBMS_OUTPUT.PUT_LINE('---------------------------');
    END LOOP;
END;
/

--Question 5--

-- Declare variables
DECLARE
    v_cust_name VARCHAR2(30);
    v_dive_name VARCHAR2(25);
    v_participants NUMBER(3);
    v_instructors_needed NUMBER(1); -- According to maximum of 3 instructors as per policy
BEGIN
    --  Creating a Cursor to fetch dive events with cost over 500 and required details
    FOR new_policy IN (
        SELECT Cust.Cust_FName || ' ' || Cust.Cust_SName AS Customer_Name,
               Dive.Dive_Name,
               DE.Dive_Participants,
               CASE
                   WHEN DE.Dive_Participants <= 4 THEN 1
                   WHEN DE.Dive_Participants <= 7 THEN 2
                   ELSE 3
               END AS Instructors_Needed
        FROM Dive_Event DE
        JOIN Customer Cust ON DE.Cust_ID = Cust.Cust_ID
        JOIN Dive ON DE.Dive_ID = Dive.Dive_ID
        WHERE Dive.Dive_Cost > 500
    )
    LOOP
        -- Assign cursor values to variables
        v_cust_name := new_policy.Customer_Name;
        v_dive_name := new_policy.Dive_Name;
        v_participants := new_policy.Dive_Participants;
        v_instructors_needed := new_policy.Instructors_Needed;
        
        -- Displaying dive event details
        DBMS_OUTPUT.PUT_LINE('CUSTOMER: ' || v_cust_name);
        DBMS_OUTPUT.PUT_LINE('DIVE NAME: ' || v_dive_name);
        DBMS_OUTPUT.PUT_LINE('PARTICIPANTS: ' || v_participants);
        DBMS_OUTPUT.PUT_LINE('STATUS: ' || v_instructors_needed);
        DBMS_OUTPUT.PUT_LINE('--------------------------------');
    END LOOP;
END;
/

--Question 6--

-- Create or replace the view Vw_Dive_Event
CREATE OR REPLACE VIEW Vw_Dive_Event AS
SELECT DE.Ins_ID, DE.Cust_ID, C.Cust_Address, D.Dive_Duration, DE.Dive_Date
FROM Dive_Event DE
JOIN Customer C ON DE.Cust_ID = C.Cust_ID
JOIN Dive D ON DE.Dive_ID = D.Dive_ID
WHERE TO_DATE(DE.Dive_Date, 'DD/MON/YY') < TO_DATE('19/JUL/17', 'DD/MON/YY');

SELECT * FROM Vw_Dive_Event;

--Question 7--

-- Creating the trigger New_Dive_Event

CREATE OR REPLACE TRIGGER New_Dive_Event
BEFORE INSERT ON Dive_Event
FOR EACH ROW
DECLARE
    v_participants NUMBER;
BEGIN
    
    v_participants := :NEW.Dive_Participants;

    
    IF v_participants <= 0 OR v_participants > 20 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Participants must be between 1 and 20.');
    END IF;
END;
/

-- 0 Participants Test This should raise an error
INSERT INTO Dive_Event (Dive_Event_ID, Dive_Date, Dive_Participants, Ins_ID, Cust_ID, Dive_ID)
VALUES ('de_test_1', '01/JAN/2024', 0, 101, 'C115', 550);

-- 21 PArticipants Test This should raise an error
INSERT INTO Dive_Event (Dive_Event_ID, Dive_Date, Dive_Participants, Ins_ID, Cust_ID, Dive_ID)
VALUES ('de_test_2', '02/JAN/2024', 21, 102, 'C116', 551);

-- 10 Participants Test This should succeed
INSERT INTO Dive_Event (Dive_Event_ID, Dive_Date, Dive_Participants, Ins_ID, Cust_ID, Dive_ID)
VALUES ('de_test_3', '03/JAN/2024', 10, 103, 'C117', 552);

--Question 8--

CREATE OR REPLACE PROCEDURE sp_Customer_Details (
    p_Cust_ID IN Customer.Cust_ID%TYPE,
    p_Dive_Date IN Dive_Event.Dive_Date%TYPE
) 
IS
    no_data_found EXCEPTION;
    invalid_date_format EXCEPTION;
    
    BEGIN
        TO_DATE(p_Dive_Date, 'DD/MON/YY');
    EXCEPTION
        WHEN OTHERS THEN
            RAISE invalid_date_format;
    END;
    FOR rec IN (
        SELECT c.Cust_FName, c.Cust_SName, d.Dive_Name
        FROM Customer c
        JOIN Dive_Event de ON c.Cust_ID = de.Cust_ID
        JOIN Dive d ON de.Dive_ID = d.Dive_ID
        WHERE c.Cust_ID = p_Cust_ID
          AND de.Dive_Date = p_Dive_Date
    ) LOOP
        
        DBMS_OUTPUT.PUT_LINE('Customer: ' || rec.Cust_FName || ' ' || rec.Cust_SName || ' booked for ' ||rec.Dive_Name|| ' on the ' ||rec.Dive_Date);
        DBMS_OUTPUT.PUT_LINE('Dive: ' || rec.Dive_Name);
        RETURN; 
    END LOOP;

    
    RAISE no_data_found;

EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('No booking found for customer ID ' || p_Cust_ID || ' on ' || p_Dive_Date);
    WHEN invalid_date_format THEN
        DBMS_OUTPUT.PUT_LINE('Invalid date format. Please enter the date in DD/MON/YY format.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END sp_Customer_Details;
/

-- Execute the procedure with valid inputs
BEGIN
    sp_Customer_Details('C115', '15/JUL/17');
END;
/

-- Execute the procedure with an invalid customer ID
BEGIN
    sp_Customer_Details('C999', '15/JUL/17');
END;
/

-- Execute the procedure with an invalid date format
BEGIN
    sp_Customer_Details('C115', '15-07-17');
END;
/


--Question 9--

CREATE OR REPLACE FUNCTION fn_Total_Dive_Cost (
    p_Cust_ID IN Customer.Cust_ID%TYPE
) 
RETURN NUMBER 
IS
    v_Total_Cost NUMBER := 0;
    invalid_customer EXCEPTION;
BEGIN
    -- Calculate the total dive cost for the given customer ID
    SELECT SUM(d.Dive_Cost)
    INTO v_Total_Cost
    FROM Dive d
    JOIN Dive_Event de ON d.Dive_ID = de.Dive_ID
    WHERE de.Cust_ID = p_Cust_ID;

    -- Check if no cost was found (i.e., customer ID not found)
    IF v_Total_Cost IS NULL THEN
        RAISE invalid_customer;
    END IF;

    RETURN v_Total_Cost;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No dive events found for customer ID ' || p_Cust_ID);
        RETURN 0;
    WHEN invalid_customer THEN
        DBMS_OUTPUT.PUT_LINE('Customer ID ' || p_Cust_ID || ' is not valid.');
        RETURN 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
        RETURN 0;
END fn_Total_Dive_Cost;
/


-- Execute the function with a valid customer ID and display the result
DECLARE
    v_Total_Cost NUMBER;
BEGIN
    v_Total_Cost := fn_Total_Dive_Cost('C115');
    DBMS_OUTPUT.PUT_LINE('Total dive cost for customer C115: ' || v_Total_Cost);
END;
/

-- Execute the function with an invalid customer ID and display the result
DECLARE
    v_Total_Cost NUMBER;
BEGIN
    v_Total_Cost := fn_Total_Dive_Cost('C999');
    DBMS_OUTPUT.PUT_LINE('Total dive cost for customer C999: ' || v_Total_Cost);
END;
/

--Question 10--


















