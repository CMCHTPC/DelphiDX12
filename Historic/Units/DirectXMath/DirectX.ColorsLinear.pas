//-------------------------------------------------------------------------------------
// DirectXColors.h -- C++ Color Math library

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID=615560
//-------------------------------------------------------------------------------------
unit DirectX.ColorsLinear;

{$IFDEF FPC}
{$mode DelphiUnicode}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, DirectX.Math;

const

   // Standard colors (Red/Green/Blue/Alpha) in linear colorspace
    AliceBlue: TXMVECTOR = (f: (0.871367335, 0.938685894, 1.0, 1.0));
    AntiqueWhite: TXMVECTOR = (f: (0.955973506, 0.830770075, 0.679542601, 1.0));
    Aqua: TXMVECTOR = (f: (0.0, 1.0, 1.0, 1.0));
    Aquamarine: TXMVECTOR = (f: (0.212230787, 1.0, 0.658374965, 1.0));
    Azure: TXMVECTOR = (f: (0.871367335, 1.0, 1.0, 1.0));
    Beige: TXMVECTOR = (f: (0.913098991, 0.913098991, 0.715693772, 1.0));
    Bisque: TXMVECTOR = (f: (1.0, 0.775822461, 0.552011609, 1.0));
    Black: TXMVECTOR = (f: (0.0, 0.0, 0.0, 1.0));
    BlanchedAlmond: TXMVECTOR = (f: (1.0, 0.830770075, 0.610495746, 1.0));
    Blue: TXMVECTOR = (f: (0.0, 0.0, 1.0, 1.0));
    BlueViolet: TXMVECTOR = (f: (0.254152179, 0.024157630, 0.760524750, 1.0));
    Brown: TXMVECTOR = (f: (0.376262218, 0.023153365, 0.023153365, 1.0));
    BurlyWood: TXMVECTOR = (f: (0.730461001, 0.479320228, 0.242281199, 1.0));
    CadetBlue: TXMVECTOR = (f: (0.114435382, 0.341914445, 0.351532698, 1.0));
    Chartreuse: TXMVECTOR = (f: (0.212230787, 1.0, 0.0, 1.0));
    Chocolate: TXMVECTOR = (f: (0.644479871, 0.141263321, 0.012983031, 1.0));
    Coral: TXMVECTOR = (f: (1.0, 0.212230787, 0.080219828, 1.0));
    CornflowerBlue: TXMVECTOR = (f: (0.127437726, 0.300543845, 0.846873462, 1.0));
    Cornsilk: TXMVECTOR = (f: (1.0, 0.938685894, 0.715693772, 1.0));
    Crimson: TXMVECTOR = (f: (0.715693772, 0.006995410, 0.045186214, 1.0));
    Cyan: TXMVECTOR = (f: (0.0, 1.0, 1.0, 1.0));
    DarkBlue: TXMVECTOR = (f: (0.0, 0.0, 0.258182913, 1.0));
    DarkCyan: TXMVECTOR = (f: (0.0, 0.258182913, 0.258182913, 1.0));
    DarkGoldenrod: TXMVECTOR = (f: (0.479320228, 0.238397658, 0.003346536, 1.0));
    DarkGray: TXMVECTOR = (f: (0.396755308, 0.396755308, 0.396755308, 1.0));
    DarkGreen: TXMVECTOR = (f: (0.0, 0.127437726, 0.0, 1.0));
    DarkKhaki: TXMVECTOR = (f: (0.508881450, 0.473531544, 0.147027299, 1.0));
    DarkMagenta: TXMVECTOR = (f: (0.258182913, 0.0, 0.258182913, 1.0));
    DarkOliveGreen: TXMVECTOR = (f: (0.090841733, 0.147027299, 0.028426038, 1.0));
    DarkOrange: TXMVECTOR = (f: (1.0, 0.262250721, 0.0, 1.0));
    DarkOrchid: TXMVECTOR = (f: (0.318546832, 0.031896040, 0.603827536, 1.0));
    DarkRed: TXMVECTOR = (f: (0.258182913, 0.0, 0.0, 1.0));
    DarkSalmon: TXMVECTOR = (f: (0.814846814, 0.304987371, 0.194617867, 1.0));
    DarkSeaGreen: TXMVECTOR = (f: (0.274677366, 0.502886593, 0.258182913, 1.0));
    DarkSlateBlue: TXMVECTOR = (f: (0.064803280, 0.046665095, 0.258182913, 1.0));
    DarkSlateGray: TXMVECTOR = (f: (0.028426038, 0.078187428, 0.078187428, 1.0));
    DarkTurquoise: TXMVECTOR = (f: (0.0, 0.617206752, 0.637597024, 1.0));
    DarkViolet: TXMVECTOR = (f: (0.296138316, 0.0, 0.651405811, 1.0));
    DeepPink: TXMVECTOR = (f: (1.0, 0.006995410, 0.291770697, 1.0));
    DeepSkyBlue: TXMVECTOR = (f: (0.0, 0.520995677, 1.0, 1.0));
    DimGray: TXMVECTOR = (f: (0.141263321, 0.141263321, 0.141263321, 1.0));
    DodgerBlue: TXMVECTOR = (f: (0.012983031, 0.278894335, 1.0, 1.0));
    Firebrick: TXMVECTOR = (f: (0.445201248, 0.015996292, 0.015996292, 1.0));
    FloralWhite: TXMVECTOR = (f: (1.0, 0.955973506, 0.871367335, 1.0));
    ForestGreen: TXMVECTOR = (f: (0.015996292, 0.258182913, 0.015996292, 1.0));
    Fuchsia: TXMVECTOR = (f: (1.0, 0.0, 1.0, 1.0));
    Gainsboro: TXMVECTOR = (f: (0.715693772, 0.715693772, 0.715693772, 1.0));
    GhostWhite: TXMVECTOR = (f: (0.938685894, 0.938685894, 1.0, 1.0));
    Gold: TXMVECTOR = (f: (1.0, 0.679542601, 0.0, 1.0));
    Goldenrod: TXMVECTOR = (f: (0.701102138, 0.376262218, 0.014443844, 1.0));
    Gray: TXMVECTOR = (f: (0.215860531, 0.215860531, 0.215860531, 1.0));
    Green: TXMVECTOR = (f: (0.0, 0.215860531, 0.0, 1.0));
    GreenYellow: TXMVECTOR = (f: (0.417885154, 1.0, 0.028426038, 1.0));
    Honeydew: TXMVECTOR = (f: (0.871367335, 1.0, 0.871367335, 1.0));
    HotPink: TXMVECTOR = (f: (1.0, 0.141263321, 0.456411064, 1.0));
    IndianRed: TXMVECTOR = (f: (0.610495746, 0.107023112, 0.107023112, 1.0));
    Indigo: TXMVECTOR = (f: (0.070360109, 0.0, 0.223227978, 1.0));
    Ivory: TXMVECTOR = (f: (1.0, 1.0, 0.871367335, 1.0));
    Khaki: TXMVECTOR = (f: (0.871367335, 0.791298151, 0.262250721, 1.0));
    Lavender: TXMVECTOR = (f: (0.791298151, 0.791298151, 0.955973506, 1.0));
    LavenderBlush: TXMVECTOR = (f: (1.0, 0.871367335, 0.913098991, 1.0));
    LawnGreen: TXMVECTOR = (f: (0.201556295, 0.973445475, 0.0, 1.0));
    LemonChiffon: TXMVECTOR = (f: (1.0, 0.955973506, 0.610495746, 1.0));
    LightBlue: TXMVECTOR = (f: (0.417885154, 0.686685443, 0.791298151, 1.0));
    LightCoral: TXMVECTOR = (f: (0.871367335, 0.215860531, 0.215860531, 1.0));
    LightCyan: TXMVECTOR = (f: (0.745404482, 1.0, 1.0, 1.0));
    LightGoldenrodYellow: TXMVECTOR = (f: (0.955973506, 0.955973506, 0.644479871, 1.0));
    LightGray: TXMVECTOR = (f: (0.651405811, 0.651405811, 0.651405811, 1.0));
    LightGreen: TXMVECTOR = (f: (0.278894335, 0.854992807, 0.278894335, 1.0));
    LightPink: TXMVECTOR = (f: (1.0, 0.467783839, 0.533276618, 1.0));
    LightSalmon: TXMVECTOR = (f: (1.0, 0.351532698, 0.194617867, 1.0));
    LightSeaGreen: TXMVECTOR = (f: (0.014443844, 0.445201248, 0.401977867, 1.0));
    LightSkyBlue: TXMVECTOR = (f: (0.242281199, 0.617206752, 0.955973506, 1.0));
    LightSlateGray: TXMVECTOR = (f: (0.184475034, 0.246201396, 0.318546832, 1.0));
    LightSteelBlue: TXMVECTOR = (f: (0.434153706, 0.552011609, 0.730461001, 1.0));
    LightYellow: TXMVECTOR = (f: (1.0, 1.0, 0.745404482, 1.0));
    Lime: TXMVECTOR = (f: (0.0, 1.0, 0.0, 1.0));
    LimeGreen: TXMVECTOR = (f: (0.031896040, 0.610495746, 0.031896040, 1.0));
    Linen: TXMVECTOR = (f: (0.955973506, 0.871367335, 0.791298151, 1.0));
    Magenta: TXMVECTOR = (f: (1.0, 0.0, 1.0, 1.0));
    Maroon: TXMVECTOR = (f: (0.215860531, 0.0, 0.0, 1.0));
    MediumAquamarine: TXMVECTOR = (f: (0.132868364, 0.610495746, 0.401977867, 1.0));
    MediumBlue: TXMVECTOR = (f: (0.0, 0.0, 0.610495746, 1.0));
    MediumOrchid: TXMVECTOR = (f: (0.491020888, 0.090841733, 0.651405811, 1.0));
    MediumPurple: TXMVECTOR = (f: (0.291770697, 0.162029430, 0.708376050, 1.0));
    MediumSeaGreen: TXMVECTOR = (f: (0.045186214, 0.450785846, 0.165132239, 1.0));
    MediumSlateBlue: TXMVECTOR = (f: (0.198069349, 0.138431653, 0.854992807, 1.0));
    MediumSpringGreen: TXMVECTOR = (f: (0.0, 0.955973506, 0.323143244, 1.0));
    MediumTurquoise: TXMVECTOR = (f: (0.064803280, 0.637597024, 0.603827536, 1.0));
    MediumVioletRed: TXMVECTOR = (f: (0.571125031, 0.007499032, 0.234550655, 1.0));
    MidnightBlue: TXMVECTOR = (f: (0.009721218, 0.009721218, 0.162029430, 1.0));
    MintCream: TXMVECTOR = (f: (0.913098991, 1.0, 0.955973506, 1.0));
    MistyRose: TXMVECTOR = (f: (1.0, 0.775822461, 0.752942443, 1.0));
    Moccasin: TXMVECTOR = (f: (1.0, 0.775822461, 0.462077051, 1.0));
    NavajoWhite: TXMVECTOR = (f: (1.0, 0.730461001, 0.417885154, 1.0));
    Navy: TXMVECTOR = (f: (0.0, 0.0, 0.215860531, 1.0));
    OldLace: TXMVECTOR = (f: (0.982250869, 0.913098991, 0.791298151, 1.0));
    Olive: TXMVECTOR = (f: (0.215860531, 0.215860531, 0.0, 1.0));
    OliveDrab: TXMVECTOR = (f: (0.147027299, 0.270497859, 0.016807375, 1.0));
    Orange: TXMVECTOR = (f: (1.0, 0.376262218, 0.0, 1.0));
    OrangeRed: TXMVECTOR = (f: (1.0, 0.059511241, 0.0, 1.0));
    Orchid: TXMVECTOR = (f: (0.701102138, 0.162029430, 0.672443330, 1.0));
    PaleGoldenrod: TXMVECTOR = (f: (0.854992807, 0.806952477, 0.401977867, 1.0));
    PaleGreen: TXMVECTOR = (f: (0.313988745, 0.964686573, 0.313988745, 1.0));
    PaleTurquoise: TXMVECTOR = (f: (0.428690553, 0.854992807, 0.854992807, 1.0));
    PaleVioletRed: TXMVECTOR = (f: (0.708376050, 0.162029430, 0.291770697, 1.0));
    PapayaWhip: TXMVECTOR = (f: (1.0, 0.863157392, 0.665387452, 1.0));
    PeachPuff: TXMVECTOR = (f: (1.0, 0.701102138, 0.485149980, 1.0));
    Peru: TXMVECTOR = (f: (0.610495746, 0.234550655, 0.049706575, 1.0));
    Pink: TXMVECTOR = (f: (1.0, 0.527115345, 0.597202003, 1.0));
    Plum: TXMVECTOR = (f: (0.723055363, 0.351532698, 0.723055363, 1.0));
    PowderBlue: TXMVECTOR = (f: (0.434153706, 0.745404482, 0.791298151, 1.0));
    Purple: TXMVECTOR = (f: (0.215860531, 0.0, 0.215860531, 1.0));
    Red: TXMVECTOR = (f: (1.0, 0.0, 0.0, 1.0));
    RosyBrown: TXMVECTOR = (f: (0.502886593, 0.274677366, 0.274677366, 1.0));
    RoyalBlue: TXMVECTOR = (f: (0.052860655, 0.141263321, 0.752942443, 1.0));
    SaddleBrown: TXMVECTOR = (f: (0.258182913, 0.059511241, 0.006512091, 1.0));
    Salmon: TXMVECTOR = (f: (0.955973506, 0.215860531, 0.168269455, 1.0));
    SandyBrown: TXMVECTOR = (f: (0.904661357, 0.371237785, 0.116970696, 1.0));
    SeaGreen: TXMVECTOR = (f: (0.027320892, 0.258182913, 0.095307484, 1.0));
    SeaShell: TXMVECTOR = (f: (1.0, 0.913098991, 0.854992807, 1.0));
    Sienna: TXMVECTOR = (f: (0.351532698, 0.084376216, 0.026241222, 1.0));
    Silver: TXMVECTOR = (f: (0.527115345, 0.527115345, 0.527115345, 1.0));
    SkyBlue: TXMVECTOR = (f: (0.242281199, 0.617206752, 0.830770075, 1.0));
    SlateBlue: TXMVECTOR = (f: (0.144128501, 0.102241747, 0.610495746, 1.0));
    SlateGray: TXMVECTOR = (f: (0.162029430, 0.215860531, 0.278894335, 1.0));
    Snow: TXMVECTOR = (f: (1.0, 0.955973506, 0.955973506, 1.0));
    SpringGreen: TXMVECTOR = (f: (0.0, 1.0, 0.212230787, 1.0));
    SteelBlue: TXMVECTOR = (f: (0.061246071, 0.223227978, 0.456411064, 1.0));
    Tan: TXMVECTOR = (f: (0.644479871, 0.456411064, 0.262250721, 1.0));
    Teal: TXMVECTOR = (f: (0.0, 0.215860531, 0.215860531, 1.0));
    Thistle: TXMVECTOR = (f: (0.686685443, 0.520995677, 0.686685443, 1.0));
    Tomato: TXMVECTOR = (f: (1.0, 0.124771863, 0.063010029, 1.0));
    Transparent: TXMVECTOR = (f: (0.0, 0.0, 0.0, 0.0));
    Turquoise: TXMVECTOR = (f: (0.051269468, 0.745404482, 0.630757332, 1.0));
    Violet: TXMVECTOR = (f: (0.854992807, 0.223227978, 0.854992807, 1.0));
    Wheat: TXMVECTOR = (f: (0.913098991, 0.730461001, 0.450785846, 1.0));
    White: TXMVECTOR = (f: (1.0, 1.0, 1.0, 1.0));
    WhiteSmoke: TXMVECTOR = (f: (0.913098991, 0.913098991, 0.913098991, 1.0));
    Yellow: TXMVECTOR = (f: (1.0, 1.0, 0.0, 1.0));
    YellowGreen: TXMVECTOR = (f: (0.323143244, 0.610495746, 0.031896040, 1.0));


implementation

end.

