//*********************************************************

// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.

//*********************************************************
unit SquidRoom;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGIFormat,
    DX12.D3D12;

const
    // SquidRoom

    DataFileName = WideString('SquidRoom.bin');
    StandardVertexStride = 44;

    StandardIndexFormat = DXGI_FORMAT_R32_UINT;

    VertexDataOffset = 30277640;
    VertexDataSize = 9685808;
    IndexDataOffset = 39963448;
    IndexDataSize = 3056844;

    StandardVertexDescription: array of TD3D12_INPUT_ELEMENT_DESC = (
        (SemanticName: 'POSITION'; SemanticIndex: 0; Format: DXGI_FORMAT_R32G32B32_FLOAT; InputSlot: 0; AlignedByteOffset: 0; InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA; InstanceDataStepRate: 0),
        (SemanticName: 'NORMAL'; SemanticIndex: 0; Format: DXGI_FORMAT_R32G32B32_FLOAT; InputSlot: 0; AlignedByteOffset: 12; InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA; InstanceDataStepRate: 0),
        (SemanticName: 'TEXCOORD'; SemanticIndex: 0; Format: DXGI_FORMAT_R32G32_FLOAT; InputSlot: 0; AlignedByteOffset: 24; InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA; InstanceDataStepRate: 0),
        (SemanticName: 'TANGENT'; SemanticIndex: 0; Format: DXGI_FORMAT_R32G32B32_FLOAT; InputSlot: 0; AlignedByteOffset: 32; InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA; InstanceDataStepRate: 0)
        );


type

    TDataProperties = record
        Offset: UINT;
        Size: UINT;
        Pitch: UINT;
    end;
    PDataProperties = ^TDataProperties;


    TTextureResource = record
        Width: UINT;
        Height: UINT;
        MipLevels: UINT;
        Format: TDXGI_FORMAT;
        Data: array [0..D3D12_REQ_MIP_LEVELS - 1] of TDataProperties;
    end;
    PTextureResource = ^TTextureResource;


    TDrawParameters = record
        DiffuseTextureIndex: int32;
        NormalTextureIndex: int32;
        SpecularTextureIndex: int32;
        IndexStart: UINT;
        IndexCount: UINT;
        VertexBase: UINT;
    end;
    PDrawParameters = ^TDrawParameters;


const
    TexturesCount = 74;
    Textures: array[0..TexturesCount-1] of TTextureResource = (
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 0; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // squard room platform_3_diff_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 131072; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // squard room platform_3_norm_512.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 262144; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // squard room platform_2_diff_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 786432; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // squard room platform_2_norm_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 1310720; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // squard room platform_1_diff_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 1835008; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // squard room platform_1_norm_1024.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 2359296; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // shelves2_diff1_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 2490368; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // shelves2_nm1_512.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 2621440; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Misc_Boss_2 1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 3145728; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // Misc_Boss_2_normal1024.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 3670016; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Hanging_bundle_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 3801088; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Catwalk_03_Normal_512.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 3932160; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // Stack_ Boxes_Diff02_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 4456448; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // Stack_ Boxes_Nm02_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 4980736; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // Stack_ Boxes_Diff03_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 5505024; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // Stack_ Boxes_Nm03_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 6029312; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // Stack_ Boxes_Diff01_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 6553600; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // Stack_ Boxes_Nm01_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 7077888; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Back_Alley_box_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 7602176; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // Back_Alley_box _norm_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 8126464; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // gameCrates_01_Diff_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 8650752; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // gameCrates_01_Nor_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 9175040; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // RaceCar_Strorage_Diff512.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 9699328; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // RaceCar_Strorage_Norm512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 10223616; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // hats_02_diff_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 10354688; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // hats_02_norm_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 10485760; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // hats_01_diff_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 10616832; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // hats_01_norm_512.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 10747904; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Misc_Boss_1_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 11272192; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // Misc_Boss_1_normal_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 11796480; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // gameCrates_03_Diff_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 12320768; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // gameCrates_03_Nor_1024.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 12845056; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),          // gameCrates_02_Diff_512.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 12976128; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Back_Alley_Drum.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 13500416; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),          // Back_Alley_Drum _norm_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 13631488; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // shelves2_diff_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 13762560; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // shelves2_nor_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 13893632; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // shelves2_diff2_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 14024704; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // shelves2_nm2_512.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 14155776; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // marbel drum texture_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 14680064; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // marbel drum texture _Nrml_1024.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 15204352; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Catwalk_02_Diffuse512.dds
        (Width: 1; Height: 1; miplevels: 1; format: DXGI_FORMAT_R8G8B8A8_UNORM; Data: ((offset: 15335424; size: 4; pitch: 4), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // default-normalmap.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 15335428; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),          // Catwalk_03_Diffuse_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 15466500; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // shelves3_diff_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 15597572; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // shelves3_nor_512.dds
        (Width: 2048; Height: 2048; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 15728644; size: 2097152; pitch: 4096), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Misc_Boss_3_2048.dds
        (Width: 2048; Height: 2048; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 17825796; size: 2097152; pitch: 4096), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),        // Misc_Boss_3_normal2048R.dds
        (Width: 1; Height: 1; miplevels: 1; format: DXGI_FORMAT_R8G8B8A8_UNORM; Data: ((offset: 19922948; size: 4; pitch: 4), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // default.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 19922952; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Hanghing Light_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 20054024; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),           // Hanghing Light_normal_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 20185096; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),           // Hanging_bundle_normal_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 20316168; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),           // Hanging_bundle_marble_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 20447240; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),           // Hanging_bundle_marble_normal_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 20578312; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // window_Diff512.dds
        (Width: 512; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 20709384; size: 262144; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),          // Sliding Steel Door_Diff_512.dds
        (Width: 512; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 20971528; size: 262144; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),          // Sliding Steel Door_Norm_512.dds
        (Width: 512; Height: 512; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 21233672; size: 131072; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // window_Norm512.dds
        (Width: 512; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 21364744; size: 262144; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Door_Diff_512.dds
        (Width: 512; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 21626888; size: 262144; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Door_Norm_512.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 21889032; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // floor_Diff_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 22413320; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // floor_Normal_1024.dds
        (Width: 2048; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 22937608; size: 1048576; pitch: 4096), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // wall03_Diff_2048.dds
        (Width: 2048; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 23986184; size: 1048576; pitch: 4096), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // wall03_Normal_2048.dds
        (Width: 2048; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 25034760; size: 1048576; pitch: 4096), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // wall01_Diff_2048.dds
        (Width: 2048; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 26083336; size: 1048576; pitch: 4096), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // wall01_Normal_2048.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 27131912; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Roof_Diff1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 27656200; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Roof_Normal1024.dds
        (Width: 512; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 28180488; size: 262144; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // pillar_Diff_512.dds
        (Width: 512; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 28442632; size: 262144; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // pillar_Norm_512.dds
        (Width: 512; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 28704776; size: 262144; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),          // Broken_Pillar_Diff_512.dds
        (Width: 512; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 28966920; size: 262144; pitch: 1024), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),          // Broken_Pillar_Norm_512.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 29229064; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ())),  // Golfclub_dm_1024.dds
        (Width: 1024; Height: 1024; miplevels: 1; format: DXGI_FORMAT_BC1_UNORM; Data: ((offset: 29753352; size: 524288; pitch: 2048), (), (), (), (), (), (), (), (), (), (), (), (), (), ()))  // Golfclub_nm_1024.dds

        );

    Draws: array of TDrawParameters = (
         ( DiffuseTextureIndex: 0; NormalTextureIndex:  1; SpecularTextureIndex: -1;    IndexStart:    0; IndexCount: 15198;      VertexBase:  0 ),  // subset0_squard_room_platform_3_dif1
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    15198; IndexCount: 438;      VertexBase:  6051 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    15636; IndexCount: 300;      VertexBase:  6164 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    15936; IndexCount: 300;      VertexBase:  6225 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    16236; IndexCount: 438;      VertexBase:  6286 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    16674; IndexCount: 300;      VertexBase:  6399 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    16974; IndexCount: 438;      VertexBase:  6460 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    17412; IndexCount: 300;      VertexBase:  6573 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    17712; IndexCount: 450;      VertexBase:  6634 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    18162; IndexCount: 300;      VertexBase:  6756 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    18462; IndexCount: 438;      VertexBase:  6817 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    18900; IndexCount: 300;      VertexBase:  6930 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    19200; IndexCount: 300;      VertexBase:  6991 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    19500; IndexCount: 438;      VertexBase:  7052 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    19938; IndexCount: 300;      VertexBase:  7165 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    20238; IndexCount: 438;      VertexBase:  7226 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    20676; IndexCount: 300;      VertexBase:  7339 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    20976; IndexCount: 300;      VertexBase:  7400 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    21276; IndexCount: 438;      VertexBase:  7461 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    21714; IndexCount: 300;      VertexBase:  7574 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    22014; IndexCount: 438;      VertexBase:  7635 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    22452; IndexCount: 300;      VertexBase:  7748 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    22752; IndexCount: 450;      VertexBase:  7809 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    23202; IndexCount: 300;      VertexBase:  7931 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    23502; IndexCount: 438;      VertexBase:  7992 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    23940; IndexCount: 300;      VertexBase:  8105 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    24240; IndexCount: 300;      VertexBase:  8166 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    24540; IndexCount: 438;      VertexBase:  8227 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    24978; IndexCount: 300;      VertexBase:  8340 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    25278; IndexCount: 438;      VertexBase:  8401 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    25716; IndexCount: 300;      VertexBase:  8514 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    26016; IndexCount: 300;      VertexBase:  8575 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    26316; IndexCount: 438;      VertexBase:  8636 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    26754; IndexCount: 300;      VertexBase:  8749 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    27054; IndexCount: 438;      VertexBase:  8810 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    27492; IndexCount: 300;      VertexBase:  8923 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    27792; IndexCount: 300;      VertexBase:  8984 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    28092; IndexCount: 438;      VertexBase:  9045 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    28530; IndexCount: 300;      VertexBase:  9158 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    28830; IndexCount: 438;      VertexBase:  9219 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    29268; IndexCount: 300;      VertexBase:  9332 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    29568; IndexCount: 450;      VertexBase:  9393 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    30018; IndexCount: 300;      VertexBase:  9515 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    30318; IndexCount: 438;      VertexBase:  9576 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    30756; IndexCount: 300;      VertexBase:  9689 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    31056; IndexCount: 300;      VertexBase:  9750 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    31356; IndexCount: 438;      VertexBase:  9811 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    31794; IndexCount: 300;      VertexBase:  9924 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    32094; IndexCount: 438;      VertexBase:  9985 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    32532; IndexCount: 300;      VertexBase:  10098 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    32832; IndexCount: 450;      VertexBase:  10159 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    33282; IndexCount: 300;      VertexBase:  10281 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    33582; IndexCount: 438;      VertexBase:  10342 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    34020; IndexCount: 300;      VertexBase:  10455 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    34320; IndexCount: 300;      VertexBase:  10516 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    34620; IndexCount: 438;      VertexBase:  10577 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    35058; IndexCount: 300;      VertexBase:  10690 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    35358; IndexCount: 900;      VertexBase:  10751 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    36258; IndexCount: 282;      VertexBase:  11016 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    36540; IndexCount: 282;      VertexBase:  11142 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    36822; IndexCount: 222;      VertexBase:  11228 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    37044; IndexCount: 282;      VertexBase:  11304 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    37326; IndexCount: 282;      VertexBase:  11396 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    37608; IndexCount: 282;      VertexBase:  11485 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    37890; IndexCount: 243;      VertexBase:  11577 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    38133; IndexCount: 222;      VertexBase:  11665 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 2; NormalTextureIndex:  3; SpecularTextureIndex: -1;    IndexStart:    38355; IndexCount: 282;      VertexBase:  11743 ),  // subset0_squard_room_platform_2_dif
 ( DiffuseTextureIndex: 4; NormalTextureIndex:  5; SpecularTextureIndex: -1;    IndexStart:    38637; IndexCount: 2700;      VertexBase:  11834 ),  // subset0_squard_room_platform_1_diff
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    41337; IndexCount: 1788;      VertexBase:  12560 ),  // subset0_shelves1_diff
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    43125; IndexCount: 180;      VertexBase:  13101 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    43305; IndexCount: 180;      VertexBase:  13138 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    43485; IndexCount: 96;      VertexBase:  13175 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    43581; IndexCount: 96;      VertexBase:  13202 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    43677; IndexCount: 96;      VertexBase:  13229 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    43773; IndexCount: 96;      VertexBase:  13256 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    43869; IndexCount: 96;      VertexBase:  13283 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    43965; IndexCount: 30;      VertexBase:  13310 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    43995; IndexCount: 24;      VertexBase:  13322 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44019; IndexCount: 24;      VertexBase:  13332 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44043; IndexCount: 24;      VertexBase:  13342 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44067; IndexCount: 24;      VertexBase:  13351 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44091; IndexCount: 54;      VertexBase:  13360 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44145; IndexCount: 12;      VertexBase:  13380 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44157; IndexCount: 72;      VertexBase:  13386 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44229; IndexCount: 84;      VertexBase:  13424 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44313; IndexCount: 30;      VertexBase:  13448 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44343; IndexCount: 6;      VertexBase:  13460 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44349; IndexCount: 36;      VertexBase:  13464 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44385; IndexCount: 60;      VertexBase:  13478 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44445; IndexCount: 72;      VertexBase:  13496 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44517; IndexCount: 48;      VertexBase:  13534 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44565; IndexCount: 24;      VertexBase:  13549 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44589; IndexCount: 24;      VertexBase:  13559 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44613; IndexCount: 24;      VertexBase:  13569 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44637; IndexCount: 42;      VertexBase:  13579 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44679; IndexCount: 12;      VertexBase:  13595 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44691; IndexCount: 48;      VertexBase:  13603 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44739; IndexCount: 6;      VertexBase:  13625 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44745; IndexCount: 48;      VertexBase:  13629 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44793; IndexCount: 6;      VertexBase:  13644 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44799; IndexCount: 60;      VertexBase:  13648 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44859; IndexCount: 6;      VertexBase:  13666 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44865; IndexCount: 60;      VertexBase:  13670 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44925; IndexCount: 72;      VertexBase:  13688 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    44997; IndexCount: 48;      VertexBase:  13709 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45045; IndexCount: 36;      VertexBase:  13727 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45081; IndexCount: 72;      VertexBase:  13741 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45153; IndexCount: 12;      VertexBase:  13779 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45165; IndexCount: 12;      VertexBase:  13785 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45177; IndexCount: 30;      VertexBase:  13791 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45207; IndexCount: 36;      VertexBase:  13803 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45243; IndexCount: 6;      VertexBase:  13817 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45249; IndexCount: 6;      VertexBase:  13821 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45255; IndexCount: 24;      VertexBase:  13825 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45279; IndexCount: 24;      VertexBase:  13835 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45303; IndexCount: 24;      VertexBase:  13845 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45327; IndexCount: 96;      VertexBase:  13855 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45423; IndexCount: 30;      VertexBase:  13882 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45453; IndexCount: 96;      VertexBase:  13894 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45549; IndexCount: 96;      VertexBase:  13921 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45645; IndexCount: 72;      VertexBase:  13948 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45717; IndexCount: 72;      VertexBase:  13969 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45789; IndexCount: 42;      VertexBase:  13990 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45831; IndexCount: 42;      VertexBase:  14006 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45873; IndexCount: 54;      VertexBase:  14022 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45927; IndexCount: 54;      VertexBase:  14042 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    45981; IndexCount: 60;      VertexBase:  14062 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46041; IndexCount: 60;      VertexBase:  14080 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46101; IndexCount: 36;      VertexBase:  14098 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46137; IndexCount: 12;      VertexBase:  14112 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46149; IndexCount: 12;      VertexBase:  14118 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46161; IndexCount: 12;      VertexBase:  14124 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46173; IndexCount: 24;      VertexBase:  14130 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46197; IndexCount: 24;      VertexBase:  14140 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46221; IndexCount: 24;      VertexBase:  14150 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46245; IndexCount: 24;      VertexBase:  14160 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46269; IndexCount: 24;      VertexBase:  14170 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46293; IndexCount: 48;      VertexBase:  14180 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46341; IndexCount: 48;      VertexBase:  14195 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46389; IndexCount: 48;      VertexBase:  14210 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46437; IndexCount: 48;      VertexBase:  14225 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46485; IndexCount: 48;      VertexBase:  14240 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46533; IndexCount: 36;      VertexBase:  14255 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46569; IndexCount: 36;      VertexBase:  14269 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46605; IndexCount: 36;      VertexBase:  14283 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46641; IndexCount: 36;      VertexBase:  14297 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46677; IndexCount: 36;      VertexBase:  14311 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46713; IndexCount: 72;      VertexBase:  14325 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46785; IndexCount: 72;      VertexBase:  14363 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46857; IndexCount: 6;      VertexBase:  14401 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46863; IndexCount: 6;      VertexBase:  14405 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46869; IndexCount: 6;      VertexBase:  14409 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46875; IndexCount: 24;      VertexBase:  14413 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46899; IndexCount: 24;      VertexBase:  14422 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46923; IndexCount: 48;      VertexBase:  14431 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    46971; IndexCount: 48;      VertexBase:  14449 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47019; IndexCount: 12;      VertexBase:  14464 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47031; IndexCount: 12;      VertexBase:  14470 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47043; IndexCount: 12;      VertexBase:  14476 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47055; IndexCount: 12;      VertexBase:  14482 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47067; IndexCount: 12;      VertexBase:  14488 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47079; IndexCount: 12;      VertexBase:  14494 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47091; IndexCount: 12;      VertexBase:  14500 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47103; IndexCount: 12;      VertexBase:  14506 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47115; IndexCount: 24;      VertexBase:  14512 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47139; IndexCount: 24;      VertexBase:  14521 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47163; IndexCount: 60;      VertexBase:  14530 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47223; IndexCount: 60;      VertexBase:  14548 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47283; IndexCount: 60;      VertexBase:  14566 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47343; IndexCount: 60;      VertexBase:  14584 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47403; IndexCount: 60;      VertexBase:  14602 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47463; IndexCount: 48;      VertexBase:  14620 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47511; IndexCount: 48;      VertexBase:  14642 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47559; IndexCount: 36;      VertexBase:  14664 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47595; IndexCount: 36;      VertexBase:  14678 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47631; IndexCount: 24;      VertexBase:  14692 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47655; IndexCount: 12;      VertexBase:  14701 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47667; IndexCount: 12;      VertexBase:  14707 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47679; IndexCount: 12;      VertexBase:  14713 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47691; IndexCount: 12;      VertexBase:  14719 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47703; IndexCount: 12;      VertexBase:  14725 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47715; IndexCount: 12;      VertexBase:  14731 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47727; IndexCount: 12;      VertexBase:  14737 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47739; IndexCount: 6;      VertexBase:  14743 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47745; IndexCount: 6;      VertexBase:  14747 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47751; IndexCount: 6;      VertexBase:  14751 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47757; IndexCount: 6;      VertexBase:  14755 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47763; IndexCount: 12;      VertexBase:  14759 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47775; IndexCount: 12;      VertexBase:  14765 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47787; IndexCount: 12;      VertexBase:  14771 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47799; IndexCount: 12;      VertexBase:  14777 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    47811; IndexCount: 60;      VertexBase:  14783 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    47871; IndexCount: 762;      VertexBase:  14801 ),  // subset0_lambert1
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    48633; IndexCount: 66;      VertexBase:  14801 ),  // subset1_blinnMisc_Boss_2_0
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    48699; IndexCount: 144;      VertexBase:  15136 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    48843; IndexCount: 144;      VertexBase:  15171 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    48987; IndexCount: 144;      VertexBase:  15206 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    49131; IndexCount: 144;      VertexBase:  15241 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    49275; IndexCount: 180;      VertexBase:  15276 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    49455; IndexCount: 144;      VertexBase:  15318 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    49599; IndexCount: 144;      VertexBase:  15353 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    49743; IndexCount: 144;      VertexBase:  15388 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    49887; IndexCount: 180;      VertexBase:  15423 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    50067; IndexCount: 180;      VertexBase:  15465 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    50247; IndexCount: 144;      VertexBase:  15507 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    50391; IndexCount: 180;      VertexBase:  15542 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    50571; IndexCount: 144;      VertexBase:  15584 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    50715; IndexCount: 108;      VertexBase:  15619 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    50823; IndexCount: 4416;      VertexBase:  15647 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 8; NormalTextureIndex:  9; SpecularTextureIndex: -1;    IndexStart:    55239; IndexCount: 273;      VertexBase:  16657 ),  // subset0_blinnMisc_Boss_2
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    55512; IndexCount: 4143;      VertexBase:  16754 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    59655; IndexCount: 360;      VertexBase:  19212 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    60015; IndexCount: 300;      VertexBase:  19293 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    60315; IndexCount: 360;      VertexBase:  19359 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    60675; IndexCount: 240;      VertexBase:  19436 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    60915; IndexCount: 1566;      VertexBase:  19491 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    62481; IndexCount: 48;      VertexBase:  19889 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    62529; IndexCount: 48;      VertexBase:  19907 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    62577; IndexCount: 48;      VertexBase:  19925 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    62625; IndexCount: 48;      VertexBase:  19943 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    62673; IndexCount: 48;      VertexBase:  19961 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    62721; IndexCount: 48;      VertexBase:  19979 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    62769; IndexCount: 96;      VertexBase:  19997 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    62865; IndexCount: 36;      VertexBase:  20024 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    62901; IndexCount: 36;      VertexBase:  20038 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    62937; IndexCount: 36;      VertexBase:  20052 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    62973; IndexCount: 36;      VertexBase:  20066 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63009; IndexCount: 36;      VertexBase:  20080 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63045; IndexCount: 36;      VertexBase:  20094 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63081; IndexCount: 36;      VertexBase:  20108 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63117; IndexCount: 36;      VertexBase:  20122 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63153; IndexCount: 36;      VertexBase:  20136 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63189; IndexCount: 36;      VertexBase:  20150 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63225; IndexCount: 36;      VertexBase:  20164 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63261; IndexCount: 108;      VertexBase:  20178 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63369; IndexCount: 36;      VertexBase:  20206 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63405; IndexCount: 36;      VertexBase:  20220 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63441; IndexCount: 36;      VertexBase:  20234 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63477; IndexCount: 36;      VertexBase:  20248 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63513; IndexCount: 36;      VertexBase:  20262 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63549; IndexCount: 36;      VertexBase:  20276 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63585; IndexCount: 36;      VertexBase:  20290 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63621; IndexCount: 72;      VertexBase:  20304 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63693; IndexCount: 72;      VertexBase:  20325 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63765; IndexCount: 144;      VertexBase:  20346 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63909; IndexCount: 72;      VertexBase:  20381 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    63981; IndexCount: 36;      VertexBase:  20402 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64017; IndexCount: 36;      VertexBase:  20416 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64053; IndexCount: 144;      VertexBase:  20430 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64197; IndexCount: 144;      VertexBase:  20465 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64341; IndexCount: 36;      VertexBase:  20500 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64377; IndexCount: 36;      VertexBase:  20514 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64413; IndexCount: 36;      VertexBase:  20528 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64449; IndexCount: 36;      VertexBase:  20542 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64485; IndexCount: 36;      VertexBase:  20556 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64521; IndexCount: 36;      VertexBase:  20570 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64557; IndexCount: 36;      VertexBase:  20584 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64593; IndexCount: 36;      VertexBase:  20598 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64629; IndexCount: 36;      VertexBase:  20612 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64665; IndexCount: 36;      VertexBase:  20626 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64701; IndexCount: 252;      VertexBase:  20640 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    64953; IndexCount: 276;      VertexBase:  20816 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    65229; IndexCount: 276;      VertexBase:  21014 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    65505; IndexCount: 276;      VertexBase:  21200 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    65781; IndexCount: 294;      VertexBase:  21394 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    66075; IndexCount: 279;      VertexBase:  21582 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    66354; IndexCount: 264;      VertexBase:  21732 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    66618; IndexCount: 288;      VertexBase:  21898 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    66906; IndexCount: 468;      VertexBase:  22065 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    67374; IndexCount: 1296;      VertexBase:  22222 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    68670; IndexCount: 18;      VertexBase:  22988 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    68688; IndexCount: 36;      VertexBase:  22996 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    68724; IndexCount: 42;      VertexBase:  23022 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    68766; IndexCount: 36;      VertexBase:  23054 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    68802; IndexCount: 42;      VertexBase:  23076 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    68844; IndexCount: 336;      VertexBase:  23104 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    69180; IndexCount: 144;      VertexBase:  23104 ),  // subset1_lambert1_0
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    69324; IndexCount: 240;      VertexBase:  23250 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    69564; IndexCount: 240;      VertexBase:  23334 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    69804; IndexCount: 246;      VertexBase:  23427 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    70050; IndexCount: 120;      VertexBase:  23543 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    70170; IndexCount: 630;      VertexBase:  23600 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    70800; IndexCount: 1080;      VertexBase:  23743 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    71880; IndexCount: 720;      VertexBase:  23991 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    72600; IndexCount: 204;      VertexBase:  24154 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    72804; IndexCount: 336;      VertexBase:  24198 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    73140; IndexCount: 144;      VertexBase:  24198 ),  // subset1_lambert1_0
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    73284; IndexCount: 225;      VertexBase:  24344 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    73509; IndexCount: 15;      VertexBase:  24344 ),  // subset1_lambert1_0
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    73524; IndexCount: 225;      VertexBase:  24458 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    73749; IndexCount: 15;      VertexBase:  24458 ),  // subset1_lambert1_0
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    73764; IndexCount: 225;      VertexBase:  24572 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    73989; IndexCount: 15;      VertexBase:  24572 ),  // subset1_lambert1_0
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    74004; IndexCount: 225;      VertexBase:  24686 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    74229; IndexCount: 15;      VertexBase:  24686 ),  // subset1_lambert1_0
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    74244; IndexCount: 225;      VertexBase:  24800 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    74469; IndexCount: 15;      VertexBase:  24800 ),  // subset1_lambert1_0
 ( DiffuseTextureIndex: 12; NormalTextureIndex:  13; SpecularTextureIndex: -1;    IndexStart:    74484; IndexCount: 225;      VertexBase:  24914 ),  // subset0_Stack__Boxes_Diff02
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    74709; IndexCount: 15;      VertexBase:  24914 ),  // subset1_lambert1_0
 ( DiffuseTextureIndex: 14; NormalTextureIndex:  15; SpecularTextureIndex: -1;    IndexStart:    74724; IndexCount: 2208;      VertexBase:  25028 ),  // subset0_Stack__Boxes_Diff03
 ( DiffuseTextureIndex: 16; NormalTextureIndex:  17; SpecularTextureIndex: -1;    IndexStart:    76932; IndexCount: 9381;      VertexBase:  25553 ),  // subset0_Stack__Boxes_Diff01
 ( DiffuseTextureIndex: 18; NormalTextureIndex:  19; SpecularTextureIndex: -1;    IndexStart:    86313; IndexCount: 948;      VertexBase:  29643 ),  // subset0_Back_Alley_box
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    87261; IndexCount: 1488;      VertexBase:  29946 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    88749; IndexCount: 1998;      VertexBase:  30265 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    90747; IndexCount: 1872;      VertexBase:  30649 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    92619; IndexCount: 1692;      VertexBase:  31034 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    94311; IndexCount: 1638;      VertexBase:  31387 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    95949; IndexCount: 1872;      VertexBase:  31702 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    97821; IndexCount: 1662;      VertexBase:  32056 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    99483; IndexCount: 1902;      VertexBase:  32409 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    101385; IndexCount: 720;      VertexBase:  32807 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    102105; IndexCount: 1296;      VertexBase:  32957 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    103401; IndexCount: 432;      VertexBase:  33232 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    103833; IndexCount: 1152;      VertexBase:  33332 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    104985; IndexCount: 1152;      VertexBase:  33557 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    106137; IndexCount: 1380;      VertexBase:  33782 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    107517; IndexCount: 1470;      VertexBase:  34080 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    108987; IndexCount: 1308;      VertexBase:  34364 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 20; NormalTextureIndex:  21; SpecularTextureIndex: -1;    IndexStart:    110295; IndexCount: 1662;      VertexBase:  34622 ),  // subset0_gameCrates_01_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    111957; IndexCount: 636;      VertexBase:  34941 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    112593; IndexCount: 1728;      VertexBase:  35137 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    114321; IndexCount: 336;      VertexBase:  35500 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    114657; IndexCount: 2304;      VertexBase:  35577 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    116961; IndexCount: 246;      VertexBase:  36138 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    117207; IndexCount: 1260;      VertexBase:  36270 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    118467; IndexCount: 1866;      VertexBase:  36512 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    120333; IndexCount: 2070;      VertexBase:  36976 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    122403; IndexCount: 1050;      VertexBase:  37421 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    123453; IndexCount: 450;      VertexBase:  37624 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    123903; IndexCount: 450;      VertexBase:  37760 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    124353; IndexCount: 390;      VertexBase:  37896 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    124743; IndexCount: 390;      VertexBase:  38021 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    125133; IndexCount: 390;      VertexBase:  38148 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    125523; IndexCount: 330;      VertexBase:  38273 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    125853; IndexCount: 390;      VertexBase:  38387 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    126243; IndexCount: 330;      VertexBase:  38512 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    126573; IndexCount: 420;      VertexBase:  38626 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    126993; IndexCount: 390;      VertexBase:  38763 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    127383; IndexCount: 300;      VertexBase:  38888 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    127683; IndexCount: 300;      VertexBase:  38961 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    127983; IndexCount: 300;      VertexBase:  39045 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    128283; IndexCount: 300;      VertexBase:  39131 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    128583; IndexCount: 300;      VertexBase:  39215 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    128883; IndexCount: 300;      VertexBase:  39286 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    129183; IndexCount: 300;      VertexBase:  39410 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    129483; IndexCount: 300;      VertexBase:  39483 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    129783; IndexCount: 300;      VertexBase:  39567 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    130083; IndexCount: 300;      VertexBase:  39653 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    130383; IndexCount: 300;      VertexBase:  39737 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    130683; IndexCount: 300;      VertexBase:  39808 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    130983; IndexCount: 300;      VertexBase:  39968 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    131283; IndexCount: 300;      VertexBase:  40041 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    131583; IndexCount: 300;      VertexBase:  40125 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    131883; IndexCount: 300;      VertexBase:  40211 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    132183; IndexCount: 300;      VertexBase:  40295 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    132483; IndexCount: 300;      VertexBase:  40366 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    132783; IndexCount: 300;      VertexBase:  40490 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    133083; IndexCount: 300;      VertexBase:  40561 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    133383; IndexCount: 300;      VertexBase:  40721 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    133683; IndexCount: 300;      VertexBase:  40794 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    133983; IndexCount: 300;      VertexBase:  40878 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    134283; IndexCount: 300;      VertexBase:  40964 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    134583; IndexCount: 300;      VertexBase:  41048 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    134883; IndexCount: 300;      VertexBase:  41119 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    135183; IndexCount: 300;      VertexBase:  41243 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    135483; IndexCount: 300;      VertexBase:  41314 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    135783; IndexCount: 300;      VertexBase:  41474 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    136083; IndexCount: 300;      VertexBase:  41547 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    136383; IndexCount: 300;      VertexBase:  41631 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    136683; IndexCount: 300;      VertexBase:  41717 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    136983; IndexCount: 300;      VertexBase:  41801 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    137283; IndexCount: 300;      VertexBase:  41872 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    137583; IndexCount: 300;      VertexBase:  41996 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    137883; IndexCount: 300;      VertexBase:  42069 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    138183; IndexCount: 300;      VertexBase:  42153 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    138483; IndexCount: 300;      VertexBase:  42239 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    138783; IndexCount: 300;      VertexBase:  42323 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    139083; IndexCount: 300;      VertexBase:  42394 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    139383; IndexCount: 300;      VertexBase:  42554 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    139683; IndexCount: 300;      VertexBase:  42627 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    139983; IndexCount: 300;      VertexBase:  42711 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    140283; IndexCount: 300;      VertexBase:  42797 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    140583; IndexCount: 300;      VertexBase:  42881 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    140883; IndexCount: 300;      VertexBase:  42952 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    141183; IndexCount: 300;      VertexBase:  43076 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    141483; IndexCount: 300;      VertexBase:  43149 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    141783; IndexCount: 300;      VertexBase:  43349 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    142083; IndexCount: 300;      VertexBase:  43551 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    142383; IndexCount: 300;      VertexBase:  43751 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    142683; IndexCount: 300;      VertexBase:  43951 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    142983; IndexCount: 300;      VertexBase:  44151 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    143283; IndexCount: 300;      VertexBase:  44351 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    143583; IndexCount: 300;      VertexBase:  44551 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    143883; IndexCount: 300;      VertexBase:  44751 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    144183; IndexCount: 300;      VertexBase:  44951 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    144483; IndexCount: 300;      VertexBase:  45153 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    144783; IndexCount: 300;      VertexBase:  45353 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    145083; IndexCount: 300;      VertexBase:  45553 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    145383; IndexCount: 300;      VertexBase:  45753 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    145683; IndexCount: 300;      VertexBase:  45953 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    145983; IndexCount: 300;      VertexBase:  46153 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    146283; IndexCount: 300;      VertexBase:  46353 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    146583; IndexCount: 300;      VertexBase:  46553 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    146883; IndexCount: 300;      VertexBase:  46755 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    147183; IndexCount: 300;      VertexBase:  46955 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    147483; IndexCount: 300;      VertexBase:  47155 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    147783; IndexCount: 300;      VertexBase:  47355 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    148083; IndexCount: 300;      VertexBase:  47555 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    148383; IndexCount: 300;      VertexBase:  47755 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    148683; IndexCount: 300;      VertexBase:  47955 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    148983; IndexCount: 300;      VertexBase:  48155 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    149283; IndexCount: 300;      VertexBase:  48355 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    149583; IndexCount: 300;      VertexBase:  48557 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    149883; IndexCount: 300;      VertexBase:  48757 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    150183; IndexCount: 300;      VertexBase:  48957 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    150483; IndexCount: 300;      VertexBase:  49157 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    150783; IndexCount: 216;      VertexBase:  49357 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    150999; IndexCount: 216;      VertexBase:  49455 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    151215; IndexCount: 216;      VertexBase:  49553 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    151431; IndexCount: 1014;      VertexBase:  49651 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    152445; IndexCount: 216;      VertexBase:  49929 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    152661; IndexCount: 1014;      VertexBase:  50029 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    153675; IndexCount: 1014;      VertexBase:  50324 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    154689; IndexCount: 1014;      VertexBase:  50614 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    155703; IndexCount: 588;      VertexBase:  50894 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    156291; IndexCount: 5574;      VertexBase:  51104 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    161865; IndexCount: 588;      VertexBase:  52700 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    162453; IndexCount: 588;      VertexBase:  52910 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 22; NormalTextureIndex:  23; SpecularTextureIndex: -1;    IndexStart:    163041; IndexCount: 588;      VertexBase:  53120 ),  // subset0_RaceCar_Strorage_Diff
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    163629; IndexCount: 48;      VertexBase:  53330 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    163677; IndexCount: 501;      VertexBase:  53362 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    164178; IndexCount: 252;      VertexBase:  53471 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    164430; IndexCount: 48;      VertexBase:  53520 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    164478; IndexCount: 1620;      VertexBase:  53552 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    166098; IndexCount: 3978;      VertexBase:  53850 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    170076; IndexCount: 765;      VertexBase:  54754 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    170841; IndexCount: 900;      VertexBase:  54906 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    171741; IndexCount: 1260;      VertexBase:  55154 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    173001; IndexCount: 408;      VertexBase:  55431 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    173409; IndexCount: 765;      VertexBase:  55546 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    174174; IndexCount: 720;      VertexBase:  55694 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    174894; IndexCount: 252;      VertexBase:  55894 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    175146; IndexCount: 252;      VertexBase:  55943 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    175398; IndexCount: 252;      VertexBase:  55992 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    175650; IndexCount: 252;      VertexBase:  56041 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    175902; IndexCount: 252;      VertexBase:  56090 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    176154; IndexCount: 252;      VertexBase:  56139 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    176406; IndexCount: 252;      VertexBase:  56188 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    176658; IndexCount: 252;      VertexBase:  56237 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 26; NormalTextureIndex:  27; SpecularTextureIndex: -1;    IndexStart:    176910; IndexCount: 48;      VertexBase:  56286 ),  // subset0_Hats_1
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    176958; IndexCount: 6792;      VertexBase:  56318 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    183750; IndexCount: 2124;      VertexBase:  57790 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    185874; IndexCount: 2268;      VertexBase:  58361 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    188142; IndexCount: 66;      VertexBase:  58938 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    188208; IndexCount: 270;      VertexBase:  58973 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    188478; IndexCount: 48;      VertexBase:  59080 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    188526; IndexCount: 66;      VertexBase:  59111 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    188592; IndexCount: 60;      VertexBase:  59148 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    188652; IndexCount: 66;      VertexBase:  59178 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    188718; IndexCount: 168;      VertexBase:  59215 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    188886; IndexCount: 168;      VertexBase:  59275 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    189054; IndexCount: 174;      VertexBase:  59333 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    189228; IndexCount: 1650;      VertexBase:  59418 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    190878; IndexCount: 918;      VertexBase:  59867 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    191796; IndexCount: 426;      VertexBase:  60089 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 26; NormalTextureIndex:  27; SpecularTextureIndex: -1;    IndexStart:    192222; IndexCount: 1209;      VertexBase:  60211 ),  // subset0_Hats_1
 ( DiffuseTextureIndex: 24; NormalTextureIndex:  25; SpecularTextureIndex: -1;    IndexStart:    193431; IndexCount: 180;      VertexBase:  60506 ),  // subset0_hats_2
 ( DiffuseTextureIndex: 26; NormalTextureIndex:  27; SpecularTextureIndex: -1;    IndexStart:    193611; IndexCount: 714;      VertexBase:  60571 ),  // subset0_Hats_1
 ( DiffuseTextureIndex: 26; NormalTextureIndex:  27; SpecularTextureIndex: -1;    IndexStart:    194325; IndexCount: 426;      VertexBase:  60759 ),  // subset0_Hats_1
 ( DiffuseTextureIndex: 26; NormalTextureIndex:  27; SpecularTextureIndex: -1;    IndexStart:    194751; IndexCount: 426;      VertexBase:  60888 ),  // subset0_Hats_1
 ( DiffuseTextureIndex: 26; NormalTextureIndex:  27; SpecularTextureIndex: -1;    IndexStart:    195177; IndexCount: 432;      VertexBase:  61010 ),  // subset0_Hats_1
 ( DiffuseTextureIndex: 26; NormalTextureIndex:  27; SpecularTextureIndex: -1;    IndexStart:    195609; IndexCount: 432;      VertexBase:  61147 ),  // subset0_Hats_1
 ( DiffuseTextureIndex: 26; NormalTextureIndex:  27; SpecularTextureIndex: -1;    IndexStart:    196041; IndexCount: 1608;      VertexBase:  61268 ),  // subset0_Hats_1
 ( DiffuseTextureIndex: 28; NormalTextureIndex:  29; SpecularTextureIndex: -1;    IndexStart:    197649; IndexCount: 18219;      VertexBase:  61783 ),  // subset0_Misc_Boss_1
 ( DiffuseTextureIndex: 16; NormalTextureIndex:  17; SpecularTextureIndex: -1;    IndexStart:    215868; IndexCount: 2484;      VertexBase:  69708 ),  // subset0_Stack__Boxes_Diff01
 ( DiffuseTextureIndex: 16; NormalTextureIndex:  17; SpecularTextureIndex: -1;    IndexStart:    218352; IndexCount: 2409;      VertexBase:  71274 ),  // subset0_Stack__Boxes_Diff01
 ( DiffuseTextureIndex: 16; NormalTextureIndex:  17; SpecularTextureIndex: -1;    IndexStart:    220761; IndexCount: 2409;      VertexBase:  72652 ),  // subset0_Stack__Boxes_Diff01
 ( DiffuseTextureIndex: 16; NormalTextureIndex:  17; SpecularTextureIndex: -1;    IndexStart:    223170; IndexCount: 2409;      VertexBase:  74026 ),  // subset0_Stack__Boxes_Diff01
 ( DiffuseTextureIndex: 16; NormalTextureIndex:  17; SpecularTextureIndex: -1;    IndexStart:    225579; IndexCount: 1833;      VertexBase:  75404 ),  // subset0_Stack__Boxes_Diff01
 ( DiffuseTextureIndex: 30; NormalTextureIndex:  31; SpecularTextureIndex: -1;    IndexStart:    227412; IndexCount: 3867;      VertexBase:  76541 ),  // subset0_gameCrates_03_Diff
 ( DiffuseTextureIndex: 30; NormalTextureIndex:  31; SpecularTextureIndex: -1;    IndexStart:    231279; IndexCount: 3750;      VertexBase:  78113 ),  // subset0_gameCrates_03_Diff
 ( DiffuseTextureIndex: 16; NormalTextureIndex:  17; SpecularTextureIndex: -1;    IndexStart:    235029; IndexCount: 2409;      VertexBase:  79856 ),  // subset0_Stack__Boxes_Diff01
 ( DiffuseTextureIndex: 16; NormalTextureIndex:  17; SpecularTextureIndex: -1;    IndexStart:    237438; IndexCount: 2409;      VertexBase:  81222 ),  // subset0_Stack__Boxes_Diff01
 ( DiffuseTextureIndex: 30; NormalTextureIndex:  31; SpecularTextureIndex: -1;    IndexStart:    239847; IndexCount: 12468;      VertexBase:  82594 ),  // subset0_gameCrates_03_Diff
 ( DiffuseTextureIndex: 30; NormalTextureIndex:  31; SpecularTextureIndex: -1;    IndexStart:    252315; IndexCount: 3441;      VertexBase:  88547 ),  // subset0_gameCrates_03_Diff
 ( DiffuseTextureIndex: 32; NormalTextureIndex:  32; SpecularTextureIndex: -1;    IndexStart:    255756; IndexCount: 1932;      VertexBase:  89479 ),  // subset0_gameCrates_02_Diff
 ( DiffuseTextureIndex: 14; NormalTextureIndex:  15; SpecularTextureIndex: -1;    IndexStart:    257688; IndexCount: 984;      VertexBase:  89905 ),  // subset0_Stack__Boxes_Diff03
 ( DiffuseTextureIndex: 14; NormalTextureIndex:  15; SpecularTextureIndex: -1;    IndexStart:    258672; IndexCount: 741;      VertexBase:  90403 ),  // subset0_Stack__Boxes_Diff03
 ( DiffuseTextureIndex: 14; NormalTextureIndex:  15; SpecularTextureIndex: -1;    IndexStart:    259413; IndexCount: 426;      VertexBase:  90727 ),  // subset0_Stack__Boxes_Diff03
 ( DiffuseTextureIndex: 32; NormalTextureIndex:  32; SpecularTextureIndex: -1;    IndexStart:    259839; IndexCount: 1419;      VertexBase:  90932 ),  // subset0_gameCrates_02_Diff
 ( DiffuseTextureIndex: 18; NormalTextureIndex:  19; SpecularTextureIndex: -1;    IndexStart:    261258; IndexCount: 3090;      VertexBase:  91251 ),  // subset0_Back_Alley_box
 ( DiffuseTextureIndex: 14; NormalTextureIndex:  15; SpecularTextureIndex: -1;    IndexStart:    264348; IndexCount: 573;      VertexBase:  92286 ),  // subset0_Stack__Boxes_Diff03
 ( DiffuseTextureIndex: 32; NormalTextureIndex:  32; SpecularTextureIndex: -1;    IndexStart:    264921; IndexCount: 1176;      VertexBase:  92524 ),  // subset0_gameCrates_02_Diff
 ( DiffuseTextureIndex: 32; NormalTextureIndex:  32; SpecularTextureIndex: -1;    IndexStart:    266097; IndexCount: 792;      VertexBase:  92809 ),  // subset0_gameCrates_02_Diff
 ( DiffuseTextureIndex: 14; NormalTextureIndex:  15; SpecularTextureIndex: -1;    IndexStart:    266889; IndexCount: 573;      VertexBase:  93047 ),  // subset0_Stack__Boxes_Diff03
 ( DiffuseTextureIndex: 14; NormalTextureIndex:  15; SpecularTextureIndex: -1;    IndexStart:    267462; IndexCount: 741;      VertexBase:  93285 ),  // subset0_Stack__Boxes_Diff03
 ( DiffuseTextureIndex: 18; NormalTextureIndex:  19; SpecularTextureIndex: -1;    IndexStart:    268203; IndexCount: 1620;      VertexBase:  93609 ),  // subset0_Back_Alley_box
 ( DiffuseTextureIndex: 14; NormalTextureIndex:  15; SpecularTextureIndex: -1;    IndexStart:    269823; IndexCount: 396;      VertexBase:  94126 ),  // subset0_Stack__Boxes_Diff03
 ( DiffuseTextureIndex: 14; NormalTextureIndex:  15; SpecularTextureIndex: -1;    IndexStart:    270219; IndexCount: 396;      VertexBase:  94281 ),  // subset0_Stack__Boxes_Diff03
 ( DiffuseTextureIndex: 14; NormalTextureIndex:  15; SpecularTextureIndex: -1;    IndexStart:    270615; IndexCount: 396;      VertexBase:  94436 ),  // subset0_Stack__Boxes_Diff03
 ( DiffuseTextureIndex: 32; NormalTextureIndex:  32; SpecularTextureIndex: -1;    IndexStart:    271011; IndexCount: 1008;      VertexBase:  94591 ),  // subset0_gameCrates_02_Diff
 ( DiffuseTextureIndex: 32; NormalTextureIndex:  32; SpecularTextureIndex: -1;    IndexStart:    272019; IndexCount: 2040;      VertexBase:  94830 ),  // subset0_gameCrates_02_Diff
 ( DiffuseTextureIndex: 14; NormalTextureIndex:  15; SpecularTextureIndex: -1;    IndexStart:    274059; IndexCount: 468;      VertexBase:  95269 ),  // subset0_Stack__Boxes_Diff03
 ( DiffuseTextureIndex: 32; NormalTextureIndex:  32; SpecularTextureIndex: -1;    IndexStart:    274527; IndexCount: 1236;      VertexBase:  95437 ),  // subset0_gameCrates_02_Diff
 ( DiffuseTextureIndex: 32; NormalTextureIndex:  32; SpecularTextureIndex: -1;    IndexStart:    275763; IndexCount: 903;      VertexBase:  95726 ),  // subset0_gameCrates_02_Diff
 ( DiffuseTextureIndex: 32; NormalTextureIndex:  32; SpecularTextureIndex: -1;    IndexStart:    276666; IndexCount: 1884;      VertexBase:  95942 ),  // subset0_gameCrates_02_Diff
 ( DiffuseTextureIndex: 32; NormalTextureIndex:  32; SpecularTextureIndex: -1;    IndexStart:    278550; IndexCount: 2088;      VertexBase:  96353 ),  // subset0_gameCrates_02_Diff
 ( DiffuseTextureIndex: 32; NormalTextureIndex:  32; SpecularTextureIndex: -1;    IndexStart:    280638; IndexCount: 1008;      VertexBase:  96827 ),  // subset0_gameCrates_02_Diff
 ( DiffuseTextureIndex: 33; NormalTextureIndex:  34; SpecularTextureIndex: -1;    IndexStart:    281646; IndexCount: 1920;      VertexBase:  97063 ),  // subset0_Back_Alley_Drum
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    283566; IndexCount: 7809;      VertexBase:  97728 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    291375; IndexCount: 8172;      VertexBase:  99390 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    299547; IndexCount: 12;      VertexBase:  101144 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    299559; IndexCount: 132;      VertexBase:  101150 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    299691; IndexCount: 132;      VertexBase:  101218 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    299823; IndexCount: 228;      VertexBase:  101286 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    300051; IndexCount: 228;      VertexBase:  101382 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    300279; IndexCount: 228;      VertexBase:  101485 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    300507; IndexCount: 228;      VertexBase:  101581 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    300735; IndexCount: 228;      VertexBase:  101689 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    300963; IndexCount: 228;      VertexBase:  101785 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    301191; IndexCount: 852;      VertexBase:  101881 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    302043; IndexCount: 702;      VertexBase:  102217 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    302745; IndexCount: 372;      VertexBase:  102461 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    303117; IndexCount: 564;      VertexBase:  102637 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    303681; IndexCount: 324;      VertexBase:  102857 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    304005; IndexCount: 324;      VertexBase:  102977 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 37; NormalTextureIndex:  38; SpecularTextureIndex: -1;    IndexStart:    304329; IndexCount: 588;      VertexBase:  103097 ),  // subset0_shelves2_diff1
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    304917; IndexCount: 1122;      VertexBase:  103337 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    306039; IndexCount: 888;      VertexBase:  103622 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    306927; IndexCount: 96;      VertexBase:  103854 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    307023; IndexCount: 96;      VertexBase:  103902 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    307119; IndexCount: 102;      VertexBase:  103947 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    307221; IndexCount: 96;      VertexBase:  103987 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    307317; IndexCount: 96;      VertexBase:  104032 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    307413; IndexCount: 576;      VertexBase:  104078 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    307989; IndexCount: 78;      VertexBase:  104208 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    308067; IndexCount: 102;      VertexBase:  104240 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    308169; IndexCount: 72;      VertexBase:  104284 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    308241; IndexCount: 336;      VertexBase:  104315 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    308577; IndexCount: 144;      VertexBase:  104450 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    308721; IndexCount: 120;      VertexBase:  104490 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    308841; IndexCount: 144;      VertexBase:  104518 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    308985; IndexCount: 120;      VertexBase:  104558 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    309105; IndexCount: 126;      VertexBase:  104586 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    309231; IndexCount: 120;      VertexBase:  104624 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    309351; IndexCount: 144;      VertexBase:  104652 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    309495; IndexCount: 117;      VertexBase:  104692 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 6; NormalTextureIndex:  7; SpecularTextureIndex: -1;    IndexStart:    309612; IndexCount: 1572;      VertexBase:  104720 ),  // subset0_shelves1_diff2
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    311184; IndexCount: 540;      VertexBase:  105150 ),  // subset0_marbel_drum_blinn
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    311724; IndexCount: 2136;      VertexBase:  105282 ),  // subset0_marbel_drum_blinn
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    313860; IndexCount: 24;      VertexBase:  105899 ),  // subset0_marbel_drum_blinn
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    313884; IndexCount: 24;      VertexBase:  105911 ),  // subset0_marbel_drum_blinn
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    313908; IndexCount: 27;      VertexBase:  105923 ),  // subset0_marbel_drum_blinn
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    313935; IndexCount: 2964;      VertexBase:  105936 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    316899; IndexCount: 2964;      VertexBase:  106458 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    319863; IndexCount: 702;      VertexBase:  106980 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    320565; IndexCount: 702;      VertexBase:  107117 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    321267; IndexCount: 702;      VertexBase:  107249 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    321969; IndexCount: 702;      VertexBase:  107379 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    322671; IndexCount: 2964;      VertexBase:  107511 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    325635; IndexCount: 6;      VertexBase:  108033 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    325641; IndexCount: 432;      VertexBase:  108037 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    326073; IndexCount: 429;      VertexBase:  108130 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    326502; IndexCount: 2964;      VertexBase:  108216 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    329466; IndexCount: 2106;      VertexBase:  108738 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    331572; IndexCount: 2106;      VertexBase:  109129 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    333678; IndexCount: 429;      VertexBase:  109515 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    334107; IndexCount: 1794;      VertexBase:  109614 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    335901; IndexCount: 2262;      VertexBase:  109948 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    338163; IndexCount: 2964;      VertexBase:  110365 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    341127; IndexCount: 2964;      VertexBase:  110880 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    344091; IndexCount: 2964;      VertexBase:  111402 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    347055; IndexCount: 2730;      VertexBase:  111919 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    349785; IndexCount: 2964;      VertexBase:  112407 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    352749; IndexCount: 2964;      VertexBase:  112929 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    355713; IndexCount: 2964;      VertexBase:  113444 ),  // subset0_marbel_drum_phong
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    358677; IndexCount: 3276;      VertexBase:  113961 ),  // subset0_marbel_drum_blinn
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    361953; IndexCount: 780;      VertexBase:  114605 ),  // subset0_marbel_drum_blinn
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    362733; IndexCount: 936;      VertexBase:  114773 ),  // subset0_marbel_drum_blinn
 ( DiffuseTextureIndex: 39; NormalTextureIndex:  40; SpecularTextureIndex: -1;    IndexStart:    363669; IndexCount: 936;      VertexBase:  114969 ),  // subset0_marbel_drum_blinn
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    364605; IndexCount: 108;      VertexBase:  115165 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    364713; IndexCount: 81;      VertexBase:  115185 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    364794; IndexCount: 81;      VertexBase:  115225 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    364875; IndexCount: 81;      VertexBase:  115255 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    364956; IndexCount: 81;      VertexBase:  115287 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    365037; IndexCount: 108;      VertexBase:  115328 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    365145; IndexCount: 81;      VertexBase:  115348 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    365226; IndexCount: 81;      VertexBase:  115388 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    365307; IndexCount: 81;      VertexBase:  115418 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    365388; IndexCount: 108;      VertexBase:  115450 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    365496; IndexCount: 81;      VertexBase:  115470 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    365577; IndexCount: 108;      VertexBase:  115510 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    365685; IndexCount: 81;      VertexBase:  115530 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    365766; IndexCount: 81;      VertexBase:  115570 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    365847; IndexCount: 81;      VertexBase:  115602 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    365928; IndexCount: 108;      VertexBase:  115641 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    366036; IndexCount: 81;      VertexBase:  115669 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    366117; IndexCount: 81;      VertexBase:  115709 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    366198; IndexCount: 81;      VertexBase:  115741 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    366279; IndexCount: 108;      VertexBase:  115780 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    366387; IndexCount: 81;      VertexBase:  115808 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    366468; IndexCount: 81;      VertexBase:  115847 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    366549; IndexCount: 81;      VertexBase:  115879 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    366630; IndexCount: 81;      VertexBase:  115909 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    366711; IndexCount: 108;      VertexBase:  115948 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    366819; IndexCount: 81;      VertexBase:  115976 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    366900; IndexCount: 81;      VertexBase:  116006 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    366981; IndexCount: 108;      VertexBase:  116038 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    367089; IndexCount: 81;      VertexBase:  116066 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    367170; IndexCount: 81;      VertexBase:  116105 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    367251; IndexCount: 108;      VertexBase:  116137 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    367359; IndexCount: 81;      VertexBase:  116165 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    367440; IndexCount: 81;      VertexBase:  116204 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    367521; IndexCount: 237;      VertexBase:  116234 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    367758; IndexCount: 216;      VertexBase:  116293 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    367974; IndexCount: 216;      VertexBase:  116348 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    368190; IndexCount: 240;      VertexBase:  116398 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    368430; IndexCount: 216;      VertexBase:  116453 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    368646; IndexCount: 216;      VertexBase:  116503 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    368862; IndexCount: 324;      VertexBase:  116558 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    369186; IndexCount: 108;      VertexBase:  116650 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    369294; IndexCount: 324;      VertexBase:  116688 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    369618; IndexCount: 108;      VertexBase:  116780 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    369726; IndexCount: 324;      VertexBase:  116818 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    370050; IndexCount: 108;      VertexBase:  116910 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    370158; IndexCount: 324;      VertexBase:  116948 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    370482; IndexCount: 108;      VertexBase:  117040 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    370590; IndexCount: 324;      VertexBase:  117078 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    370914; IndexCount: 108;      VertexBase:  117170 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    371022; IndexCount: 324;      VertexBase:  117208 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    371346; IndexCount: 108;      VertexBase:  117300 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    371454; IndexCount: 54;      VertexBase:  117338 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    371508; IndexCount: 54;      VertexBase:  117357 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    371562; IndexCount: 54;      VertexBase:  117376 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    371616; IndexCount: 54;      VertexBase:  117395 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    371670; IndexCount: 54;      VertexBase:  117414 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    371724; IndexCount: 54;      VertexBase:  117433 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 43; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    371778; IndexCount: 120;      VertexBase:  117452 ),  // subset0_Catwalk_03_Diffuse
 ( DiffuseTextureIndex: 43; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    371898; IndexCount: 3078;      VertexBase:  117532 ),  // subset0_Catwalk_03_Diffuse
 ( DiffuseTextureIndex: 43; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    374976; IndexCount: 4356;      VertexBase:  118172 ),  // subset0_Catwalk_03_Diffuse
 ( DiffuseTextureIndex: 43; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    379332; IndexCount: 4356;      VertexBase:  119043 ),  // subset0_Catwalk_03_Diffuse
 ( DiffuseTextureIndex: 43; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    383688; IndexCount: 4356;      VertexBase:  119896 ),  // subset0_Catwalk_03_Diffuse
 ( DiffuseTextureIndex: 43; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    388044; IndexCount: 3636;      VertexBase:  120749 ),  // subset0_Catwalk_03_Diffuse
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    391680; IndexCount: 72;      VertexBase:  121481 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    391752; IndexCount: 162;      VertexBase:  121513 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    391914; IndexCount: 324;      VertexBase:  121553 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    392238; IndexCount: 144;      VertexBase:  121630 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    392382; IndexCount: 144;      VertexBase:  121665 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    392526; IndexCount: 162;      VertexBase:  121705 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    392688; IndexCount: 324;      VertexBase:  121745 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    393012; IndexCount: 144;      VertexBase:  121822 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    393156; IndexCount: 144;      VertexBase:  121857 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    393300; IndexCount: 162;      VertexBase:  121897 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    393462; IndexCount: 360;      VertexBase:  121937 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    393822; IndexCount: 144;      VertexBase:  122014 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    393966; IndexCount: 144;      VertexBase:  122049 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    394110; IndexCount: 162;      VertexBase:  122084 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    394272; IndexCount: 324;      VertexBase:  122124 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    394596; IndexCount: 153;      VertexBase:  122194 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    394749; IndexCount: 144;      VertexBase:  122234 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    394893; IndexCount: 162;      VertexBase:  122269 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    395055; IndexCount: 324;      VertexBase:  122309 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    395379; IndexCount: 144;      VertexBase:  122379 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    395523; IndexCount: 144;      VertexBase:  122419 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    395667; IndexCount: 162;      VertexBase:  122459 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    395829; IndexCount: 324;      VertexBase:  122503 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    396153; IndexCount: 150;      VertexBase:  122573 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    396303; IndexCount: 144;      VertexBase:  122621 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    396447; IndexCount: 162;      VertexBase:  122661 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    396609; IndexCount: 324;      VertexBase:  122701 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    396933; IndexCount: 144;      VertexBase:  122778 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    397077; IndexCount: 144;      VertexBase:  122818 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    397221; IndexCount: 162;      VertexBase:  122853 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    397383; IndexCount: 324;      VertexBase:  122897 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    397707; IndexCount: 141;      VertexBase:  122967 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    397848; IndexCount: 144;      VertexBase:  123006 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    397992; IndexCount: 162;      VertexBase:  123041 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    398154; IndexCount: 19506;      VertexBase:  123085 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    417660; IndexCount: 19506;      VertexBase:  129867 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 43; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    437166; IndexCount: 120;      VertexBase:  136640 ),  // subset0_Catwalk_03_Diffuse
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437286; IndexCount: 72;      VertexBase:  136720 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437358; IndexCount: 24;      VertexBase:  136752 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437382; IndexCount: 24;      VertexBase:  136768 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437406; IndexCount: 24;      VertexBase:  136784 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437430; IndexCount: 24;      VertexBase:  136800 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437454; IndexCount: 24;      VertexBase:  136816 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437478; IndexCount: 24;      VertexBase:  136832 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437502; IndexCount: 24;      VertexBase:  136848 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437526; IndexCount: 24;      VertexBase:  136864 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437550; IndexCount: 24;      VertexBase:  136880 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437574; IndexCount: 24;      VertexBase:  136896 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437598; IndexCount: 24;      VertexBase:  136912 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437622; IndexCount: 24;      VertexBase:  136928 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437646; IndexCount: 24;      VertexBase:  136944 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437670; IndexCount: 24;      VertexBase:  136960 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437694; IndexCount: 24;      VertexBase:  136976 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437718; IndexCount: 24;      VertexBase:  136992 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437742; IndexCount: 24;      VertexBase:  137008 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437766; IndexCount: 24;      VertexBase:  137024 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437790; IndexCount: 24;      VertexBase:  137040 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437814; IndexCount: 24;      VertexBase:  137056 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437838; IndexCount: 24;      VertexBase:  137072 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437862; IndexCount: 24;      VertexBase:  137088 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437886; IndexCount: 24;      VertexBase:  137104 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437910; IndexCount: 24;      VertexBase:  137120 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437934; IndexCount: 24;      VertexBase:  137136 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437958; IndexCount: 24;      VertexBase:  137152 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    437982; IndexCount: 24;      VertexBase:  137168 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438006; IndexCount: 24;      VertexBase:  137184 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438030; IndexCount: 24;      VertexBase:  137200 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438054; IndexCount: 24;      VertexBase:  137216 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438078; IndexCount: 24;      VertexBase:  137232 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438102; IndexCount: 24;      VertexBase:  137248 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438126; IndexCount: 24;      VertexBase:  137264 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438150; IndexCount: 24;      VertexBase:  137280 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438174; IndexCount: 24;      VertexBase:  137296 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438198; IndexCount: 24;      VertexBase:  137312 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438222; IndexCount: 24;      VertexBase:  137328 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438246; IndexCount: 24;      VertexBase:  137344 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438270; IndexCount: 24;      VertexBase:  137360 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438294; IndexCount: 24;      VertexBase:  137376 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438318; IndexCount: 24;      VertexBase:  137392 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438342; IndexCount: 24;      VertexBase:  137408 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438366; IndexCount: 24;      VertexBase:  137424 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438390; IndexCount: 24;      VertexBase:  137440 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438414; IndexCount: 24;      VertexBase:  137456 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438438; IndexCount: 24;      VertexBase:  137472 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438462; IndexCount: 24;      VertexBase:  137488 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438486; IndexCount: 24;      VertexBase:  137504 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438510; IndexCount: 24;      VertexBase:  137520 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438534; IndexCount: 24;      VertexBase:  137536 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438558; IndexCount: 24;      VertexBase:  137552 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438582; IndexCount: 24;      VertexBase:  137568 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438606; IndexCount: 24;      VertexBase:  137584 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438630; IndexCount: 24;      VertexBase:  137600 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438654; IndexCount: 24;      VertexBase:  137616 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438678; IndexCount: 24;      VertexBase:  137632 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438702; IndexCount: 24;      VertexBase:  137648 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438726; IndexCount: 24;      VertexBase:  137664 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438750; IndexCount: 24;      VertexBase:  137680 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438774; IndexCount: 24;      VertexBase:  137696 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438798; IndexCount: 24;      VertexBase:  137712 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438822; IndexCount: 24;      VertexBase:  137728 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438846; IndexCount: 24;      VertexBase:  137744 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438870; IndexCount: 24;      VertexBase:  137760 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438894; IndexCount: 24;      VertexBase:  137776 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438918; IndexCount: 24;      VertexBase:  137792 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438942; IndexCount: 24;      VertexBase:  137808 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438966; IndexCount: 24;      VertexBase:  137824 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    438990; IndexCount: 24;      VertexBase:  137840 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439014; IndexCount: 24;      VertexBase:  137856 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439038; IndexCount: 24;      VertexBase:  137872 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439062; IndexCount: 24;      VertexBase:  137888 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439086; IndexCount: 24;      VertexBase:  137904 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439110; IndexCount: 24;      VertexBase:  137920 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439134; IndexCount: 24;      VertexBase:  137936 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439158; IndexCount: 24;      VertexBase:  137952 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439182; IndexCount: 24;      VertexBase:  137968 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439206; IndexCount: 24;      VertexBase:  137984 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439230; IndexCount: 24;      VertexBase:  138000 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439254; IndexCount: 24;      VertexBase:  138016 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439278; IndexCount: 24;      VertexBase:  138032 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439302; IndexCount: 24;      VertexBase:  138048 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439326; IndexCount: 24;      VertexBase:  138064 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439350; IndexCount: 24;      VertexBase:  138080 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439374; IndexCount: 24;      VertexBase:  138096 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439398; IndexCount: 24;      VertexBase:  138112 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439422; IndexCount: 24;      VertexBase:  138128 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439446; IndexCount: 24;      VertexBase:  138144 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439470; IndexCount: 24;      VertexBase:  138160 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439494; IndexCount: 24;      VertexBase:  138176 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439518; IndexCount: 24;      VertexBase:  138192 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439542; IndexCount: 24;      VertexBase:  138208 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439566; IndexCount: 24;      VertexBase:  138224 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439590; IndexCount: 24;      VertexBase:  138240 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439614; IndexCount: 24;      VertexBase:  138256 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439638; IndexCount: 24;      VertexBase:  138272 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439662; IndexCount: 24;      VertexBase:  138288 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439686; IndexCount: 24;      VertexBase:  138304 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439710; IndexCount: 24;      VertexBase:  138320 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439734; IndexCount: 24;      VertexBase:  138336 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439758; IndexCount: 24;      VertexBase:  138352 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439782; IndexCount: 24;      VertexBase:  138368 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439806; IndexCount: 24;      VertexBase:  138384 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439830; IndexCount: 24;      VertexBase:  138400 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439854; IndexCount: 24;      VertexBase:  138416 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439878; IndexCount: 24;      VertexBase:  138432 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439902; IndexCount: 24;      VertexBase:  138448 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439926; IndexCount: 24;      VertexBase:  138464 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439950; IndexCount: 24;      VertexBase:  138480 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439974; IndexCount: 24;      VertexBase:  138496 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    439998; IndexCount: 24;      VertexBase:  138512 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440022; IndexCount: 24;      VertexBase:  138528 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440046; IndexCount: 24;      VertexBase:  138544 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440070; IndexCount: 24;      VertexBase:  138560 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440094; IndexCount: 24;      VertexBase:  138576 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440118; IndexCount: 24;      VertexBase:  138592 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440142; IndexCount: 24;      VertexBase:  138608 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440166; IndexCount: 24;      VertexBase:  138624 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440190; IndexCount: 24;      VertexBase:  138640 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440214; IndexCount: 24;      VertexBase:  138656 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440238; IndexCount: 24;      VertexBase:  138672 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440262; IndexCount: 24;      VertexBase:  138688 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440286; IndexCount: 24;      VertexBase:  138704 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440310; IndexCount: 24;      VertexBase:  138720 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440334; IndexCount: 24;      VertexBase:  138736 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440358; IndexCount: 24;      VertexBase:  138752 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440382; IndexCount: 24;      VertexBase:  138768 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440406; IndexCount: 24;      VertexBase:  138784 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440430; IndexCount: 24;      VertexBase:  138800 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440454; IndexCount: 24;      VertexBase:  138816 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440478; IndexCount: 24;      VertexBase:  138832 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440502; IndexCount: 24;      VertexBase:  138848 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440526; IndexCount: 24;      VertexBase:  138864 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440550; IndexCount: 24;      VertexBase:  138880 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440574; IndexCount: 24;      VertexBase:  138896 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440598; IndexCount: 24;      VertexBase:  138912 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440622; IndexCount: 24;      VertexBase:  138928 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440646; IndexCount: 24;      VertexBase:  138944 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440670; IndexCount: 24;      VertexBase:  138960 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440694; IndexCount: 24;      VertexBase:  138976 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440718; IndexCount: 24;      VertexBase:  138992 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440742; IndexCount: 24;      VertexBase:  139008 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440766; IndexCount: 24;      VertexBase:  139024 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440790; IndexCount: 24;      VertexBase:  139040 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440814; IndexCount: 24;      VertexBase:  139056 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440838; IndexCount: 24;      VertexBase:  139072 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440862; IndexCount: 24;      VertexBase:  139088 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440886; IndexCount: 24;      VertexBase:  139104 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440910; IndexCount: 24;      VertexBase:  139120 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440934; IndexCount: 24;      VertexBase:  139136 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440958; IndexCount: 24;      VertexBase:  139152 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    440982; IndexCount: 24;      VertexBase:  139168 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    441006; IndexCount: 24;      VertexBase:  139184 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    441030; IndexCount: 24;      VertexBase:  139200 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    441054; IndexCount: 24;      VertexBase:  139216 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    441078; IndexCount: 24;      VertexBase:  139232 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    441102; IndexCount: 24;      VertexBase:  139248 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    441126; IndexCount: 24;      VertexBase:  139264 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    441150; IndexCount: 24;      VertexBase:  139280 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    441174; IndexCount: 24;      VertexBase:  139296 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    441198; IndexCount: 24;      VertexBase:  139312 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    441222; IndexCount: 24;      VertexBase:  139328 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    441246; IndexCount: 24;      VertexBase:  139344 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 41; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    441270; IndexCount: 24;      VertexBase:  139360 ),  // subset0_blinnCatwalk
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    441294; IndexCount: 2826;      VertexBase:  139376 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    444120; IndexCount: 2637;      VertexBase:  139376 ),  // subset1_shelves2_diff_0
 ( DiffuseTextureIndex: 14; NormalTextureIndex:  15; SpecularTextureIndex: -1;    IndexStart:    446757; IndexCount: 636;      VertexBase:  139376 ),  // subset2_Stack__Boxes_Diff03_0
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    447393; IndexCount: 24;      VertexBase:  141190 ),  // subset0_blinn46
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    447417; IndexCount: 306;      VertexBase:  141206 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    447723; IndexCount: 306;      VertexBase:  141325 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    448029; IndexCount: 306;      VertexBase:  141443 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    448335; IndexCount: 306;      VertexBase:  141561 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    448641; IndexCount: 216;      VertexBase:  141677 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    448857; IndexCount: 1812;      VertexBase:  141759 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    450669; IndexCount: 306;      VertexBase:  142479 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    450975; IndexCount: 222;      VertexBase:  142604 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    451197; IndexCount: 132;      VertexBase:  142704 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    451329; IndexCount: 222;      VertexBase:  142754 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    451551; IndexCount: 306;      VertexBase:  142854 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    451857; IndexCount: 132;      VertexBase:  142975 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    451989; IndexCount: 222;      VertexBase:  143025 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    452211; IndexCount: 306;      VertexBase:  143125 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    452517; IndexCount: 306;      VertexBase:  143247 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    452823; IndexCount: 132;      VertexBase:  143370 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    452955; IndexCount: 222;      VertexBase:  143420 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    453177; IndexCount: 132;      VertexBase:  143520 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    453309; IndexCount: 1368;      VertexBase:  143570 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    454677; IndexCount: 2484;      VertexBase:  143914 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    457161; IndexCount: 5790;      VertexBase:  144731 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    462951; IndexCount: 1836;      VertexBase:  147045 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    464787; IndexCount: 3816;      VertexBase:  147679 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    468603; IndexCount: 54240;      VertexBase:  149038 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    522843; IndexCount: 792;      VertexBase:  158991 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    523635; IndexCount: 792;      VertexBase:  159136 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    524427; IndexCount: 216;      VertexBase:  159281 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    524643; IndexCount: 216;      VertexBase:  159363 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 46; NormalTextureIndex:  47; SpecularTextureIndex: -1;    IndexStart:    524859; IndexCount: 216;      VertexBase:  159445 ),  // subset0_phongMisc_Boss_3_2048
 ( DiffuseTextureIndex: 48; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    525075; IndexCount: 1050;      VertexBase:  159527 ),  // subset0_LightBulbsColor
 ( DiffuseTextureIndex: 49; NormalTextureIndex:  50; SpecularTextureIndex: -1;    IndexStart:    526125; IndexCount: 1128;      VertexBase:  159773 ),  // subset0_Hanghing_Light
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    527253; IndexCount: 540;      VertexBase:  160003 ),  // subset0_lambert1
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    527793; IndexCount: 225;      VertexBase:  160123 ),  // subset0_lambert1
 ( DiffuseTextureIndex: 49; NormalTextureIndex:  50; SpecularTextureIndex: -1;    IndexStart:    528018; IndexCount: 2160;      VertexBase:  160202 ),  // subset0_Hanghing_Light
 ( DiffuseTextureIndex: 48; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    530178; IndexCount: 1050;      VertexBase:  160707 ),  // subset0_LightBulbsColor
 ( DiffuseTextureIndex: 49; NormalTextureIndex:  50; SpecularTextureIndex: -1;    IndexStart:    531228; IndexCount: 1128;      VertexBase:  160966 ),  // subset0_Hanghing_Light
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    532356; IndexCount: 540;      VertexBase:  161197 ),  // subset0_lambert1
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  11; SpecularTextureIndex: -1;    IndexStart:    532896; IndexCount: 225;      VertexBase:  161317 ),  // subset0_lambert1
 ( DiffuseTextureIndex: 49; NormalTextureIndex:  50; SpecularTextureIndex: -1;    IndexStart:    533121; IndexCount: 2160;      VertexBase:  161391 ),  // subset0_Hanghing_Light
 ( DiffuseTextureIndex: 48; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    535281; IndexCount: 1134;      VertexBase:  161896 ),  // subset0_LightBulbsColor
 ( DiffuseTextureIndex: 49; NormalTextureIndex:  50; SpecularTextureIndex: -1;    IndexStart:    536415; IndexCount: 1128;      VertexBase:  162168 ),  // subset0_Hanghing_Light
 ( DiffuseTextureIndex: 49; NormalTextureIndex:  50; SpecularTextureIndex: -1;    IndexStart:    537543; IndexCount: 600;      VertexBase:  162399 ),  // subset0_Hanghing_Light
 ( DiffuseTextureIndex: 49; NormalTextureIndex:  50; SpecularTextureIndex: -1;    IndexStart:    538143; IndexCount: 225;      VertexBase:  162531 ),  // subset0_Hanghing_Light
 ( DiffuseTextureIndex: 49; NormalTextureIndex:  50; SpecularTextureIndex: -1;    IndexStart:    538368; IndexCount: 2160;      VertexBase:  162610 ),  // subset0_Hanghing_Light
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    540528; IndexCount: 498;      VertexBase:  163115 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    541026; IndexCount: 300;      VertexBase:  163321 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    541326; IndexCount: 300;      VertexBase:  163400 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    541626; IndexCount: 600;      VertexBase:  163479 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    542226; IndexCount: 681;      VertexBase:  163604 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    542907; IndexCount: 300;      VertexBase:  163755 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    543207; IndexCount: 300;      VertexBase:  163834 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    543507; IndexCount: 144;      VertexBase:  163913 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    543651; IndexCount: 780;      VertexBase:  163949 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    544431; IndexCount: 168;      VertexBase:  164135 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    544599; IndexCount: 156;      VertexBase:  164197 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    544755; IndexCount: 390;      VertexBase:  164255 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    545145; IndexCount: 3702;      VertexBase:  164393 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    548847; IndexCount: 468;      VertexBase:  165239 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    549315; IndexCount: 1128;      VertexBase:  165324 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    550443; IndexCount: 810;      VertexBase:  165562 ),  // subset0_Hanging_bundle
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    551253; IndexCount: 714;      VertexBase:  165819 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    551967; IndexCount: 540;      VertexBase:  165949 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    552507; IndexCount: 1080;      VertexBase:  166048 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    553587; IndexCount: 1080;      VertexBase:  166242 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    554667; IndexCount: 540;      VertexBase:  166436 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    555207; IndexCount: 540;      VertexBase:  166535 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    555747; IndexCount: 1080;      VertexBase:  166642 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    556827; IndexCount: 540;      VertexBase:  166836 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    557367; IndexCount: 1080;      VertexBase:  166935 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    558447; IndexCount: 1080;      VertexBase:  167129 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    559527; IndexCount: 540;      VertexBase:  167323 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    560067; IndexCount: 1080;      VertexBase:  167422 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    561147; IndexCount: 1080;      VertexBase:  167616 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    562227; IndexCount: 1080;      VertexBase:  167810 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    563307; IndexCount: 1080;      VertexBase:  168001 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    564387; IndexCount: 714;      VertexBase:  168195 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    565101; IndexCount: 1080;      VertexBase:  168325 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    566181; IndexCount: 540;      VertexBase:  168519 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    566721; IndexCount: 540;      VertexBase:  168618 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    567261; IndexCount: 540;      VertexBase:  168719 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    567801; IndexCount: 1080;      VertexBase:  168818 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    568881; IndexCount: 540;      VertexBase:  169012 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    569421; IndexCount: 1080;      VertexBase:  169111 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    570501; IndexCount: 540;      VertexBase:  169305 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    571041; IndexCount: 714;      VertexBase:  169404 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    571755; IndexCount: 1080;      VertexBase:  169534 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    572835; IndexCount: 1080;      VertexBase:  169728 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    573915; IndexCount: 540;      VertexBase:  169922 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    574455; IndexCount: 540;      VertexBase:  170021 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 52; NormalTextureIndex:  53; SpecularTextureIndex: -1;    IndexStart:    574995; IndexCount: 1080;      VertexBase:  170120 ),  // subset0_Hanging_bundle_marble
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    576075; IndexCount: 17184;      VertexBase:  170314 ),  // subset0_Rope
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    593259; IndexCount: 576;      VertexBase:  176140 ),  // subset0_Rope
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    593835; IndexCount: 2556;      VertexBase:  176293 ),  // subset0_Rope
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    596391; IndexCount: 4032;      VertexBase:  176950 ),  // subset0_Rope
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    600423; IndexCount: 4284;      VertexBase:  177857 ),  // subset0_Rope
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    604707; IndexCount: 4536;      VertexBase:  178939 ),  // subset0_Rope
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    609243; IndexCount: 4536;      VertexBase:  179837 ),  // subset0_Rope
 ( DiffuseTextureIndex: 10; NormalTextureIndex:  51; SpecularTextureIndex: -1;    IndexStart:    613779; IndexCount: 612;      VertexBase:  180733 ),  // subset0_Rope
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    614391; IndexCount: 396;      VertexBase:  180879 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    614787; IndexCount: 600;      VertexBase:  181009 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    615387; IndexCount: 600;      VertexBase:  181216 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    615987; IndexCount: 744;      VertexBase:  181423 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    616731; IndexCount: 729;      VertexBase:  181680 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    617460; IndexCount: 1920;      VertexBase:  181932 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    619380; IndexCount: 324;      VertexBase:  182343 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    619704; IndexCount: 2274;      VertexBase:  182475 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    621978; IndexCount: 1860;      VertexBase:  182902 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    623838; IndexCount: 2376;      VertexBase:  183256 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    626214; IndexCount: 2190;      VertexBase:  183705 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    628404; IndexCount: 2280;      VertexBase:  184118 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    630684; IndexCount: 840;      VertexBase:  184550 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    631524; IndexCount: 840;      VertexBase:  184754 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    632364; IndexCount: 840;      VertexBase:  184958 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    633204; IndexCount: 840;      VertexBase:  185162 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    634044; IndexCount: 1008;      VertexBase:  185366 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    635052; IndexCount: 1332;      VertexBase:  185608 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    636384; IndexCount: 1617;      VertexBase:  185890 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    638001; IndexCount: 1410;      VertexBase:  186290 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    639411; IndexCount: 948;      VertexBase:  186589 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    640359; IndexCount: 90;      VertexBase:  187035 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    640449; IndexCount: 504;      VertexBase:  187055 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    640953; IndexCount: 378;      VertexBase:  187197 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    641331; IndexCount: 432;      VertexBase:  187284 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    641763; IndexCount: 378;      VertexBase:  187378 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    642141; IndexCount: 3120;      VertexBase:  187462 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    645261; IndexCount: 402;      VertexBase:  188387 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    645663; IndexCount: 2580;      VertexBase:  188525 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    648243; IndexCount: 3180;      VertexBase:  189008 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    651423; IndexCount: 2100;      VertexBase:  189678 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    653523; IndexCount: 3180;      VertexBase:  190158 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    656703; IndexCount: 180;      VertexBase:  190828 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    656883; IndexCount: 276;      VertexBase:  190872 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    657159; IndexCount: 180;      VertexBase:  190970 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    657339; IndexCount: 180;      VertexBase:  191014 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    657519; IndexCount: 228;      VertexBase:  191068 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    657747; IndexCount: 108;      VertexBase:  191162 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    657855; IndexCount: 192;      VertexBase:  191197 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    658047; IndexCount: 192;      VertexBase:  191271 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    658239; IndexCount: 192;      VertexBase:  191345 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    658431; IndexCount: 168;      VertexBase:  191419 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    658599; IndexCount: 168;      VertexBase:  191485 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    658767; IndexCount: 168;      VertexBase:  191551 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    658935; IndexCount: 192;      VertexBase:  191617 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    659127; IndexCount: 192;      VertexBase:  191691 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    659319; IndexCount: 168;      VertexBase:  191765 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    659487; IndexCount: 1617;      VertexBase:  191831 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    661104; IndexCount: 1617;      VertexBase:  192226 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    662721; IndexCount: 1617;      VertexBase:  192605 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 44; NormalTextureIndex:  45; SpecularTextureIndex: -1;    IndexStart:    664338; IndexCount: 90;      VertexBase:  192995 ),  // subset0_shelves3_diff
 ( DiffuseTextureIndex: 54; NormalTextureIndex:  42; SpecularTextureIndex: -1;    IndexStart:    664428; IndexCount: 1248;      VertexBase:  193015 ),  // subset0_Window
 ( DiffuseTextureIndex: 55; NormalTextureIndex:  56; SpecularTextureIndex: -1;    IndexStart:    665676; IndexCount: 3312;      VertexBase:  193319 ),  // subset0_Sliding_Steel_Door
 ( DiffuseTextureIndex: 54; NormalTextureIndex:  57; SpecularTextureIndex: -1;    IndexStart:    668988; IndexCount: 930;      VertexBase:  194197 ),  // subset0_window_Diff
 ( DiffuseTextureIndex: 58; NormalTextureIndex:  59; SpecularTextureIndex: -1;    IndexStart:    669918; IndexCount: 12912;      VertexBase:  194433 ),  // subset0_Door2
 ( DiffuseTextureIndex: 60; NormalTextureIndex:  61; SpecularTextureIndex: -1;    IndexStart:    682830; IndexCount: 969;      VertexBase:  197161 ),  // subset0_Floor
 ( DiffuseTextureIndex: 62; NormalTextureIndex:  63; SpecularTextureIndex: -1;    IndexStart:    683799; IndexCount: 2037;      VertexBase:  197482 ),  // subset0_wall_4
 ( DiffuseTextureIndex: 62; NormalTextureIndex:  63; SpecularTextureIndex: -1;    IndexStart:    685836; IndexCount: 3000;      VertexBase:  198168 ),  // subset0_wall_3
 ( DiffuseTextureIndex: 64; NormalTextureIndex:  65; SpecularTextureIndex: -1;    IndexStart:    688836; IndexCount: 2205;      VertexBase:  199986 ),  // subset0_wall_1
 ( DiffuseTextureIndex: 64; NormalTextureIndex:  65; SpecularTextureIndex: -1;    IndexStart:    691041; IndexCount: 1656;      VertexBase:  200663 ),  // subset0_wall_2
 ( DiffuseTextureIndex: 66; NormalTextureIndex:  67; SpecularTextureIndex: -1;    IndexStart:    692697; IndexCount: 5424;      VertexBase:  201041 ),  // subset0_roof
 ( DiffuseTextureIndex: 68; NormalTextureIndex:  69; SpecularTextureIndex: -1;    IndexStart:    698121; IndexCount: 939;      VertexBase:  203677 ),  // subset0_Pillar
 ( DiffuseTextureIndex: 66; NormalTextureIndex:  67; SpecularTextureIndex: -1;    IndexStart:    699060; IndexCount: 1536;      VertexBase:  203892 ),  // subset0_roof
 ( DiffuseTextureIndex: 70; NormalTextureIndex:  71; SpecularTextureIndex: -1;    IndexStart:    700596; IndexCount: 609;      VertexBase:  204339 ),  // subset0_Broken_Pillar_Diff
 ( DiffuseTextureIndex: 33; NormalTextureIndex:  34; SpecularTextureIndex: -1;    IndexStart:    701205; IndexCount: 1920;      VertexBase:  204469 ),  // subset0_Back_Alley_Drum
 ( DiffuseTextureIndex: 33; NormalTextureIndex:  34; SpecularTextureIndex: -1;    IndexStart:    703125; IndexCount: 1920;      VertexBase:  205134 ),  // subset0_Back_Alley_Drum
 ( DiffuseTextureIndex: 33; NormalTextureIndex:  34; SpecularTextureIndex: -1;    IndexStart:    705045; IndexCount: 1920;      VertexBase:  205799 ),  // subset0_Back_Alley_Drum
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    706965; IndexCount: 7809;      VertexBase:  206464 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 14; NormalTextureIndex:  15; SpecularTextureIndex: -1;    IndexStart:    714774; IndexCount: 1920;      VertexBase:  208128 ),  // subset0_Stack__Boxes_Diff03
 ( DiffuseTextureIndex: 33; NormalTextureIndex:  34; SpecularTextureIndex: -1;    IndexStart:    716694; IndexCount: 1920;      VertexBase:  208629 ),  // subset0_Back_Alley_Drum
 ( DiffuseTextureIndex: 33; NormalTextureIndex:  34; SpecularTextureIndex: -1;    IndexStart:    718614; IndexCount: 1920;      VertexBase:  209294 ),  // subset0_Back_Alley_Drum
 ( DiffuseTextureIndex: 33; NormalTextureIndex:  34; SpecularTextureIndex: -1;    IndexStart:    720534; IndexCount: 1920;      VertexBase:  209959 ),  // subset0_Back_Alley_Drum
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    722454; IndexCount: 7809;      VertexBase:  210624 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    730263; IndexCount: 7809;      VertexBase:  212294 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 35; NormalTextureIndex:  36; SpecularTextureIndex: -1;    IndexStart:    738072; IndexCount: 7809;      VertexBase:  213953 ),  // subset0_shelves2_diff
 ( DiffuseTextureIndex: 32; NormalTextureIndex:  32; SpecularTextureIndex: -1;    IndexStart:    745881; IndexCount: 783;      VertexBase:  215619 ),  // subset0_gameCrates_02_Diff
 ( DiffuseTextureIndex: 72; NormalTextureIndex:  73; SpecularTextureIndex: -1;    IndexStart:    746664; IndexCount: 14451;      VertexBase:  215808 ),  // subset0_GolfBag:Golfclub
 ( DiffuseTextureIndex: 18; NormalTextureIndex:  19; SpecularTextureIndex: -1;    IndexStart:    761115; IndexCount: 3096;      VertexBase:  219093 )  // subset0_Back_Alley_box


    );


implementation

end.
