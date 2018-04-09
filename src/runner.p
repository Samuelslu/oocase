
/*------------------------------------------------------------------------
    File        : runner.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : k758907
    Created     : Tue Apr 03 09:54:26 CST 2018
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
USING data.s3k.*.

DEFINE VARIABLE dept AS DepartmentRecord . 
DEFINE VARIABLE deptMapper AS DepartmentMapper.


/*DEFINE BUFFER localDep FOR oocase.Department.*/

/*FIND FIRST Department.*/

ASSIGN 
       deptMapper = NEW DepartmentMapper()
       dept = deptMapper:Get("WHERE DeptCode = " + QUOTER(100)).
       
       
// application/business logic does stuff       
MESSAGE dept:DeptCode
        dept:DeptName.
ASSIGN dept:DeptName = "Department of One Hundred".
//write any changes back to db
/*FIND FIRST oocase.Department WHERE oocase.Department.DeptCode EQ dept:DeptCode EXCLUSIVE-LOCK.*/
/*IF AVAILABLE oocase.Department THEN                                                           */
/*    ASSIGN oocase.Department.DeptName = dept:DeptName.                                        */
/*RELEASE oocase.Department.                                                                    */
