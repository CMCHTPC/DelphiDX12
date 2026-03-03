 //--------------------------------------------------------------------------------------
 // File: SharedResourcePool.h

 // Copyright (c) Microsoft Corporation.
 // Licensed under the MIT License.

 // http://go.microsoft.com/fwlink/?LinkId=248929
 // http://go.microsoft.com/fwlink/?LinkID=615561
 //--------------------------------------------------------------------------------------
unit DX12TK.SharedResourcePool;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    CStdSharedPtr,
    DX12TK.PlatformHelpers;

type
    // Pool manager ensures that only a single TData instance is created for each unique TKey.
    // This is used to avoid duplicate resource creation, so that for instance a caller can
    // create any number of SpriteBatch instances, but these can internally share shaders and
    // vertex buffer if more than one SpriteBatch uses the same underlying D3D device.

    { TSharedResourcePool }

    generic TSharedResourcePool<TKey, TData> = class(TObject)
        // Allocates or looks up the shared TData instance for the specified key.
        function DemandCreate(key: TKey): specialize TCStdSharedPtr<TData>;
    end;

implementation

{ TSharedResourcePool }

function TSharedResourcePool.DemandCreate(key: TKey): specialize TCStdSharedPtr<
  TData>;
begin

end;

end.
