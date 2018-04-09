 
 /*------------------------------------------------------------------------
    File        : BufferMapper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : k758907
    Created     : Tue Apr 03 12:01:40 CST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Reflect.AccessMode.
USING Progress.Reflect.Flags.
USING Progress.Reflect.Property.
USING data.shared.IMapper.
USING data.shared.IRecord.
USING OpenEdge.Core.Collections.*.


BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS data.shared.BufferMapper IMPLEMENTS IMapper: 
    // what type of IRecord should we create
    DEFINE PUBLIC PROPERTY RecordType AS Progress.Lang.Class NO-UNDO 
    GET.
    PROTECTED  SET (INPUT pType AS CLASS Progress.Lang.Class):
        IF pType:IsA(GET-CLASS(IRecord)) THEN 
            ASSIGN THIS-OBJECT:RecordType = pType.
    END METHOD.
     
    // the underlying buffer. 
    DEFINE PROTECTED PROPERTY DataBuffer AS HANDLE NO-UNDO GET. PRIVATE SET. 
     
     

    METHOD PUBLIC VOID Create( INPUT pData AS IRecord ):
        DEFINE VARIABLE props AS PROPERTY EXTENT NO-UNDO.
        DEFINE VARIABLE cnt AS INTEGER NO-UNDO.
        DEFINE VARIABLE loop AS INTEGER NO-UNDO.
        DEFINE VARIABLE fld AS HANDLE NO-UNDO.
        
        DO TRANSACTION:
            THIS-OBJECT:DataBuffer:BUFFER-CREATE().
            
            props = THIS-OBJECT:RecordType:GetProperties((FLAGS:PUBLIC OR FLAGS:Instance)).
            cnt = EXTENT(props).
            DO loop = 1 TO cnt:
                IF NOT props[loop]:GetterAccessMode = AccessMode:PUBLIC THEN 
                    NEXT. 
                
                // assumes no arrays, names are identical
                ASSIGN fld = THIS-OBJECT:DataBuffer:BUFFER-FIELD(props[loop]:Name) NO-ERROR.
                IF VALID-HANDLE(fld) THEN 
                    ASSIGN fld:BUFFER-VALUE = DYNAMIC-PROPERTY(pData, props[loop]:Name).
            END.
            FINALLY:
                THIS-OBJECT:DataBuffer:BUFFER-RELEASE().
                fld = ?.
            END FINALLY.
                       
        END.
        
    END METHOD.

    METHOD PUBLIC VOID Create( INPUT pData AS CLASS ICollection ):
        DEFINE VARIABLE props AS 
        
    END METHOD.


    METHOD PUBLIC VOID Delete( INPUT pData AS CLASS IRecord ):
       DO TRANSACTION:
           THIS-OBJECT:DataBuffer:FIND-FIRST(SUBSTITUTE('where &1.&2 = "&3"',
                                             THIS-OBJECT:DataBuffer:NAME,
                                             THIS-OBJECT:DataBuffer:KEYS),
                                             EXCLUSIVE-LOCK).
           THIS-OBJECT:DataBuffer:BUFFER-DELETE().
           FINALLY:
            THIS-OBJECT:DataBuffer:BUFFER-RELEASE().
           END FINALLY.
       END. // trans
    END METHOD.

    METHOD PUBLIC data.shared.IRecord Get( INPUT pWhere AS CHARACTER ):
        DEFINE VARIABLE data AS IRecord NO-UNDO.
        DEFINE VARIABLE props AS PROPERTY EXTENT NO-UNDO.
        DEFINE VARIABLE cnt AS INTEGER NO-UNDO.
        DEFINE VARIABLE loop AS INTEGER NO-UNDO.
        DEFINE VARIABLE fld AS HANDLE NO-UNDO.
        
        THIS-OBJECT:DataBuffer:FIND-FIRST(pWhere, NO-LOCK).
        
        data = CAST(THIS-OBJECT:RecordType:New(), IRecord).
        props = THIS-OBJECT:RecordType:GetProperties((FLAGS:PUBLIC OR FLAGS:Instance)).
        cnt = EXTENT(props).
        DO loop = 1 TO cnt:
            IF NOT props[loop]:SetterAccessMode = AccessMode:PUBLIC THEN
                NEXT.
            
            ASSIGN fld = THIS-OBJECT:DataBuffer:BUFFER-FIELD(props[loop]:Name) NO-ERROR.
            IF VALID-HANDLE(fld) THEN 
                DYNAMIC-PROPERTY(data, props[loop]:Name) = THIS-OBJECT:DataBuffer:BUFFER-FIELD(props[loop]:Name):Buffer-Value.
        END.
        
        RETURN data.
        FINALLY:
            fld = ?.
        END FINALLY.
    END METHOD.


    METHOD PUBLIC OpenEdge.Core.Collections.ICollection GetAll(  ):
        
        DEFINE VARIABLE recordCollection AS OpenEdge.Core.Collections.ICollection NO-UNDO.
        DEFINE VARIABLE record AS IRecord NO-UNDO.
        DEFINE VARIABLE dataQuery AS HANDLE NO-UNDO.
        DEFINE VARIABLE props AS PROPERTY  EXTENT NO-UNDO.  /*???  Property type */
        DEFINE VARIABLE cnt AS INTEGER NO-UNDO.
        DEFINE VARIABLE loop AS INTEGER NO-UNDO.
        
        CREATE QUERY dataQuery.
        dataQuery:SET-BUFFERS (THIS-OBJECT:DataBuffer).
        dataQuery:QUERY-PREPARE (SUBSTITUTE('for each &1 where &2 no-lock',
                                            THIS-OBJECT:DataBuffer,
                                            pWhere)).
        dataQuery:QUERY-OPEN ().
        
        recordCollection = CAST(THIS-OBJECT:RecordType:New(), ICollection).
        
        dataQuery:GET-FIRST ().
        DO WHILE NOT dataQuery:QUERY-OFF-END:
            record = CAST(THIS-OBJECT:RecordType:New(),IRecord).
            props = THIS-OBJECT:RecordType:GetProperties((FLAGS:PUBLIC OR FLAGS:Instance)).
            cnt = EXTENT(props).
            DO loop = 1 TO cnt:
                IF NOT props[loop]:SetterAccessMode = AccessMode:PUBLIC THEN 
                    NEXT.    /* 属性的设置模式不能是公开的(public) */
                
                ASSIGN fld = THIS-OBJECT:DataBuffer:BUFFER-FIELD(props[loop]:NAME) NO-ERROR.
                IF VALID-HANDLE(fld) THEN 
                     DYNAMIC-PROPERTY(record, props[loop]:Name) = THIS-OBJECT:DataBuffer:BUFFER-FIELD(props[loop]:Name):Buffer-value.
            END.
            //
            recordCollection:add(record).   // Add one record to collection */
            dataQuery:GET-NEXT ().  
        END.
        
        FINALLY:
            THIS-OBJECT:DataBuffer:BUFFER-RELEASE().
            fld = ?.
            RETURN recordCollection.      
        END FINALLY.

    END METHOD.

    METHOD PUBLIC VOID Update( INPUT pData AS IRecord ):
        DEFINE VARIABLE props AS PROPERTY EXTENT NO-UNDO.
        DEFINE VARIABLE cnt AS INTEGER NO-UNDO.
        DEFINE VARIABLE loop AS INTEGER NO-UNDO.
        DEFINE VARIABLE fld AS HANDLE NO-UNDO.
        
        DO TRANSACTION:
            THIS-OBJECT:DataBuffer:FIND-FIRST(SUBSTITUTE('where &1.&2 = "&3"',
                                               THIS-OBJECT:DataBuffer:NAME,
                                               THIS-OBJECT:DataBuffer:KEYS),
                                   EXCLUSIVE-LOCK).
             props = THIS-OBJECT:RecordType:GetProperties((FLAGS:PUBLIC OR FLAGS:Instance)).
             cnt = EXTENT(props).    
             DO loop = 1 TO cnt:
                 IF NOT props[loop]:GetterAccessMode = AccessMode:PUBLIC THEN 
                    NEXT.
                 
                  ASSIGN fld = THIS-OBJECT:DataBuffer:BUFFER-FIELD(props[loop]:NAME) NO-ERROR.
                  IF VALID-HANDLE(fld) THEN 
                    ASSIGN fld:BUFFER-VALUE () = DYNAMIC-PROPERTY(pData,props[loop]:NAME).  
             END.
             FINALLY:
                 THIS-OBJECT:DataBuffer:BUFFER-RELEASE().
                 fld = ?.
             END FINALLY.
        END.  //trans
        
    END METHOD.

    /*  Constructor
        @param handle The table buffer
        @param Progress.Lang.Class The type of the record should create
    */
    CONSTRUCTOR PUBLIC BufferMapper ( INPUT pBuffer AS HANDLE,
                                      INPUT pRecordType AS CLASS Progress.Lang.Class ):
        ASSIGN THIS-OBJECT:DataBuffer = pBuffer
               THIS-OBJECT:RecordType = pRecordType
               .
        
    END CONSTRUCTOR.

END CLASS.