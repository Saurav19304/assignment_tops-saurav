SELECT * FROM hr.employee;
select EMP_NAME , EMP_ID ,
concat_ws(" ",EMP_ID,EMP_NAME) as EMPLOYEETITLE FROM EMPLOYEE ;