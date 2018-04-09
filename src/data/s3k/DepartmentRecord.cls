 
 /*------------------------------------------------------------------------
    File        : DepartmentRecord
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : k758907
    Created     : Tue Apr 03 09:46:35 CST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS data.s3k.DepartmentRecord: 
    // database table.field
    DEFINE PUBLIC PROPERTY DeptCode AS CHARACTER NO-UNDO GET. SET.
    // database table.field
    DEFINE PUBLIC PROPERTY DeptName AS CHARACTER NO-UNDO GET. SET.
    

END CLASS.