 
 /*------------------------------------------------------------------------
    File        : DepartmentMapper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : k758907
    Created     : Tue Apr 03 10:18:02 CST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING data.s3k.DepartmentRecord.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS data.s3k.DepartmentMapper: 
    /*------------------------------------------------------------------------------
     Purpose: Read from persistent store/database
     Notes:
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC data.s3k.DepartmentRecord Get( INPUT pWhere AS CHARACTER ):
        DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.
        DEFINE VARIABLE hField  AS HANDLE NO-UNDO.
        //get buffer.
        MESSAGE "pWehere is: " + pWhere VIEW-AS ALERT-BOX.
        
/*        hBuffer = BUFFER Department:HANDLE.                                  */
/*        hBuffer:FIND-FIRST(pWhere, NO-LOCK).                                 */
/*                                                                             */
/*        MESSAGE "Get data into buffer" VIEW-AS ALERT-BOX .                   */
/*        DEFINE VARIABLE dept AS CLASS DepartmentRecord NO-UNDO.              */
/*                                                                             */
/*        ASSIGN dept = NEW DepartmentRecord().                                */
/*        hField = hBuffer:BUFFER-FIELD ("DeptCode").                          */
/*        MESSAGE hField:LABEL VIEW-AS ALERT-BOX.                              */
/*        ASSIGN dept:DeptCode = hField:BUFFER-VALUE ()/*Department.DeptCode*/.*/
/*        hField = hBuffer:BUFFER-FIELD ("DeptName").                          */
/*        MESSAGE hField:LABEL VIEW-AS ALERT-BOX.                              */
/*        ASSIGN dept:DeptName = hField:BUFFER-VALUE()/*Department.DeptName*/. */
        
        /* Solution 2*/
        BUFFER Department:FIND-FIRST (pWhere, NO-LOCK).
        DEFINE VARIABLE dept AS CLASS DepartmentRecord NO-UNDO.
        
        ASSIGN dept = NEW DepartmentRecord().
        ASSIGN dept:DeptCode = Department.DeptCode
               dept:DeptName = Department.DeptName. 

        RETURN dept.
                
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC data.s3k.DepartmentRecord Create( INPUT dept AS CLASS DepartmentRecord ):
        
        CREATE oocase.Department.
        ASSIGN oocase.Department.DeptCode = dept:DeptCode
               oocase.Department.DeptName = dept:DeptName.

    END METHOD.


END CLASS.