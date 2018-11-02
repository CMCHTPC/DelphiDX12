(*

{$IFDEF INTERFACE}
  // TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TInnerStructType, TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE, TInnerStructType > = class
  TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TInnerStructType> = class
  private
     _Inner: TInnerStructType;
     _Type: TD3D12_PIPELINE_STATE_SUBOBJECT_TYPE;
  public
        constructor Create; overload;
        constructor Create(i: TInnerStructType); overload;
  end;
{$UNDEF INTERFACE}
{$ENDIF}

{$IFDEF IMPLEMENTATION}
{ TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT }

constructor TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TInnerStructType>.Create;
begin
    _Type:= TType
  _Inner:= DefaultArg
end;

constructor TD3DX12_PIPELINE_STATE_STREAM_SUBOBJECT<TInnerStructType>.Create(i: TInnerStructType);
begin

end;

//Operator := (C : Complex) z : complex;

{$UNDEF IMPLEMENTATION}
{$ENDIF}
    *)

