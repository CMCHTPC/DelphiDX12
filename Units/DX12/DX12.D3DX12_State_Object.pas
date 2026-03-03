unit DX12.D3DX12_State_Object;

{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}


interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12,
    CStdVector,
    CStdList;

    {$DEFINE D3D12_SDK_VERSION_612}

    //================================================================================================
    // D3DX12 State Object Creation Helpers
    // Helper classes for creating new style state objects out of an arbitrary set of subobjects.
    // Uses STL
    // Start by instantiating CD3DX12_STATE_OBJECT_DESC (see its public methods).
    // One of its methods is CreateSubobject(), which has a comment showing a couple of options for
    // defining subobjects using the helper classes for each subobject (CD3DX12_DXIL_LIBRARY_SUBOBJECT
    // etc.). The subobject helpers each have methods specific to the subobject for configuring its
    // contents.
    //================================================================================================

type

    { TSUBOBJECT_WRAPPER }

    TSUBOBJECT_WRAPPER = record
        SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE;
        pDesc: Pvoid;
        {_In_reads_(NumSubobjects)  } pSubobjects: PD3D12_STATE_SUBOBJECT_ARRAY;
        // ------
        pSubobjectArrayLocation: PD3D12_STATE_SUBOBJECT; // new location when flattened into array for repointing pointers in subobjects
        class operator Explicit(o: TSUBOBJECT_WRAPPER): TD3D12_STATE_SUBOBJECT;
    end;
    PSUBOBJECT_WRAPPER = ^TSUBOBJECT_WRAPPER;


    { TStringContainer }

    generic TStringContainer<CStr, StdStr> = class
    private
        m_String: specialize TCStdList<StdStr>;
    public
        procedure Clear;
        function LocalCopy(AString: CStr; bSingleString: boolean = False): CStr;
    end;


    TSUBOBJECT_HELPER_BASE = class;
    { TD3DX12_STATE_OBJECT_DESC }
    TD3DX12_STATE_OBJECT_DESC = class(TObject)
    private
        FSubObjectHelper: TSUBOBJECT_HELPER_BASE;
        m_Desc: TD3D12_STATE_OBJECT_DESC;
        m_SubobjectArray: specialize TCStdVector<TD3D12_STATE_SUBOBJECT>; // Built at the end, copying list contents

        m_SubobjectList: specialize TCStdList<TSUBOBJECT_WRAPPER>; // Pointers to list nodes handed out so
        // these can be edited live

        m_RepointedAssociations: specialize TCStdList<TD3D12_SUBOBJECT_TO_EXPORTS_ASSOCIATION>; // subobject type that contains pointers to other subobjects,
        // repointed to flattened array
        {$IFDEF D3D12_SDK_VERSION_612}
        m_RepointedPrograms: specialize TCStdList<TD3D12_GENERIC_PROGRAM_DESC>;

        m_RepointedSubobjectVectors: specialize TCStdList<specialize TCStdVector<PD3D12_STATE_SUBOBJECT>>;
        {$ENDIF}
    private
        procedure Init(ObjectType: TD3D12_STATE_OBJECT_TYPE);
        function TrackSubobject(SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE; pDesc: pointer): PSUBOBJECT_WRAPPER;
    public
        constructor Create();
        constructor Create(ObjectType: TD3D12_STATE_OBJECT_TYPE);
        procedure SetStateObjectType(ObjectType: TD3D12_STATE_OBJECT_TYPE);
    end;


    { TSUBOBJECT_HELPER_BASE }

    TSUBOBJECT_HELPER_BASE = class(TObject)
    protected
        m_pSubobject: PD3D12_STATE_SUBOBJECT;
        procedure Init(); virtual;
        function Data(): Pointer; virtual; abstract;
    public
        constructor Create;
        destructor Destroy; override;
        procedure AddToStateObject(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
        function SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE; virtual; abstract;
    end;

    { TD3DX12_DXIL_LIBRARY_SUBOBJECT }

    TD3DX12_DXIL_LIBRARY_SUBOBJECT = class(TSUBOBJECT_HELPER_BASE)
    protected
        m_Desc: TD3D12_DXIL_LIBRARY_DESC;
        m_Exports: specialize TCStdVector<TD3D12_EXPORT_DESC>;
        procedure Init; override;
        function Data(): Pointer;
    public
        constructor Create();
        constructor Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);

        procedure SetDXILLibrary(pCode: PD3D12_SHADER_BYTECODE);
        procedure DefineExport(Name: widestring; ExportToRename: widestring = ''; Flags: TD3D12_EXPORT_FLAGS = D3D12_EXPORT_FLAG_NONE);

        procedure DefineExports(StringExports: PWideString; N: UINT);
        function SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE; override;
    end;

    { TD3DX12_EXISTING_COLLECTION_SUBOBJECT }

    TD3DX12_EXISTING_COLLECTION_SUBOBJECT = class(TSUBOBJECT_HELPER_BASE)
    protected
        m_Desc: TD3D12_EXISTING_COLLECTION_DESC;
        m_CollectionRef: ID3D12StateObject;
        m_Exports: specialize TCStdVector<TD3D12_EXPORT_DESC>;

        procedure Init; override;
        function Data(): Pointer;
    public
        constructor Create();
        constructor Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
        procedure SetExistingCollection(pExistingCollection: ID3D12StateObject);
        procedure DefineExport(Name: widestring; ExportToRename: widestring = ''; Flags: TD3D12_EXPORT_FLAGS = D3D12_EXPORT_FLAG_NONE);
        procedure DefineExports(StringExports: PWideString; N: UINT);
        function SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE; override;
    end;

    { TD3DX12_SUBOBJECT_TO_EXPORTS_ASSOCIATION_SUBOBJECT }

    TD3DX12_SUBOBJECT_TO_EXPORTS_ASSOCIATION_SUBOBJECT = class(TSUBOBJECT_HELPER_BASE)
    protected
        m_Desc: TD3D12_SUBOBJECT_TO_EXPORTS_ASSOCIATION;
        m_Exports: specialize TCStdVector<widestring>;
    protected
        procedure Init; override;
        function Data(): Pointer;
    public
        constructor Create();
        constructor Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
        procedure SetSubobjectToAssociate(SubobjectToAssociate: PD3D12_STATE_SUBOBJECT);
        procedure AddExport(Export: widestring);
        procedure AddExports(StringExports: PWideString; N: UINT);
        function SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE; override;
    end;


    { TD3DX12_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION }

    TD3DX12_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION = class(TSUBOBJECT_HELPER_BASE)
    protected
        m_Desc: TD3D12_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION;
        m_Exports: specialize TCStdVector<widestring>;
    protected
        procedure Init; override;
        function Data(): Pointer;
    public
        constructor Create();
        constructor Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
        procedure SetSubobjectNameToAssociate(SubobjectToAssociate: widestring);
        procedure AddExport(Export: widestring);
        procedure AddExports(StringExports: PWideString; N: UINT);
        function SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE; override;
    end;

    { TD3DX12_HIT_GROUP_SUBOBJECT }

    TD3DX12_HIT_GROUP_SUBOBJECT = class(TSUBOBJECT_HELPER_BASE)
    protected
    const
        m_NumStrings = 4;
    protected
        m_Desc: TD3D12_HIT_GROUP_DESC;
        m_Strings: array [0..m_NumStrings - 1] of specialize TStringContainer<LPCWSTR, unicodestring>; // one string for every entrypoint name
    protected
        procedure Init; override;
        function Data(): Pointer;
    public
        constructor Create();
        constructor Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
        procedure SetHitGroupExport(exportName: widestring);
        procedure SetHitGroupType(GroupeType: TD3D12_HIT_GROUP_TYPE);
        procedure SetAnyHitShaderImport(importName: widestring);
        procedure SetClosestHitShaderImport(importName: widestring);
        procedure SetIntersectionShaderImport(importName: widestring);
        function SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE; override;
    end;


    { TD3DX12_RAYTRACING_SHADER_CONFIG_SUBOBJECT }

    TD3DX12_RAYTRACING_SHADER_CONFIG_SUBOBJECT = class(TSUBOBJECT_HELPER_BASE)
    protected
        m_Desc: TD3D12_RAYTRACING_SHADER_CONFIG;
    protected
        procedure Init; override;
        function Data(): Pointer;
    public
        constructor Create();
        constructor Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
        constructor Create(desc: PD3D12_RAYTRACING_SHADER_CONFIG);
        constructor Create(desc: PD3D12_RAYTRACING_SHADER_CONFIG; ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
        function SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE; override;
        procedure Config(MaxPayloadSizeInBytes, MaxAttributeSizeInBytes: UINT);
    end;


    { TD3DX12_RAYTRACING_PIPELINE_CONFIG_SUBOBJECT }

    TD3DX12_RAYTRACING_PIPELINE_CONFIG_SUBOBJECT = class(TSUBOBJECT_HELPER_BASE)
    protected
        m_Desc: TD3D12_RAYTRACING_PIPELINE_CONFIG;
    protected
        procedure Init; override;
        function Data(): Pointer;
    public
        constructor Create();
        constructor Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
        constructor Create(desc: PD3D12_RAYTRACING_PIPELINE_CONFIG);
        constructor Create(desc: PD3D12_RAYTRACING_PIPELINE_CONFIG; ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
        function SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE; override;
        procedure Config(MaxTraceRecursionDepth: UINT);
    end;

    { TD3DX12_WORK_GRAPH_SUBOBJECT }

    TD3DX12_WORK_GRAPH_SUBOBJECT = class(TSUBOBJECT_HELPER_BASE)
    public
        constructor Create;
        constructor Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
        function SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE; override;
        procedure IncludeAllAvailableNodes();
        procedure SetProgramName(ProgramName: LPCWSTR);
        procedure AddEntrypoint(Entrypoint: TD3D12_NODE_ID);
    end;


implementation

uses
    DX12.D3DX12_Core;

    { TSUBOBJECT_WRAPPER }

class operator TSUBOBJECT_WRAPPER.Explicit(o: TSUBOBJECT_WRAPPER): TD3D12_STATE_SUBOBJECT;
begin
    Result.SubObjectType := o.SubObjectType;
    Result.pDesc := o.pDesc;
end;

{ TStringContainer }

procedure TStringContainer.Clear;
begin
    m_String.Clear();
end;



function TStringContainer.LocalCopy(AString: CStr; bSingleString: boolean): CStr;
begin
    if (Astring <> '') then
    begin
        if (bSingleString) then
        begin
            m_String.Clear();
            m_String.push_back(AString);
        end
        else
        begin
            m_String.push_back(Astring);
        end;
        Result := CStr(m_String.back());
    end
    else
    begin
        Result := nil;
    end;
end;

{ TD3DX12_STATE_OBJECT_DESC }

procedure TD3DX12_STATE_OBJECT_DESC.Init(ObjectType: TD3D12_STATE_OBJECT_TYPE);
begin
    SetStateObjectType(ObjectType);
    m_Desc.pSubobjects := nil;
    m_Desc.NumSubobjects := 0;
    m_SubobjectList.Clear();
    m_SubobjectArray.Clear();
    m_RepointedAssociations.Clear();
    {$IFDEF D3D12_SDK_VERSION_612}
    m_RepointedSubobjectVectors.Clear();
    m_RepointedPrograms.Clear();
    {$ENDIF}
end;



function TD3DX12_STATE_OBJECT_DESC.TrackSubobject(SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE; pDesc: pointer): PSUBOBJECT_WRAPPER;
var
    Subobject: TSUBOBJECT_WRAPPER;
begin
    Subobject.pSubobjectArrayLocation := nil;
    Subobject.SubObjectType := SubObjectType;
    Subobject.pDesc := pDesc;
    m_SubobjectList.push_back(Subobject);
    m_Desc.NumSubobjects := m_Desc.NumSubobjects + 1;
    Result := m_SubobjectList.back();
end;



constructor TD3DX12_STATE_OBJECT_DESC.Create();
begin
    Init(D3D12_STATE_OBJECT_TYPE_COLLECTION);
end;



constructor TD3DX12_STATE_OBJECT_DESC.Create(ObjectType: TD3D12_STATE_OBJECT_TYPE);
begin
    Init(ObjectType);
end;



procedure TD3DX12_STATE_OBJECT_DESC.SetStateObjectType(ObjectType: TD3D12_STATE_OBJECT_TYPE);
begin
    m_Desc.ObjectType := ObjectType;
end;

{ TSUBOBJECT_HELPER_BASE }

procedure TSUBOBJECT_HELPER_BASE.Init();
begin
    m_pSubobject := nil;
end;



constructor TSUBOBJECT_HELPER_BASE.Create;
begin
    Init();
end;



destructor TSUBOBJECT_HELPER_BASE.Destroy;
begin
    inherited Destroy;
end;



procedure TSUBOBJECT_HELPER_BASE.AddToStateObject(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
begin
    m_pSubobject := PD3D12_STATE_SUBOBJECT(ContainingStateObject.TrackSubobject(SubObjectType(), Data()));
end;

{ TD3DX12_DXIL_LIBRARY_SUBOBJECT }

procedure TD3DX12_DXIL_LIBRARY_SUBOBJECT.Init;
begin
    inherited Init;
    ZeroMemory(@m_Desc, SizeOf(m_Desc));
    m_Exports.Clear;
end;



function TD3DX12_DXIL_LIBRARY_SUBOBJECT.Data(): Pointer;
begin
    Result := @m_Desc;
end;



constructor TD3DX12_DXIL_LIBRARY_SUBOBJECT.Create();
begin
    Init();
end;



constructor TD3DX12_DXIL_LIBRARY_SUBOBJECT.Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
begin
    Init();
    AddToStateObject(ContainingStateObject);
end;



procedure TD3DX12_DXIL_LIBRARY_SUBOBJECT.SetDXILLibrary(pCode: PD3D12_SHADER_BYTECODE);
begin
    if pCode <> nil then
        m_Desc.DXILLibrary := pCode^
    else
        m_Desc.DXILLibrary.Init;
end;



procedure TD3DX12_DXIL_LIBRARY_SUBOBJECT.DefineExport(Name: widestring; ExportToRename: widestring; Flags: TD3D12_EXPORT_FLAGS);
var
    Export: TD3D12_EXPORT_DESC;
begin
    Export.Name := pwidechar(Name);
    Export.ExportToRename := pwidechar(ExportToRename);
    Export.Flags := Flags;
    m_Exports.push_back(Export);
    m_Desc.pExports := m_Exports.PtrItem[0];  // using ugly way to get pointer in case .data() is not defined
    m_Desc.NumExports := m_Exports.size;
end;



procedure TD3DX12_DXIL_LIBRARY_SUBOBJECT.DefineExports(StringExports: PWideString; N: UINT);
var
    lStrings: array of widestring absolute StringExports;
    i: integer;
begin
    for i := 0 to n - 1 do
        DefineExport(lStrings[i]);
end;



function TD3DX12_DXIL_LIBRARY_SUBOBJECT.SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE;
begin
    Result := D3D12_STATE_SUBOBJECT_TYPE_DXIL_LIBRARY;
end;

{ TD3DX12_EXISTING_COLLECTION_SUBOBJECT }

procedure TD3DX12_EXISTING_COLLECTION_SUBOBJECT.Init;
begin
    inherited Init;
    m_CollectionRef := nil;
    m_Exports.Clear();
end;



function TD3DX12_EXISTING_COLLECTION_SUBOBJECT.Data(): Pointer;
begin
    Result := @m_Desc;
end;



constructor TD3DX12_EXISTING_COLLECTION_SUBOBJECT.Create();
begin
    Init();
end;



constructor TD3DX12_EXISTING_COLLECTION_SUBOBJECT.Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
begin
    Init();
    AddToStateObject(ContainingStateObject);
end;



procedure TD3DX12_EXISTING_COLLECTION_SUBOBJECT.SetExistingCollection(pExistingCollection: ID3D12StateObject);
begin
    m_Desc.pExistingCollection := PID3D12StateObject(pExistingCollection);
    m_CollectionRef := pExistingCollection;
end;



procedure TD3DX12_EXISTING_COLLECTION_SUBOBJECT.DefineExport(Name: widestring; ExportToRename: widestring; Flags: TD3D12_EXPORT_FLAGS);
var
    Export: TD3D12_EXPORT_DESC;
begin
    Export.Name := pwidechar(Name);
    Export.ExportToRename := pwidechar(ExportToRename);
    Export.Flags := Flags;
    m_Exports.push_back(Export);
    m_Desc.pExports := m_Exports.PtrItem[0]; // using ugly way to get pointer in case .data() is not defined
    m_Desc.NumExports := m_Exports.size;
end;



procedure TD3DX12_EXISTING_COLLECTION_SUBOBJECT.DefineExports(StringExports: PWideString; N: UINT);
var
    lStrings: array of widestring absolute StringExports;
    i: integer;
begin
    for i := 0 to n - 1 do
        DefineExport(lStrings[i]);
end;



function TD3DX12_EXISTING_COLLECTION_SUBOBJECT.SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE;
begin
    Result := D3D12_STATE_SUBOBJECT_TYPE_EXISTING_COLLECTION;
end;

{ TD3DX12_SUBOBJECT_TO_EXPORTS_ASSOCIATION_SUBOBJECT }

procedure TD3DX12_SUBOBJECT_TO_EXPORTS_ASSOCIATION_SUBOBJECT.Init;
begin
    inherited Init;
    m_Exports.Clear();
end;



function TD3DX12_SUBOBJECT_TO_EXPORTS_ASSOCIATION_SUBOBJECT.Data(): Pointer;
begin
    Result := @m_Desc;
end;



constructor TD3DX12_SUBOBJECT_TO_EXPORTS_ASSOCIATION_SUBOBJECT.Create();
begin
    Init();
end;



constructor TD3DX12_SUBOBJECT_TO_EXPORTS_ASSOCIATION_SUBOBJECT.Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
begin
    Init();
    AddToStateObject(ContainingStateObject);
end;



procedure TD3DX12_SUBOBJECT_TO_EXPORTS_ASSOCIATION_SUBOBJECT.SetSubobjectToAssociate
    (SubobjectToAssociate: PD3D12_STATE_SUBOBJECT);
begin
    m_Desc.pSubobjectToAssociate := SubobjectToAssociate;
end;



procedure TD3DX12_SUBOBJECT_TO_EXPORTS_ASSOCIATION_SUBOBJECT.AddExport(Export: widestring);
begin
    Inc(m_Desc.NumExports);
    m_Exports.push_back(Export);
    m_Desc.pExports := pwidechar(m_Exports.PtrItem[0]);  // using ugly way to get pointer in case .data() is not defined
end;



procedure TD3DX12_SUBOBJECT_TO_EXPORTS_ASSOCIATION_SUBOBJECT.AddExports(StringExports: PWideString; N: UINT);
var
    lStrings: array of widestring absolute StringExports;
    i: integer;
begin
    for i := 0 to n - 1 do
        AddExport(lStrings[i]);
end;



function TD3DX12_SUBOBJECT_TO_EXPORTS_ASSOCIATION_SUBOBJECT.SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE;
begin
    Result := D3D12_STATE_SUBOBJECT_TYPE_SUBOBJECT_TO_EXPORTS_ASSOCIATION;
end;

{ TD3DX12_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION }

procedure TD3DX12_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION.Init;
begin
    inherited Init;
    m_Exports.Clear();
end;



function TD3DX12_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION.Data(): Pointer;
begin
    Result := @m_Desc;
end;



constructor TD3DX12_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION.Create();
begin
    Init();
end;



constructor TD3DX12_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION.Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
begin
    Init();
    AddToStateObject(ContainingStateObject);
end;



procedure TD3DX12_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION.SetSubobjectNameToAssociate
    (SubobjectToAssociate: widestring);
begin
    m_Desc.SubobjectToAssociate := pwidechar(SubobjectToAssociate);
end;



procedure TD3DX12_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION.AddExport(Export: widestring);
begin
    Inc(m_Desc.NumExports);
    m_Exports.push_back(Export);
    m_Desc.pExports := pwidechar(m_Exports.PtrItem[0]);  // using ugly way to get pointer in case .data() is not defined
end;



procedure TD3DX12_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION.AddExports(StringExports: PWideString; N: UINT);
var
    lStrings: array of widestring absolute StringExports;
    i: integer;
begin
    for i := 0 to n - 1 do
        AddExport(lStrings[i]);
end;



function TD3DX12_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION.SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE;
begin
    Result := D3D12_STATE_SUBOBJECT_TYPE_DXIL_SUBOBJECT_TO_EXPORTS_ASSOCIATION;
end;

{ TD3DX12_HIT_GROUP_SUBOBJECT }

procedure TD3DX12_HIT_GROUP_SUBOBJECT.Init;
var
    i: uint;
begin
    inherited Init;
    for i := 0 to m_NumStrings - 1 do
        m_Strings[i].Clear();
end;



function TD3DX12_HIT_GROUP_SUBOBJECT.Data(): Pointer;
begin
    Result := @m_Desc;
end;



constructor TD3DX12_HIT_GROUP_SUBOBJECT.Create();
begin
    Init();
end;



constructor TD3DX12_HIT_GROUP_SUBOBJECT.Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
begin
    Init();
    AddToStateObject(ContainingStateObject);
end;



procedure TD3DX12_HIT_GROUP_SUBOBJECT.SetHitGroupExport(exportName: widestring);
begin
    m_Desc.HitGroupExport := m_Strings[0].LocalCopy(pwidechar(exportName), True);
end;



procedure TD3DX12_HIT_GROUP_SUBOBJECT.SetHitGroupType(GroupeType: TD3D12_HIT_GROUP_TYPE);
begin
    m_Desc.GroupType := GroupeType;
end;



procedure TD3DX12_HIT_GROUP_SUBOBJECT.SetAnyHitShaderImport(importName: widestring);
begin
    m_Desc.AnyHitShaderImport := m_Strings[1].LocalCopy(pwidechar(importName), True);
end;



procedure TD3DX12_HIT_GROUP_SUBOBJECT.SetClosestHitShaderImport(importName: widestring);
begin
    m_Desc.ClosestHitShaderImport := m_Strings[2].LocalCopy(pwidechar(importName), True);
end;



procedure TD3DX12_HIT_GROUP_SUBOBJECT.SetIntersectionShaderImport(importName: widestring);
begin
    m_Desc.IntersectionShaderImport := m_Strings[3].LocalCopy(pwidechar(importName), True);
end;



function TD3DX12_HIT_GROUP_SUBOBJECT.SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE;
begin
    Result := D3D12_STATE_SUBOBJECT_TYPE_HIT_GROUP;
end;

{ TD3DX12_RAYTRACING_SHADER_CONFIG_SUBOBJECT }

procedure TD3DX12_RAYTRACING_SHADER_CONFIG_SUBOBJECT.Init;
begin
    inherited Init;
end;



function TD3DX12_RAYTRACING_SHADER_CONFIG_SUBOBJECT.Data(): Pointer;
begin
    Result := @m_Desc;
end;



constructor TD3DX12_RAYTRACING_SHADER_CONFIG_SUBOBJECT.Create();
begin
    Init();
end;



constructor TD3DX12_RAYTRACING_SHADER_CONFIG_SUBOBJECT.Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
begin
    Init();
    AddToStateObject(ContainingStateObject);
end;



constructor TD3DX12_RAYTRACING_SHADER_CONFIG_SUBOBJECT.Create(desc: PD3D12_RAYTRACING_SHADER_CONFIG);
begin
    Init();
    m_Desc := desc^;
end;



constructor TD3DX12_RAYTRACING_SHADER_CONFIG_SUBOBJECT.Create(desc: PD3D12_RAYTRACING_SHADER_CONFIG; ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
begin
    Init();
    m_Desc := desc^;
    AddToStateObject(ContainingStateObject);
end;



function TD3DX12_RAYTRACING_SHADER_CONFIG_SUBOBJECT.SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE;
begin
    Result := D3D12_STATE_SUBOBJECT_TYPE_RAYTRACING_SHADER_CONFIG;
end;



procedure TD3DX12_RAYTRACING_SHADER_CONFIG_SUBOBJECT.Config(MaxPayloadSizeInBytes, MaxAttributeSizeInBytes: UINT);
begin
    m_Desc.MaxPayloadSizeInBytes := MaxPayloadSizeInBytes;
    m_Desc.MaxAttributeSizeInBytes := MaxAttributeSizeInBytes;
end;

{ TD3DX12_RAYTRACING_PIPELINE_CONFIG_SUBOBJECT }

procedure TD3DX12_RAYTRACING_PIPELINE_CONFIG_SUBOBJECT.Init;
begin
    inherited Init;
end;



function TD3DX12_RAYTRACING_PIPELINE_CONFIG_SUBOBJECT.Data(): Pointer;
begin
    Result := @m_Desc;
end;



constructor TD3DX12_RAYTRACING_PIPELINE_CONFIG_SUBOBJECT.Create();
begin

end;



constructor TD3DX12_RAYTRACING_PIPELINE_CONFIG_SUBOBJECT.Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
begin

end;



constructor TD3DX12_RAYTRACING_PIPELINE_CONFIG_SUBOBJECT.Create(desc: PD3D12_RAYTRACING_PIPELINE_CONFIG);
begin

end;



constructor TD3DX12_RAYTRACING_PIPELINE_CONFIG_SUBOBJECT.Create(desc: PD3D12_RAYTRACING_PIPELINE_CONFIG; ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
begin

end;



function TD3DX12_RAYTRACING_PIPELINE_CONFIG_SUBOBJECT.SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE;
begin
    Result := D3D12_STATE_SUBOBJECT_TYPE_RAYTRACING_PIPELINE_CONFIG;
end;



procedure TD3DX12_RAYTRACING_PIPELINE_CONFIG_SUBOBJECT.Config(MaxTraceRecursionDepth: UINT);
begin
    m_Desc.MaxTraceRecursionDepth := MaxTraceRecursionDepth;
end;

{ TD3DX12_WORK_GRAPH_SUBOBJECT }

constructor TD3DX12_WORK_GRAPH_SUBOBJECT.Create;
begin
    Init();
end;



constructor TD3DX12_WORK_GRAPH_SUBOBJECT.Create(ContainingStateObject: TD3DX12_STATE_OBJECT_DESC);
begin
    Init();
    AddToStateObject(ContainingStateObject);
end;



function TD3DX12_WORK_GRAPH_SUBOBJECT.SubObjectType: TD3D12_STATE_SUBOBJECT_TYPE;
begin
    Result := D3D12_STATE_SUBOBJECT_TYPE_WORK_GRAPH;
end;



procedure TD3DX12_WORK_GRAPH_SUBOBJECT.IncludeAllAvailableNodes();
begin
    // m_Desc.Flags := m_Desc.Flags or D3D12_WORK_GRAPH_FLAG_INCLUDE_ALL_AVAILABLE_NODES;
end;



procedure TD3DX12_WORK_GRAPH_SUBOBJECT.SetProgramName(ProgramName: LPCWSTR);
begin
    // m_Desc.ProgramName := m_Strings.LocalCopy(ProgramName);
end;



procedure TD3DX12_WORK_GRAPH_SUBOBJECT.AddEntrypoint(Entrypoint: TD3D12_NODE_ID);
var
    s: widestring;
    localEntrypoint: TD3D12_NODE_ID;
begin
 {   s := Entrypoint.Name;
    localEntrypoint.Init(pwidechar(s), Entrypoint.ArrayIndex);
    m_Entrypoints.emplace_back(localEntrypoint);
    Inc(m_Desc.NumEntrypoints);
    m_Desc.pEntrypoints := m_Entrypoints.Data();}
end;

end.
