
/*------------------------------------------------------------------------
    File        : IMapper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : k758907
    Created     : Tue Apr 03 11:01:21 CST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING data.shared.IRecord.
USING OpenEdge.Core.Collections.*.

INTERFACE data.shared.IMapper:  

    DEFINE PUBLIC PROPERTY RecordType AS Progress.Lang.Class NO-UNDO 
    GET.

    METHOD PUBLIC VOID Create( INPUT pData AS CLASS IRecord ).
    METHOD PUBLIC VOID Create( INPUT pData AS CLASS ICollection ).

    METHOD PUBLIC VOID Delete( INPUT pData AS CLASS IRecord ).
    METHOD PUBLIC VOID Delete( INPUT pData AS CLASS ICollection ).

    METHOD PUBLIC data.shared.IRecord Get( INPUT pWhere AS CHARACTER  ).

    METHOD PUBLIC OpenEdge.Core.Collections.ICollection GetAll( INPUT pWhere AS CHARACTER ).

    METHOD PUBLIC VOID Update( INPUT pData AS CLASS IRecord ).
    
    METHOD PUBLIC VOID Update( INPUT pData AS CLASS ICollection ).
    
END INTERFACE.