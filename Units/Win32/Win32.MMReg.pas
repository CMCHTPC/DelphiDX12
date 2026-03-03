{ **************************************************************************
    FreePascal/Delphi DirectX 12 Header Files

    Copyright (C) 2013-2025 Norbert Sonnleitner

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
************************************************************************** }

{ **************************************************************************
   Additional Copyright (C) for this modul:

   //*@@@+++@@@@******************************************************************

   // Copyright (C) Microsoft Corporation. All rights reserved.

   // Multimedia Registration
   //*@@@---@@@@******************************************************************

   // Define the following to skip definitions

   // NOMMIDS      Multimedia IDs are not defined
   // NONEWWAVE    No new waveform types are defined except WAVEFORMATEX
   // NONEWRIFF    No new RIFF forms are defined
   // NOJPEGDIB    No JPEG DIB definitions
   // NONEWIC      No new Image Compressor types are defined
   // NOBITMAP     No extended bitmap info header definition

   This unit consists of the following header files
   File name: mmreg.h
   Header version: 10.0.26100.6584

  ************************************************************************** }


unit Win32.MMReg;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

const
    (* use version number to verify compatibility *)
    _INC_MMREG = 158; // version * 100 + revision


    (* manufacturer IDs *)

    MM_MICROSOFT = 1; (* Microsoft Corporation *)
    MM_CREATIVE = 2; (* Creative Labs, Inc. *)
    MM_MEDIAVISION = 3; (* Media Vision, Inc. *)
    MM_FUJITSU = 4; (* Fujitsu Corp. *)
    MM_PRAGMATRAX = 5; (* PRAGMATRAX Software *)
    MM_CYRIX = 6; (* Cyrix Corporation *)
    MM_PHILIPS_SPEECH_PROCESSING = 7; (* Philips Speech Processing *)
    MM_NETXL = 8; (* NetXL, Inc. *)
    MM_ZYXEL = 9; (* ZyXEL Communications, Inc. *)
    MM_BECUBED = 10; (* BeCubed Software Inc. *)
    MM_AARDVARK = 11; (* Aardvark Computer Systems, Inc. *)
    MM_BINTEC = 12; (* Bin Tec Communications GmbH *)
    MM_HEWLETT_PACKARD = 13; (* Hewlett-Packard Company *)
    MM_ACULAB = 14; (* Aculab plc *)
    MM_FAITH = 15; (* Faith,Inc. *)
    MM_MITEL = 16; (* Mitel Corporation *)
    MM_QUANTUM3D = 17; (* Quantum3D, Inc. *)
    MM_SNI = 18; (* Siemens-Nixdorf *)
    MM_EMU = 19; (* E-mu Systems, Inc. *)
    MM_ARTISOFT = 20; (* Artisoft, Inc. *)
    MM_TURTLE_BEACH = 21; (* Turtle Beach, Inc. *)
    MM_IBM = 22; (* IBM Corporation *)
    MM_VOCALTEC = 23; (* Vocaltec Ltd. *)
    MM_ROLAND = 24; (* Roland *)
    MM_DSP_SOLUTIONS = 25; (* DSP Solutions, Inc. *)
    MM_NEC = 26; (* NEC *)
    MM_ATI = 27; (* ATI Technologies Inc. *)
    MM_WANGLABS = 28; (* Wang Laboratories, Inc. *)
    MM_TANDY = 29; (* Tandy Corporation *)
    MM_VOYETRA = 30; (* Voyetra *)
    MM_ANTEX = 31; (* Antex Electronics Corporation *)
    MM_ICL_PS = 32; (* ICL Personal Systems *)
    MM_INTEL = 33; (* Intel Corporation *)
    MM_GRAVIS = 34; (* Advanced Gravis *)
    MM_VAL = 35; (* Video Associates Labs, Inc. *)
    MM_INTERACTIVE = 36; (* InterActive Inc. *)
    MM_YAMAHA = 37; (* Yamaha Corporation of America *)
    MM_EVEREX = 38; (* Everex Systems, Inc. *)
    MM_ECHO = 39; (* Echo Speech Corporation *)
    MM_SIERRA = 40; (* Sierra Semiconductor Corp *)
    MM_CAT = 41; (* Computer Aided Technologies *)
    MM_APPS = 42; (* APPS Software International *)
    MM_DSP_GROUP = 43; (* DSP Group, Inc. *)
    MM_MELABS = 44; (* microEngineering Labs *)
    MM_COMPUTER_FRIENDS = 45; (* Computer Friends, Inc. *)
    MM_ESS = 46; (* ESS Technology *)
    MM_AUDIOFILE = 47; (* Audio, Inc. *)
    MM_MOTOROLA = 48; (* Motorola, Inc. *)
    MM_CANOPUS = 49; (* Canopus, co., Ltd. *)
    MM_EPSON = 50; (* Seiko Epson Corporation *)
    MM_TRUEVISION = 51; (* Truevision *)
    MM_AZTECH = 52; (* Aztech Labs, Inc. *)
    MM_VIDEOLOGIC = 53; (* Videologic *)
    MM_SCALACS = 54; (* SCALACS *)
    MM_KORG = 55; (* Korg Inc. *)
    MM_APT = 56; (* Audio Processing Technology *)
    MM_ICS = 57; (* Integrated Circuit Systems, Inc. *)
    MM_ITERATEDSYS = 58; (* Iterated Systems, Inc. *)
    MM_METHEUS = 59; (* Metheus *)
    MM_LOGITECH = 60; (* Logitech, Inc. *)
    MM_WINNOV = 61; (* Winnov, Inc. *)
    MM_NCR = 62; (* NCR Corporation *)
    MM_EXAN = 63; (* EXAN *)
    MM_AST = 64; (* AST Research Inc. *)
    MM_WILLOWPOND = 65; (* Willow Pond Corporation *)
    MM_SONICFOUNDRY = 66; (* Sonic Foundry *)
    MM_VITEC = 67; (* Vitec Multimedia *)
    MM_MOSCOM = 68; (* MOSCOM Corporation *)
    MM_SILICONSOFT = 69; (* Silicon Soft, Inc. *)
    MM_TERRATEC = 70; (* TerraTec Electronic GmbH *)
    MM_MEDIASONIC = 71; (* MediaSonic Ltd. *)
    MM_SANYO = 72; (* SANYO Electric Co., Ltd. *)
    MM_SUPERMAC = 73; (* Supermac *)
    MM_AUDIOPT = 74; (* Audio Processing Technology *)
    MM_NOGATECH = 75; (* NOGATECH Ltd. *)
    MM_SPEECHCOMP = 76; (* Speech Compression *)
    MM_AHEAD = 77; (* Ahead, Inc. *)
    MM_DOLBY = 78; (* Dolby Laboratories *)
    MM_OKI = 79; (* OKI *)
    MM_AURAVISION = 80; (* AuraVision Corporation *)
    MM_OLIVETTI = 81; (* Ing C. Olivetti & C., S.p.A. *)
    MM_IOMAGIC = 82; (* I/O Magic Corporation *)
    MM_MATSUSHITA = 83; (* Matsushita Electric Industrial Co., Ltd. *)
    MM_CONTROLRES = 84; (* Control Resources Limited *)
    MM_XEBEC = 85; (* Xebec Multimedia Solutions Limited *)
    MM_NEWMEDIA = 86; (* New Media Corporation *)
    MM_NMS = 87; (* Natural MicroSystems *)
    MM_LYRRUS = 88; (* Lyrrus Inc. *)
    MM_COMPUSIC = 89; (* Compusic *)
    MM_OPTI = 90; (* OPTi Computers Inc. *)
    MM_ADLACC = 91; (* Adlib Accessories Inc. *)
    MM_COMPAQ = 92; (* Compaq Computer Corp. *)
    MM_DIALOGIC = 93; (* Dialogic Corporation *)
    MM_INSOFT = 94; (* InSoft, Inc. *)
    MM_MPTUS = 95; (* M.P. Technologies, Inc. *)
    MM_WEITEK = 96; (* Weitek *)
    MM_LERNOUT_AND_HAUSPIE = 97; (* Lernout & Hauspie *)
    MM_QCIAR = 98; (* Quanta Computer Inc. *)
    MM_APPLE = 99; (* Apple Computer, Inc. *)
    MM_DIGITAL = 100; (* Digital Equipment Corporation *)
    MM_MOTU = 101; (* Mark of the Unicorn *)
    MM_WORKBIT = 102; (* Workbit Corporation *)
    MM_OSITECH = 103; (* Ositech Communications Inc. *)
    MM_MIRO = 104; (* miro Computer Products AG *)
    MM_CIRRUSLOGIC = 105; (* Cirrus Logic *)
    MM_ISOLUTION = 106; (* ISOLUTION  B.V. *)
    MM_HORIZONS = 107; (* Horizons Technology, Inc. *)
    MM_CONCEPTS = 108; (* Computer Concepts Ltd. *)
    MM_VTG = 109; (* Voice Technologies Group, Inc. *)
    MM_RADIUS = 110; (* Radius *)
    MM_ROCKWELL = 111; (* Rockwell International *)
    MM_XYZ = 112; (* Co. XYZ for testing *)
    MM_OPCODE = 113; (* Opcode Systems *)
    MM_VOXWARE = 114; (* Voxware Inc. *)
    MM_NORTHERN_TELECOM = 115; (* Northern Telecom Limited *)
    MM_APICOM = 116; (* APICOM *)
    MM_GRANDE = 117; (* Grande Software *)
    MM_ADDX = 118; (* ADDX *)
    MM_WILDCAT = 119; (* Wildcat Canyon Software *)
    MM_RHETOREX = 120; (* Rhetorex Inc. *)
    MM_BROOKTREE = 121; (* Brooktree Corporation *)
    MM_ENSONIQ = 125; (* ENSONIQ Corporation *)
    MM_FAST = 126; (* FAST Multimedia AG *)
    MM_NVIDIA = 127; (* NVidia Corporation *)
    MM_OKSORI = 128; (* OKSORI Co., Ltd. *)
    MM_DIACOUSTICS = 129; (* DiAcoustics, Inc. *)
    MM_GULBRANSEN = 130; (* Gulbransen, Inc. *)
    MM_KAY_ELEMETRICS = 131; (* Kay Elemetrics, Inc. *)
    MM_CRYSTAL = 132; (* Crystal Semiconductor Corporation *)
    MM_SPLASH_STUDIOS = 133; (* Splash Studios *)
    MM_QUARTERDECK = 134; (* Quarterdeck Corporation *)
    MM_TDK = 135; (* TDK Corporation *)
    MM_DIGITAL_AUDIO_LABS = 136; (* Digital Audio Labs, Inc. *)
    MM_SEERSYS = 137; (* Seer Systems, Inc. *)
    MM_PICTURETEL = 138; (* PictureTel Corporation *)
    MM_ATT_MICROELECTRONICS = 139; (* AT&T Microelectronics *)
    MM_OSPREY = 140; (* Osprey Technologies, Inc. *)
    MM_MEDIATRIX = 141; (* Mediatrix Peripherals *)
    MM_SOUNDESIGNS = 142; (* SounDesignS M.C.S. Ltd. *)
    MM_ALDIGITAL = 143; (* A.L. Digital Ltd. *)
    MM_SPECTRUM_SIGNAL_PROCESSING = 144; (* Spectrum Signal Processing, Inc. *)
    MM_ECS = 145; (* Electronic Courseware Systems, Inc. *)
    MM_AMD = 146; (* AMD *)
    MM_COREDYNAMICS = 147; (* Core Dynamics *)
    MM_CANAM = 148; (* CANAM Computers *)
    MM_SOFTSOUND = 149; (* Softsound, Ltd. *)
    MM_NORRIS = 150; (* Norris Communications, Inc. *)
    MM_DDD = 151; (* Danka Data Devices *)
    MM_EUPHONICS = 152; (* EuPhonics *)
    MM_PRECEPT = 153; (* Precept Software, Inc. *)
    MM_CRYSTAL_NET = 154; (* Crystal Net Corporation *)
    MM_CHROMATIC = 155; (* Chromatic Research, Inc. *)
    MM_VOICEINFO = 156; (* Voice Information Systems, Inc. *)
    MM_VIENNASYS = 157; (* Vienna Systems *)
    MM_CONNECTIX = 158; (* Connectix Corporation *)
    MM_GADGETLABS = 159; (* Gadget Labs LLC *)
    MM_FRONTIER = 160; (* Frontier Design Group LLC *)
    MM_VIONA = 161; (* Viona Development GmbH *)
    MM_CASIO = 162; (* Casio Computer Co., LTD *)
    MM_DIAMONDMM = 163; (* Diamond Multimedia *)
    MM_S3 = 164; (* S3 *)
    MM_DVISION = 165; (* D-Vision Systems, Inc. *)
    MM_NETSCAPE = 166; (* Netscape Communications *)
    MM_SOUNDSPACE = 167; (* Soundspace Audio *)
    MM_VANKOEVERING = 168; (* VanKoevering Company *)
    MM_QTEAM = 169; (* Q-Team *)
    MM_ZEFIRO = 170; (* Zefiro Acoustics *)
    MM_STUDER = 171; (* Studer Professional Audio AG *)
    MM_FRAUNHOFER_IIS = 172; (* Fraunhofer IIS *)
    MM_QUICKNET = 173; (* Quicknet Technologies *)
    MM_ALARIS = 174; (* Alaris, Inc. *)
    MM_SICRESOURCE = 175; (* SIC Resource Inc. *)
    MM_NEOMAGIC = 176; (* NeoMagic Corporation *)
    MM_MERGING_TECHNOLOGIES = 177; (* Merging Technologies S.A. *)
    MM_XIRLINK = 178; (* Xirlink, Inc. *)
    MM_COLORGRAPH = 179; (* Colorgraph (UK) Ltd *)
    MM_OTI = 180; (* Oak Technology, Inc. *)
    MM_AUREAL = 181; (* Aureal Semiconductor *)
    MM_VIVO = 182; (* Vivo Software *)
    MM_SHARP = 183; (* Sharp *)
    MM_LUCENT = 184; (* Lucent Technologies *)
    MM_ATT = 185; (* AT&T Labs, Inc. *)
    MM_SUNCOM = 186; (* Sun Communications, Inc. *)
    MM_SORVIS = 187; (* Sorenson Vision *)
    MM_INVISION = 188; (* InVision Interactive *)
    MM_BERKOM = 189; (* Deutsche Telekom Berkom GmbH *)
    MM_MARIAN = 190; (* Marian GbR Leipzig *)
    MM_DPSINC = 191; (* Digital Processing Systems, Inc. *)
    MM_BCB = 192; (* BCB Holdings Inc. *)
    MM_MOTIONPIXELS = 193; (* Motion Pixels *)
    MM_QDESIGN = 194; (* QDesign Corporation *)
    MM_NMP = 195; (* Nokia Mobile Phones *)
    MM_DATAFUSION = 196; (* DataFusion Systems (Pty) (Ltd) *)
    MM_DUCK = 197; (* The Duck Corporation *)
    MM_FTR = 198; (* Future Technology Resources Pty Ltd *)
    MM_BERCOS = 199; (* BERCOS GmbH *)
    MM_ONLIVE = 200; (* OnLive! Technologies, Inc. *)
    MM_SIEMENS_SBC = 201; (* Siemens Business Communications Systems *)
    MM_TERALOGIC = 202; (* TeraLogic, Inc. *)
    MM_PHONET = 203; (* PhoNet Communications Ltd. *)
    MM_WINBOND = 204; (* Winbond Electronics Corp *)
    MM_VIRTUALMUSIC = 205; (* Virtual Music, Inc. *)
    MM_ENET = 206; (* e-Net, Inc. *)
    MM_GUILLEMOT = 207; (* Guillemot International *)
    MM_EMAGIC = 208; (* Emagic Soft- und Hardware GmbH *)
    MM_MWM = 209; (* MWM Acoustics LLC *)
    MM_PACIFICRESEARCH = 210; (* Pacific Research and Engineering Corporation *)
    MM_SIPROLAB = 211; (* Sipro Lab Telecom Inc. *)
    MM_LYNX = 212; (* Lynx Studio Technology, Inc. *)
    MM_SPECTRUM_PRODUCTIONS = 213; (* Spectrum Productions *)
    MM_DICTAPHONE = 214; (* Dictaphone Corporation *)
    MM_QUALCOMM = 215; (* QUALCOMM, Inc. *)
    MM_RZS = 216; (* Ring Zero Systems, Inc *)
    MM_AUDIOSCIENCE = 217; (* AudioScience Inc. *)
    MM_PINNACLE = 218; (* Pinnacle Systems, Inc. *)
    MM_EES = 219; (* EES Technik fuer Musik GmbH *)
    MM_HAFTMANN = 220; (* haftmann#software *)
    MM_LUCID = 221; (* Lucid Technology, Symetrix Inc. *)
    MM_HEADSPACE = 222; (* Headspace, Inc *)
    MM_UNISYS = 223; (* UNISYS CORPORATION *)
    MM_LUMINOSITI = 224; (* Luminositi, Inc. *)
    MM_ACTIVEVOICE = 225; (* ACTIVE VOICE CORPORATION *)
    MM_DTS = 226; (* Digital Theater Systems, Inc. *)
    MM_DIGIGRAM = 227; (* DIGIGRAM *)
    MM_SOFTLAB_NSK = 228; (* Softlab-Nsk *)
    MM_FORTEMEDIA = 229; (* ForteMedia, Inc *)
    MM_SONORUS = 230; (* Sonorus, Inc. *)
    MM_ARRAY = 231; (* Array Microsystems, Inc. *)
    MM_DATARAN = 232; (* Data Translation, Inc. *)
    MM_I_LINK = 233; (* I-link Worldwide *)
    MM_SELSIUS_SYSTEMS = 234; (* Selsius Systems Inc. *)
    MM_ADMOS = 235; (* AdMOS Technology, Inc. *)
    MM_LEXICON = 236; (* Lexicon Inc. *)
    MM_SGI = 237; (* Silicon Graphics Inc. *)
    MM_IPI = 238; (* Interactive Product Inc. *)
    MM_ICE = 239; (* IC Ensemble, Inc. *)
    MM_VQST = 240; (* ViewQuest Technologies Inc. *)
    MM_ETEK = 241; (* eTEK Labs Inc. *)
    MM_CS = 242; (* Consistent Software *)
    MM_ALESIS = 243; (* Alesis Studio Electronics *)
    MM_INTERNET = 244; (* INTERNET Corporation *)
    MM_SONY = 245; (* Sony Corporation *)
    MM_HYPERACTIVE = 246; (* Hyperactive Audio Systems, Inc. *)
    MM_UHER_INFORMATIC = 247; (* UHER informatic GmbH *)
    MM_SYDEC_NV = 248; (* Sydec NV *)
    MM_FLEXION = 249; (* Flexion Systems Ltd. *)
    MM_VIA = 250; (* Via Technologies, Inc. *)
    MM_MICRONAS = 251; (* Micronas Semiconductors, Inc. *)
    MM_ANALOGDEVICES = 252; (* Analog Devices, Inc. *)
    MM_HP = 253; (* Hewlett Packard Company *)
    MM_MATROX_DIV = 254; (* Matrox *)
    MM_QUICKAUDIO = 255; (* Quick Audio, GbR *)
    MM_YOUCOM = 256; (* You/Com Audiocommunicatie BV *)
    MM_RICHMOND = 257; (* Richmond Sound Design Ltd. *)
    MM_IODD = 258; (* I-O Data Device, Inc. *)
    MM_ICCC = 259; (* ICCC A/S *)
    MM_3COM = 260; (* 3COM Corporation *)
    MM_MALDEN = 261; (* Malden Electronics Ltd. *)
    MM_3DFX = 262; (* 3Dfx Interactive, Inc. *)
    MM_MINDMAKER = 263; (* Mindmaker, Inc. *)
    MM_TELEKOL = 264; (* Telekol Corp. *)
    MM_ST_MICROELECTRONICS = 265; (* ST Microelectronics *)
    MM_ALGOVISION = 266; (* Algo Vision Systems GmbH *)

    MM_UNMAPPED = $ffff; (* extensible MID mapping *)

    MM_PID_UNMAPPED = MM_UNMAPPED; (* extensible PID mapping *)


    (* MM_MICROSOFT product IDs *)
    MM_MIDI_MAPPER = 1; (*  Midi Mapper  *)
    MM_WAVE_MAPPER = 2; (*  Wave Mapper  *)
    MM_SNDBLST_MIDIOUT = 3; (*  Sound Blaster MIDI output port  *)
    MM_SNDBLST_MIDIIN = 4; (*  Sound Blaster MIDI input port  *)
    MM_SNDBLST_SYNTH = 5; (*  Sound Blaster internal synth  *)
    MM_SNDBLST_WAVEOUT = 6; (*  Sound Blaster waveform output  *)
    MM_SNDBLST_WAVEIN = 7; (*  Sound Blaster waveform input  *)
    MM_ADLIB = 9; (*  Ad Lib Compatible synth  *)
    MM_MPU401_MIDIOUT = 10; (*  MPU 401 compatible MIDI output port  *)
    MM_MPU401_MIDIIN = 11; (*  MPU 401 compatible MIDI input port  *)
    MM_PC_JOYSTICK = 12; (*  Joystick adapter  *)

    MM_PCSPEAKER_WAVEOUT = 13; (*  PC speaker waveform output  *)
    MM_MSFT_WSS_WAVEIN = 14; (*  MS Audio Board waveform input  *)
    MM_MSFT_WSS_WAVEOUT = 15; (*  MS Audio Board waveform output  *)
    MM_MSFT_WSS_FMSYNTH_STEREO = 16; (*  MS Audio Board  Stereo FM synth  *)
    MM_MSFT_WSS_MIXER = 17; (*  MS Audio Board Mixer Driver  *)
    MM_MSFT_WSS_OEM_WAVEIN = 18; (*  MS OEM Audio Board waveform input  *)
    MM_MSFT_WSS_OEM_WAVEOUT = 19; (*  MS OEM Audio Board waveform output  *)
    MM_MSFT_WSS_OEM_FMSYNTH_STEREO = 20; (*  MS OEM Audio Board Stereo FM Synth  *)
    MM_MSFT_WSS_AUX = 21; (*  MS Audio Board Aux. Port  *)
    MM_MSFT_WSS_OEM_AUX = 22; (*  MS OEM Audio Aux Port  *)
    MM_MSFT_GENERIC_WAVEIN = 23; (*  MS Vanilla driver waveform input  *)
    MM_MSFT_GENERIC_WAVEOUT = 24; (*  MS Vanilla driver wavefrom output  *)
    MM_MSFT_GENERIC_MIDIIN = 25; (*  MS Vanilla driver MIDI in  *)
    MM_MSFT_GENERIC_MIDIOUT = 26; (*  MS Vanilla driver MIDI  external out  *)
    MM_MSFT_GENERIC_MIDISYNTH = 27; (*  MS Vanilla driver MIDI synthesizer  *)
    MM_MSFT_GENERIC_AUX_LINE = 28; (*  MS Vanilla driver aux (line in)  *)
    MM_MSFT_GENERIC_AUX_MIC = 29; (*  MS Vanilla driver aux (mic)  *)
    MM_MSFT_GENERIC_AUX_CD = 30; (*  MS Vanilla driver aux (CD)  *)
    MM_MSFT_WSS_OEM_MIXER = 31; (*  MS OEM Audio Board Mixer Driver  *)
    MM_MSFT_MSACM = 32; (*  MS Audio Compression Manager  *)
    MM_MSFT_ACM_MSADPCM = 33; (*  MS ADPCM Codec  *)
    MM_MSFT_ACM_IMAADPCM = 34; (*  IMA ADPCM Codec  *)
    MM_MSFT_ACM_MSFILTER = 35; (*  MS Filter  *)
    MM_MSFT_ACM_GSM610 = 36; (*  GSM 610 codec  *)
    MM_MSFT_ACM_G711 = 37; (*  G.711 codec  *)
    MM_MSFT_ACM_PCM = 38; (*  PCM converter  *)

    // Microsoft Windows Sound System drivers

    MM_WSS_SB16_WAVEIN = 39; (*  Sound Blaster 16 waveform input  *)
    MM_WSS_SB16_WAVEOUT = 40; (*  Sound Blaster 16  waveform output  *)
    MM_WSS_SB16_MIDIIN = 41; (*  Sound Blaster 16 midi-in  *)
    MM_WSS_SB16_MIDIOUT = 42; (*  Sound Blaster 16 midi out  *)
    MM_WSS_SB16_SYNTH = 43; (*  Sound Blaster 16 FM Synthesis  *)
    MM_WSS_SB16_AUX_LINE = 44; (*  Sound Blaster 16 aux (line in)  *)
    MM_WSS_SB16_AUX_CD = 45; (*  Sound Blaster 16 aux (CD)  *)
    MM_WSS_SB16_MIXER = 46; (*  Sound Blaster 16 mixer device  *)
    MM_WSS_SBPRO_WAVEIN = 47; (*  Sound Blaster Pro waveform input  *)
    MM_WSS_SBPRO_WAVEOUT = 48; (*  Sound Blaster Pro waveform output  *)
    MM_WSS_SBPRO_MIDIIN = 49; (*  Sound Blaster Pro midi in  *)
    MM_WSS_SBPRO_MIDIOUT = 50; (*  Sound Blaster Pro midi out  *)
    MM_WSS_SBPRO_SYNTH = 51; (*  Sound Blaster Pro FM synthesis  *)
    MM_WSS_SBPRO_AUX_LINE = 52; (*  Sound Blaster Pro aux (line in )  *)
    MM_WSS_SBPRO_AUX_CD = 53; (*  Sound Blaster Pro aux (CD)  *)
    MM_WSS_SBPRO_MIXER = 54; (*  Sound Blaster Pro mixer  *)
    MM_MSFT_WSS_NT_WAVEIN = 55; (*  WSS NT wave in  *)
    MM_MSFT_WSS_NT_WAVEOUT = 56; (*  WSS NT wave out  *)
    MM_MSFT_WSS_NT_FMSYNTH_STEREO = 57; (*  WSS NT FM synth  *)
    MM_MSFT_WSS_NT_MIXER = 58; (*  WSS NT mixer  *)
    MM_MSFT_WSS_NT_AUX = 59; (*  WSS NT aux  *)
    MM_MSFT_SB16_WAVEIN = 60; (*  Sound Blaster 16 waveform input  *)
    MM_MSFT_SB16_WAVEOUT = 61; (*  Sound Blaster 16  waveform output  *)
    MM_MSFT_SB16_MIDIIN = 62; (*  Sound Blaster 16 midi-in  *)
    MM_MSFT_SB16_MIDIOUT = 63; (*  Sound Blaster 16 midi out  *)
    MM_MSFT_SB16_SYNTH = 64; (*  Sound Blaster 16 FM Synthesis  *)
    MM_MSFT_SB16_AUX_LINE = 65; (*  Sound Blaster 16 aux (line in)  *)
    MM_MSFT_SB16_AUX_CD = 66; (*  Sound Blaster 16 aux (CD)  *)
    MM_MSFT_SB16_MIXER = 67; (*  Sound Blaster 16 mixer device  *)
    MM_MSFT_SBPRO_WAVEIN = 68; (*  Sound Blaster Pro waveform input  *)
    MM_MSFT_SBPRO_WAVEOUT = 69; (*  Sound Blaster Pro waveform output  *)
    MM_MSFT_SBPRO_MIDIIN = 70; (*  Sound Blaster Pro midi in  *)
    MM_MSFT_SBPRO_MIDIOUT = 71; (*  Sound Blaster Pro midi out  *)
    MM_MSFT_SBPRO_SYNTH = 72; (*  Sound Blaster Pro FM synthesis  *)
    MM_MSFT_SBPRO_AUX_LINE = 73; (*  Sound Blaster Pro aux (line in)  *)
    MM_MSFT_SBPRO_AUX_CD = 74; (*  Sound Blaster Pro aux (CD)  *)
    MM_MSFT_SBPRO_MIXER = 75; (*  Sound Blaster Pro mixer  *)

    MM_MSFT_MSOPL_SYNTH = 76; (*  Yamaha OPL2/OPL3 compatible FM synthesis *)

    MM_MSFT_VMDMS_LINE_WAVEIN = 80; (* Voice Modem Serial Line Wave Input *)
    MM_MSFT_VMDMS_LINE_WAVEOUT = 81; (* Voice Modem Serial Line Wave Output *)
    MM_MSFT_VMDMS_HANDSET_WAVEIN = 82; (* Voice Modem Serial Handset Wave Input *)
    MM_MSFT_VMDMS_HANDSET_WAVEOUT = 83; (* Voice Modem Serial Handset Wave Output *)
    MM_MSFT_VMDMW_LINE_WAVEIN = 84; (* Voice Modem Wrapper Line Wave Input *)
    MM_MSFT_VMDMW_LINE_WAVEOUT = 85; (* Voice Modem Wrapper Line Wave Output *)
    MM_MSFT_VMDMW_HANDSET_WAVEIN = 86; (* Voice Modem Wrapper Handset Wave Input *)
    MM_MSFT_VMDMW_HANDSET_WAVEOUT = 87; (* Voice Modem Wrapper Handset Wave Output *)
    MM_MSFT_VMDMW_MIXER = 88; (* Voice Modem Wrapper Mixer *)
    MM_MSFT_VMDM_GAME_WAVEOUT = 89; (* Voice Modem Game Compatible Wave Device *)
    MM_MSFT_VMDM_GAME_WAVEIN = 90; (* Voice Modem Game Compatible Wave Device *)

    MM_MSFT_ACM_MSNAUDIO = 91;
    MM_MSFT_ACM_MSG723 = 92;
    MM_MSFT_ACM_MSRT24 = 93;

    MM_MSFT_WDMAUDIO_WAVEOUT = 100; (* Generic id for WDM Audio drivers *)
    MM_MSFT_WDMAUDIO_WAVEIN = 101; (* Generic id for WDM Audio drivers *)
    MM_MSFT_WDMAUDIO_MIDIOUT = 102; (* Generic id for WDM Audio drivers *)
    MM_MSFT_WDMAUDIO_MIDIIN = 103; (* Generic id for WDM Audio drivers *)
    MM_MSFT_WDMAUDIO_MIXER = 104; (* Generic id for WDM Audio drivers *)
    MM_MSFT_WDMAUDIO_AUX = 105; (* Generic id for WDM Audio drivers *)


    (* MM_CREATIVE product IDs *)
    MM_CREATIVE_SB15_WAVEIN = 1; (*  SB (r) 1.5 waveform input  *)
    MM_CREATIVE_SB20_WAVEIN = 2;
    MM_CREATIVE_SBPRO_WAVEIN = 3;
    MM_CREATIVE_SBP16_WAVEIN = 4;
    MM_CREATIVE_PHNBLST_WAVEIN = 5;
    MM_CREATIVE_SB15_WAVEOUT = 101;
    MM_CREATIVE_SB20_WAVEOUT = 102;
    MM_CREATIVE_SBPRO_WAVEOUT = 103;
    MM_CREATIVE_SBP16_WAVEOUT = 104;
    MM_CREATIVE_PHNBLST_WAVEOUT = 105;
    MM_CREATIVE_MIDIOUT = 201; (*  SB (r)  *)
    MM_CREATIVE_MIDIIN = 202; (*  SB (r)  *)
    MM_CREATIVE_FMSYNTH_MONO = 301; (*  SB (r)  *)
    MM_CREATIVE_FMSYNTH_STEREO = 302; (*  SB Pro (r) stereo synthesizer  *)
    MM_CREATIVE_MIDI_AWE32 = 303;
    MM_CREATIVE_AUX_CD = 401; (*  SB Pro (r) aux (CD)  *)
    MM_CREATIVE_AUX_LINE = 402; (*  SB Pro (r) aux (Line in )  *)
    MM_CREATIVE_AUX_MIC = 403; (*  SB Pro (r) aux (mic)  *)
    MM_CREATIVE_AUX_MASTER = 404;
    MM_CREATIVE_AUX_PCSPK = 405;
    MM_CREATIVE_AUX_WAVE = 406;
    MM_CREATIVE_AUX_MIDI = 407;
    MM_CREATIVE_SBPRO_MIXER = 408;
    MM_CREATIVE_SB16_MIXER = 409;

    (* MM_MEDIAVISION product IDs *)
    // Pro Audio Spectrum

    MM_MEDIAVISION_PROAUDIO = $10;
    MM_PROAUD_MIDIOUT = (MM_MEDIAVISION_PROAUDIO + 1);
    MM_PROAUD_MIDIIN = (MM_MEDIAVISION_PROAUDIO + 2);
    MM_PROAUD_SYNTH = (MM_MEDIAVISION_PROAUDIO + 3);
    MM_PROAUD_WAVEOUT = (MM_MEDIAVISION_PROAUDIO + 4);
    MM_PROAUD_WAVEIN = (MM_MEDIAVISION_PROAUDIO + 5);
    MM_PROAUD_MIXER = (MM_MEDIAVISION_PROAUDIO + 6);
    MM_PROAUD_AUX = (MM_MEDIAVISION_PROAUDIO + 7);

    // Thunder Board
    MM_MEDIAVISION_THUNDER = $20;
    MM_THUNDER_SYNTH = (MM_MEDIAVISION_THUNDER + 3);
    MM_THUNDER_WAVEOUT = (MM_MEDIAVISION_THUNDER + 4);
    MM_THUNDER_WAVEIN = (MM_MEDIAVISION_THUNDER + 5);
    MM_THUNDER_AUX = (MM_MEDIAVISION_THUNDER + 7);

    // Audio Port
    MM_MEDIAVISION_TPORT = $40;
    MM_TPORT_WAVEOUT = (MM_MEDIAVISION_TPORT + 1);
    MM_TPORT_WAVEIN = (MM_MEDIAVISION_TPORT + 2);
    MM_TPORT_SYNTH = (MM_MEDIAVISION_TPORT + 3);

    // Pro Audio Spectrum Plus
    MM_MEDIAVISION_PROAUDIO_PLUS = $50;
    MM_PROAUD_PLUS_MIDIOUT = (MM_MEDIAVISION_PROAUDIO_PLUS + 1);
    MM_PROAUD_PLUS_MIDIIN = (MM_MEDIAVISION_PROAUDIO_PLUS + 2);
    MM_PROAUD_PLUS_SYNTH = (MM_MEDIAVISION_PROAUDIO_PLUS + 3);
    MM_PROAUD_PLUS_WAVEOUT = (MM_MEDIAVISION_PROAUDIO_PLUS + 4);
    MM_PROAUD_PLUS_WAVEIN = (MM_MEDIAVISION_PROAUDIO_PLUS + 5);
    MM_PROAUD_PLUS_MIXER = (MM_MEDIAVISION_PROAUDIO_PLUS + 6);
    MM_PROAUD_PLUS_AUX = (MM_MEDIAVISION_PROAUDIO_PLUS + 7);

    // Pro Audio Spectrum 16
    MM_MEDIAVISION_PROAUDIO_16 = $60;
    MM_PROAUD_16_MIDIOUT = (MM_MEDIAVISION_PROAUDIO_16 + 1);
    MM_PROAUD_16_MIDIIN = (MM_MEDIAVISION_PROAUDIO_16 + 2);
    MM_PROAUD_16_SYNTH = (MM_MEDIAVISION_PROAUDIO_16 + 3);
    MM_PROAUD_16_WAVEOUT = (MM_MEDIAVISION_PROAUDIO_16 + 4);
    MM_PROAUD_16_WAVEIN = (MM_MEDIAVISION_PROAUDIO_16 + 5);
    MM_PROAUD_16_MIXER = (MM_MEDIAVISION_PROAUDIO_16 + 6);
    MM_PROAUD_16_AUX = (MM_MEDIAVISION_PROAUDIO_16 + 7);

    // Pro Audio Studio 16
    MM_MEDIAVISION_PROSTUDIO_16 = $60;
    MM_STUDIO_16_MIDIOUT = (MM_MEDIAVISION_PROSTUDIO_16 + 1);
    MM_STUDIO_16_MIDIIN = (MM_MEDIAVISION_PROSTUDIO_16 + 2);
    MM_STUDIO_16_SYNTH = (MM_MEDIAVISION_PROSTUDIO_16 + 3);
    MM_STUDIO_16_WAVEOUT = (MM_MEDIAVISION_PROSTUDIO_16 + 4);
    MM_STUDIO_16_WAVEIN = (MM_MEDIAVISION_PROSTUDIO_16 + 5);
    MM_STUDIO_16_MIXER = (MM_MEDIAVISION_PROSTUDIO_16 + 6);
    MM_STUDIO_16_AUX = (MM_MEDIAVISION_PROSTUDIO_16 + 7);

    // CDPC
    MM_MEDIAVISION_CDPC = $70;
    MM_CDPC_MIDIOUT = (MM_MEDIAVISION_CDPC + 1);
    MM_CDPC_MIDIIN = (MM_MEDIAVISION_CDPC + 2);
    MM_CDPC_SYNTH = (MM_MEDIAVISION_CDPC + 3);
    MM_CDPC_WAVEOUT = (MM_MEDIAVISION_CDPC + 4);
    MM_CDPC_WAVEIN = (MM_MEDIAVISION_CDPC + 5);
    MM_CDPC_MIXER = (MM_MEDIAVISION_CDPC + 6);
    MM_CDPC_AUX = (MM_MEDIAVISION_CDPC + 7);

    // Opus MV 1208 Chipsent
    MM_MEDIAVISION_OPUS1208 = $80;
    MM_OPUS401_MIDIOUT = (MM_MEDIAVISION_OPUS1208 + 1);
    MM_OPUS401_MIDIIN = (MM_MEDIAVISION_OPUS1208 + 2);
    MM_OPUS1208_SYNTH = (MM_MEDIAVISION_OPUS1208 + 3);
    MM_OPUS1208_WAVEOUT = (MM_MEDIAVISION_OPUS1208 + 4);
    MM_OPUS1208_WAVEIN = (MM_MEDIAVISION_OPUS1208 + 5);
    MM_OPUS1208_MIXER = (MM_MEDIAVISION_OPUS1208 + 6);
    MM_OPUS1208_AUX = (MM_MEDIAVISION_OPUS1208 + 7);

    // Opus MV 1216 chipset
    MM_MEDIAVISION_OPUS1216 = $90;
    MM_OPUS1216_MIDIOUT = (MM_MEDIAVISION_OPUS1216 + 1);
    MM_OPUS1216_MIDIIN = (MM_MEDIAVISION_OPUS1216 + 2);
    MM_OPUS1216_SYNTH = (MM_MEDIAVISION_OPUS1216 + 3);
    MM_OPUS1216_WAVEOUT = (MM_MEDIAVISION_OPUS1216 + 4);
    MM_OPUS1216_WAVEIN = (MM_MEDIAVISION_OPUS1216 + 5);
    MM_OPUS1216_MIXER = (MM_MEDIAVISION_OPUS1216 + 6);
    MM_OPUS1216_AUX = (MM_MEDIAVISION_OPUS1216 + 7);

    (* MM_CYRIX product IDs *)
    MM_CYRIX_XASYNTH = 1;
    MM_CYRIX_XAMIDIIN = 2;
    MM_CYRIX_XAMIDIOUT = 3;
    MM_CYRIX_XAWAVEIN = 4;
    MM_CYRIX_XAWAVEOUT = 5;
    MM_CYRIX_XAAUX = 6;
    MM_CYRIX_XAMIXER = 7;

    (* MM_PHILIPS_SPEECH_PROCESSING products IDs *)
    MM_PHILIPS_ACM_LPCBB = 1;

    (* MM_NETXL product IDs *)
    MM_NETXL_XLVIDEO = 1;

    (* MM_ZYXEL product IDs *)
    MM_ZYXEL_ACM_ADPCM = 1;

    (* MM_AARDVARK product IDs *)
    MM_AARDVARK_STUDIO12_WAVEOUT = 1;
    MM_AARDVARK_STUDIO12_WAVEIN = 2;
    MM_AARDVARK_STUDIO88_WAVEOUT = 3;
    MM_AARDVARK_STUDIO88_WAVEIN = 4;

    (* MM_BINTEC product IDs *)
    MM_BINTEC_TAPI_WAVE = 1;

    (* MM_HEWLETT_PACKARD product IDs *)
    MM_HEWLETT_PACKARD_CU_CODEC = 1;

    (* MM_MITEL product IDs *)
    MM_MITEL_TALKTO_LINE_WAVEOUT = 100;
    MM_MITEL_TALKTO_LINE_WAVEIN = 101;
    MM_MITEL_TALKTO_HANDSET_WAVEOUT = 102;
    MM_MITEL_TALKTO_HANDSET_WAVEIN = 103;
    MM_MITEL_TALKTO_BRIDGED_WAVEOUT = 104;
    MM_MITEL_TALKTO_BRIDGED_WAVEIN = 105;
    MM_MITEL_MPA_HANDSET_WAVEOUT = 200;
    MM_MITEL_MPA_HANDSET_WAVEIN = 201;
    MM_MITEL_MPA_HANDSFREE_WAVEOUT = 202;
    MM_MITEL_MPA_HANDSFREE_WAVEIN = 203;
    MM_MITEL_MPA_LINE1_WAVEOUT = 204;
    MM_MITEL_MPA_LINE1_WAVEIN = 205;
    MM_MITEL_MPA_LINE2_WAVEOUT = 206;
    MM_MITEL_MPA_LINE2_WAVEIN = 207;
    MM_MITEL_MEDIAPATH_WAVEOUT = 300;
    MM_MITEL_MEDIAPATH_WAVEIN = 301;

    (*  MM_SNI product IDs *)
    MM_SNI_ACM_G721 = 1;

    (* MM_EMU product IDs *)
    MM_EMU_APSSYNTH = 1;
    MM_EMU_APSMIDIIN = 2;
    MM_EMU_APSMIDIOUT = 3;
    MM_EMU_APSWAVEIN = 4;
    MM_EMU_APSWAVEOUT = 5;

    (* MM_ARTISOFT product IDs *)
    MM_ARTISOFT_SBWAVEIN = 1; (*  Artisoft sounding Board waveform input  *)
    MM_ARTISOFT_SBWAVEOUT = 2; (*  Artisoft sounding Board waveform output  *)

    (* MM_TURTLE_BEACH product IDs *)
    MM_TBS_TROPEZ_WAVEIN = 37;
    MM_TBS_TROPEZ_WAVEOUT = 38;
    MM_TBS_TROPEZ_AUX1 = 39;
    MM_TBS_TROPEZ_AUX2 = 40;
    MM_TBS_TROPEZ_LINE = 41;

    (* MM_IBM product IDs *)
    MM_MMOTION_WAVEAUX = 1; (*  IBM M-Motion Auxiliary Device  *)
    MM_MMOTION_WAVEOUT = 2; (*  IBM M-Motion Waveform output  *)
    MM_MMOTION_WAVEIN = 3; (*  IBM M-Motion  Waveform Input  *)
    MM_IBM_PCMCIA_WAVEIN = 11; (*  IBM waveform input  *)
    MM_IBM_PCMCIA_WAVEOUT = 12; (*  IBM Waveform output  *)
    MM_IBM_PCMCIA_SYNTH = 13; (*  IBM Midi Synthesis  *)
    MM_IBM_PCMCIA_MIDIIN = 14; (*  IBM external MIDI in  *)
    MM_IBM_PCMCIA_MIDIOUT = 15; (*  IBM external MIDI out  *)
    MM_IBM_PCMCIA_AUX = 16; (*  IBM auxiliary control  *)
    MM_IBM_THINKPAD200 = 17;
    MM_IBM_MWAVE_WAVEIN = 18;
    MM_IBM_MWAVE_WAVEOUT = 19;
    MM_IBM_MWAVE_MIXER = 20;
    MM_IBM_MWAVE_MIDIIN = 21;
    MM_IBM_MWAVE_MIDIOUT = 22;
    MM_IBM_MWAVE_AUX = 23;
    MM_IBM_WC_MIDIOUT = 30;
    MM_IBM_WC_WAVEOUT = 31;
    MM_IBM_WC_MIXEROUT = 33;

    (* MM_VOCALTEC product IDs *)
    MM_VOCALTEC_WAVEOUT = 1;
    MM_VOCALTEC_WAVEIN = 2;

    (* MM_ROLAND product IDs *)
    MM_ROLAND_RAP10_MIDIOUT = 10; (* MM_ROLAND_RAP10 *)
    MM_ROLAND_RAP10_MIDIIN = 11; (* MM_ROLAND_RAP10 *)
    MM_ROLAND_RAP10_SYNTH = 12; (* MM_ROLAND_RAP10 *)
    MM_ROLAND_RAP10_WAVEOUT = 13; (* MM_ROLAND_RAP10 *)
    MM_ROLAND_RAP10_WAVEIN = 14; (* MM_ROLAND_RAP10 *)
    MM_ROLAND_MPU401_MIDIOUT = 15;
    MM_ROLAND_MPU401_MIDIIN = 16;
    MM_ROLAND_SMPU_MIDIOUTA = 17;
    MM_ROLAND_SMPU_MIDIOUTB = 18;
    MM_ROLAND_SMPU_MIDIINA = 19;
    MM_ROLAND_SMPU_MIDIINB = 20;
    MM_ROLAND_SC7_MIDIOUT = 21;
    MM_ROLAND_SC7_MIDIIN = 22;
    MM_ROLAND_SERIAL_MIDIOUT = 23;
    MM_ROLAND_SERIAL_MIDIIN = 24;
    MM_ROLAND_SCP_MIDIOUT = 38;
    MM_ROLAND_SCP_MIDIIN = 39;
    MM_ROLAND_SCP_WAVEOUT = 40;
    MM_ROLAND_SCP_WAVEIN = 41;
    MM_ROLAND_SCP_MIXER = 42;
    MM_ROLAND_SCP_AUX = 48;

    (* MM_DSP_SOLUTIONS product IDs *)
    MM_DSP_SOLUTIONS_WAVEOUT = 1;
    MM_DSP_SOLUTIONS_WAVEIN = 2;
    MM_DSP_SOLUTIONS_SYNTH = 3;
    MM_DSP_SOLUTIONS_AUX = 4;

    (* MM_NEC product IDs *)
    MM_NEC_73_86_SYNTH = 5;
    MM_NEC_73_86_WAVEOUT = 6;
    MM_NEC_73_86_WAVEIN = 7;
    MM_NEC_26_SYNTH = 9;
    MM_NEC_MPU401_MIDIOUT = 10;
    MM_NEC_MPU401_MIDIIN = 11;
    MM_NEC_JOYSTICK = 12;

    (* MM_WANGLABS product IDs *)
    MM_WANGLABS_WAVEIN1 = 1; (*  Input audio wave on CPU board models: Exec 4010, 4030, 3450; PC 251/25c, pc 461/25s , pc 461/33c  *)
    MM_WANGLABS_WAVEOUT1 = 2;

    (* MM_TANDY product IDs *)
    MM_TANDY_VISWAVEIN = 1;
    MM_TANDY_VISWAVEOUT = 2;
    MM_TANDY_VISBIOSSYNTH = 3;
    MM_TANDY_SENS_MMAWAVEIN = 4;
    MM_TANDY_SENS_MMAWAVEOUT = 5;
    MM_TANDY_SENS_MMAMIDIIN = 6;
    MM_TANDY_SENS_MMAMIDIOUT = 7;
    MM_TANDY_SENS_VISWAVEOUT = 8;
    MM_TANDY_PSSJWAVEIN = 9;
    MM_TANDY_PSSJWAVEOUT = 10;

    (* MM_ANTEX product IDs *)
    MM_ANTEX_SX12_WAVEIN = 1;
    MM_ANTEX_SX12_WAVEOUT = 2;
    MM_ANTEX_SX15_WAVEIN = 3;
    MM_ANTEX_SX15_WAVEOUT = 4;
    MM_ANTEX_VP625_WAVEIN = 5;
    MM_ANTEX_VP625_WAVEOUT = 6;
    MM_ANTEX_AUDIOPORT22_WAVEIN = 7;
    MM_ANTEX_AUDIOPORT22_WAVEOUT = 8;
    MM_ANTEX_AUDIOPORT22_FEEDTHRU = 9;

    (* MM_INTEL product IDs *)
    MM_INTELOPD_WAVEIN = 1; (*  HID2 WaveAudio Driver  *)
    MM_INTELOPD_WAVEOUT = 101; (*  HID2  *)
    MM_INTELOPD_AUX = 401; (*  HID2 for mixing  *)
    MM_INTEL_NSPMODEMLINEIN = 501;
    MM_INTEL_NSPMODEMLINEOUT = 502;

    (* MM_VAL product IDs *)
    MM_VAL_MICROKEY_AP_WAVEIN = 1;
    MM_VAL_MICROKEY_AP_WAVEOUT = 2;

    (* MM_INTERACTIVE product IDs *)
    MM_INTERACTIVE_WAVEIN = $45;
    MM_INTERACTIVE_WAVEOUT = $45;

    (* MM_YAMAHA product IDs *)
    MM_YAMAHA_GSS_SYNTH = $01;
    MM_YAMAHA_GSS_WAVEOUT = $02;
    MM_YAMAHA_GSS_WAVEIN = $03;
    MM_YAMAHA_GSS_MIDIOUT = $04;
    MM_YAMAHA_GSS_MIDIIN = $05;
    MM_YAMAHA_GSS_AUX = $06;
    MM_YAMAHA_SERIAL_MIDIOUT = $07;
    MM_YAMAHA_SERIAL_MIDIIN = $08;
    MM_YAMAHA_OPL3SA_WAVEOUT = $10;
    MM_YAMAHA_OPL3SA_WAVEIN = $11;
    MM_YAMAHA_OPL3SA_FMSYNTH = $12;
    MM_YAMAHA_OPL3SA_YSYNTH = $13;
    MM_YAMAHA_OPL3SA_MIDIOUT = $14;
    MM_YAMAHA_OPL3SA_MIDIIN = $15;
    MM_YAMAHA_OPL3SA_MIXER = $17;
    MM_YAMAHA_OPL3SA_JOYSTICK = $18;
    MM_YAMAHA_YMF724LEG_MIDIOUT = $19;
    MM_YAMAHA_YMF724LEG_MIDIIN = $1a;
    MM_YAMAHA_YMF724_WAVEOUT = $1b;
    MM_YAMAHA_YMF724_WAVEIN = $1c;
    MM_YAMAHA_YMF724_MIDIOUT = $1d;
    MM_YAMAHA_YMF724_AUX = $1e;
    MM_YAMAHA_YMF724_MIXER = $1f;
    MM_YAMAHA_YMF724LEG_FMSYNTH = $20;
    MM_YAMAHA_YMF724LEG_MIXER = $21;
    MM_YAMAHA_SXG_MIDIOUT = $22;
    MM_YAMAHA_SXG_WAVEOUT = $23;
    MM_YAMAHA_SXG_MIXER = $24;
    MM_YAMAHA_ACXG_WAVEIN = $25;
    MM_YAMAHA_ACXG_WAVEOUT = $26;
    MM_YAMAHA_ACXG_MIDIOUT = $27;
    MM_YAMAHA_ACXG_MIXER = $28;
    MM_YAMAHA_ACXG_AUX = $29;

    (* MM_EVEREX product IDs *)
    MM_EVEREX_CARRIER = 1;

    (* MM_ECHO product IDs *)
    MM_ECHO_SYNTH = 1;
    MM_ECHO_WAVEOUT = 2;
    MM_ECHO_WAVEIN = 3;
    MM_ECHO_MIDIOUT = 4;
    MM_ECHO_MIDIIN = 5;
    MM_ECHO_AUX = 6;

    (* MM_SIERRA product IDs *)
    MM_SIERRA_ARIA_MIDIOUT = $14;
    MM_SIERRA_ARIA_MIDIIN = $15;
    MM_SIERRA_ARIA_SYNTH = $16;
    MM_SIERRA_ARIA_WAVEOUT = $17;
    MM_SIERRA_ARIA_WAVEIN = $18;
    MM_SIERRA_ARIA_AUX = $19;
    MM_SIERRA_ARIA_AUX2 = $20;
    MM_SIERRA_QUARTET_WAVEIN = $50;
    MM_SIERRA_QUARTET_WAVEOUT = $51;
    MM_SIERRA_QUARTET_MIDIIN = $52;
    MM_SIERRA_QUARTET_MIDIOUT = $53;
    MM_SIERRA_QUARTET_SYNTH = $54;
    MM_SIERRA_QUARTET_AUX_CD = $55;
    MM_SIERRA_QUARTET_AUX_LINE = $56;
    MM_SIERRA_QUARTET_AUX_MODEM = $57;
    MM_SIERRA_QUARTET_MIXER = $58;

    (* MM_CAT product IDs *)
    MM_CAT_WAVEOUT = 1;

    (* MM_DSP_GROUP product IDs *)
    MM_DSP_GROUP_TRUESPEECH = 1;

    (* MM_MELABS product IDs *)
    MM_MELABS_MIDI2GO = 1;

    (* MM_ESS product IDs *)
    MM_ESS_AMWAVEOUT = $01;
    MM_ESS_AMWAVEIN = $02;
    MM_ESS_AMAUX = $03;
    MM_ESS_AMSYNTH = $04;
    MM_ESS_AMMIDIOUT = $05;
    MM_ESS_AMMIDIIN = $06;
    MM_ESS_MIXER = $07;
    MM_ESS_AUX_CD = $08;
    MM_ESS_MPU401_MIDIOUT = $09;
    MM_ESS_MPU401_MIDIIN = $0A;
    MM_ESS_ES488_WAVEOUT = $10;
    MM_ESS_ES488_WAVEIN = $11;
    MM_ESS_ES488_MIXER = $12;
    MM_ESS_ES688_WAVEOUT = $13;
    MM_ESS_ES688_WAVEIN = $14;
    MM_ESS_ES688_MIXER = $15;
    MM_ESS_ES1488_WAVEOUT = $16;
    MM_ESS_ES1488_WAVEIN = $17;
    MM_ESS_ES1488_MIXER = $18;
    MM_ESS_ES1688_WAVEOUT = $19;
    MM_ESS_ES1688_WAVEIN = $1A;
    MM_ESS_ES1688_MIXER = $1B;
    MM_ESS_ES1788_WAVEOUT = $1C;
    MM_ESS_ES1788_WAVEIN = $1D;
    MM_ESS_ES1788_MIXER = $1E;
    MM_ESS_ES1888_WAVEOUT = $1F;
    MM_ESS_ES1888_WAVEIN = $20;
    MM_ESS_ES1888_MIXER = $21;
    MM_ESS_ES1868_WAVEOUT = $22;
    MM_ESS_ES1868_WAVEIN = $23;
    MM_ESS_ES1868_MIXER = $24;
    MM_ESS_ES1878_WAVEOUT = $25;
    MM_ESS_ES1878_WAVEIN = $26;
    MM_ESS_ES1878_MIXER = $27;

    (* MM_CANOPUS product IDs *)
    MM_CANOPUS_ACM_DVREX = 1;

    (* MM_EPSON product IDs *)
    MM_EPS_FMSND = 1;

    (* MM_TRUEVISION product IDs *)
    MM_TRUEVISION_WAVEIN1 = 1;
    MM_TRUEVISION_WAVEOUT1 = 2;

    (* MM_AZTECH product IDs *)
    MM_AZTECH_MIDIOUT = 3;
    MM_AZTECH_MIDIIN = 4;
    MM_AZTECH_WAVEIN = 17;
    MM_AZTECH_WAVEOUT = 18;
    MM_AZTECH_FMSYNTH = 20;
    MM_AZTECH_MIXER = 21;
    MM_AZTECH_PRO16_WAVEIN = 33;
    MM_AZTECH_PRO16_WAVEOUT = 34;
    MM_AZTECH_PRO16_FMSYNTH = 38;
    MM_AZTECH_DSP16_WAVEIN = 65;
    MM_AZTECH_DSP16_WAVEOUT = 66;
    MM_AZTECH_DSP16_FMSYNTH = 68;
    MM_AZTECH_DSP16_WAVESYNTH = 70;
    MM_AZTECH_NOVA16_WAVEIN = 71;
    MM_AZTECH_NOVA16_WAVEOUT = 72;
    MM_AZTECH_NOVA16_MIXER = 73;
    MM_AZTECH_WASH16_WAVEIN = 74;
    MM_AZTECH_WASH16_WAVEOUT = 75;
    MM_AZTECH_WASH16_MIXER = 76;
    MM_AZTECH_AUX_CD = 401;
    MM_AZTECH_AUX_LINE = 402;
    MM_AZTECH_AUX_MIC = 403;
    MM_AZTECH_AUX = 404;

    (* MM_VIDEOLOGIC product IDs *)
    MM_VIDEOLOGIC_MSWAVEIN = 1;
    MM_VIDEOLOGIC_MSWAVEOUT = 2;

    (* MM_KORG product IDs *)
    MM_KORG_PCIF_MIDIOUT = 1;
    MM_KORG_PCIF_MIDIIN = 2;
    MM_KORG_1212IO_MSWAVEIN = 3;
    MM_KORG_1212IO_MSWAVEOUT = 4;

    (* MM_APT product IDs *)
    MM_APT_ACE100CD = 1;

    (* MM_ICS product IDs *)
    MM_ICS_WAVEDECK_WAVEOUT = 1; (*  MS WSS compatible card and driver  *)
    MM_ICS_WAVEDECK_WAVEIN = 2;
    MM_ICS_WAVEDECK_MIXER = 3;
    MM_ICS_WAVEDECK_AUX = 4;
    MM_ICS_WAVEDECK_SYNTH = 5;
    MM_ICS_WAVEDEC_SB_WAVEOUT = 6;
    MM_ICS_WAVEDEC_SB_WAVEIN = 7;
    MM_ICS_WAVEDEC_SB_FM_MIDIOUT = 8;
    MM_ICS_WAVEDEC_SB_MPU401_MIDIOUT = 9;
    MM_ICS_WAVEDEC_SB_MPU401_MIDIIN = 10;
    MM_ICS_WAVEDEC_SB_MIXER = 11;
    MM_ICS_WAVEDEC_SB_AUX = 12;
    MM_ICS_2115_LITE_MIDIOUT = 13;
    MM_ICS_2120_LITE_MIDIOUT = 14;

    (* MM_ITERATEDSYS product IDs *)
    MM_ITERATEDSYS_FUFCODEC = 1;

    (* MM_METHEUS product IDs *)
    MM_METHEUS_ZIPPER = 1;

    (* MM_WINNOV product IDs *)
    MM_WINNOV_CAVIAR_WAVEIN = 1;
    MM_WINNOV_CAVIAR_WAVEOUT = 2;
    MM_WINNOV_CAVIAR_VIDC = 3;
    MM_WINNOV_CAVIAR_CHAMPAGNE = 4; (*  Fourcc is CHAM  *)
    MM_WINNOV_CAVIAR_YUV8 = 5; (*  Fourcc is YUV8  *)

    (* MM_NCR product IDs *)
    MM_NCR_BA_WAVEIN = 1;
    MM_NCR_BA_WAVEOUT = 2;
    MM_NCR_BA_SYNTH = 3;
    MM_NCR_BA_AUX = 4;
    MM_NCR_BA_MIXER = 5;

    (* MM_AST product IDs *)
    MM_AST_MODEMWAVE_WAVEIN = 13;
    MM_AST_MODEMWAVE_WAVEOUT = 14;

    (* MM_WILLOWPOND product IDs *)
    MM_WILLOWPOND_FMSYNTH_STEREO = 20;
    MM_WILLOWPOND_MPU401 = 21;
    MM_WILLOWPOND_SNDPORT_WAVEIN = 100;
    MM_WILLOWPOND_SNDPORT_WAVEOUT = 101;
    MM_WILLOWPOND_SNDPORT_MIXER = 102;
    MM_WILLOWPOND_SNDPORT_AUX = 103;
    MM_WILLOWPOND_PH_WAVEIN = 104;
    MM_WILLOWPOND_PH_WAVEOUT = 105;
    MM_WILLOWPOND_PH_MIXER = 106;
    MM_WILLOWPOND_PH_AUX = 107;
    MM_WILLOPOND_SNDCOMM_WAVEIN = 108;
    MM_WILLOWPOND_SNDCOMM_WAVEOUT = 109;
    MM_WILLOWPOND_SNDCOMM_MIXER = 110;
    MM_WILLOWPOND_SNDCOMM_AUX = 111;
    MM_WILLOWPOND_GENERIC_WAVEIN = 112;
    MM_WILLOWPOND_GENERIC_WAVEOUT = 113;
    MM_WILLOWPOND_GENERIC_MIXER = 114;
    MM_WILLOWPOND_GENERIC_AUX = 115;

    (* MM_VITEC product IDs *)
    MM_VITEC_VMAKER = 1;
    MM_VITEC_VMPRO = 2;

    (* MM_MOSCOM product IDs *)
    MM_MOSCOM_VPC2400_IN = 1; (*  Four Port Voice Processing / Voice Recognition Board  *)
    MM_MOSCOM_VPC2400_OUT = 2; (*  VPC2400 *)

    (* MM_SILICONSOFT product IDs *)
    MM_SILICONSOFT_SC1_WAVEIN = 1; (*  Waveform in , high sample rate  *)
    MM_SILICONSOFT_SC1_WAVEOUT = 2; (*  Waveform out , high sample rate  *)
    MM_SILICONSOFT_SC2_WAVEIN = 3; (*  Waveform in 2 channels, high sample rate  *)
    MM_SILICONSOFT_SC2_WAVEOUT = 4; (*  Waveform out 2 channels, high sample rate  *)
    MM_SILICONSOFT_SOUNDJR2_WAVEOUT = 5; (*  Waveform out, self powered, efficient  *)
    MM_SILICONSOFT_SOUNDJR2PR_WAVEIN = 6; (*  Waveform in, self powered, efficient  *)
    MM_SILICONSOFT_SOUNDJR2PR_WAVEOUT = 7; (*  Waveform out 2 channels, self powered, efficient  *)
    MM_SILICONSOFT_SOUNDJR3_WAVEOUT = 8; (*  Waveform in 2 channels, self powered, efficient  *)

    (* MM_TERRATEC product IDs *)
    MM_TTEWS_WAVEIN = 1;
    MM_TTEWS_WAVEOUT = 2;
    MM_TTEWS_MIDIIN = 3;
    MM_TTEWS_MIDIOUT = 4;
    MM_TTEWS_MIDISYNTH = 5;
    MM_TTEWS_MIDIMONITOR = 6;
    MM_TTEWS_VMIDIIN = 7;
    MM_TTEWS_VMIDIOUT = 8;
    MM_TTEWS_AUX = 9;
    MM_TTEWS_MIXER = 10;

    (* MM_MEDIASONIC product IDs *)
    MM_MEDIASONIC_ACM_G723 = 1;
    MM_MEDIASONIC_ICOM = 2;
    MM_ICOM_WAVEIN = 3;
    MM_ICOM_WAVEOUT = 4;
    MM_ICOM_MIXER = 5;
    MM_ICOM_AUX = 6;
    MM_ICOM_LINE = 7;

    (*  MM_SANYO product IDs *)
    MM_SANYO_ACM_LD_ADPCM = 1;

    (* MM_AHEAD product IDs *)
    MM_AHEAD_MULTISOUND = 1;
    MM_AHEAD_SOUNDBLASTER = 2;
    MM_AHEAD_PROAUDIO = 3;
    MM_AHEAD_GENERIC = 4;

    (* MM_OLIVETTI product IDs *)
    MM_OLIVETTI_WAVEIN = 1;
    MM_OLIVETTI_WAVEOUT = 2;
    MM_OLIVETTI_MIXER = 3;
    MM_OLIVETTI_AUX = 4;
    MM_OLIVETTI_MIDIIN = 5;
    MM_OLIVETTI_MIDIOUT = 6;
    MM_OLIVETTI_SYNTH = 7;
    MM_OLIVETTI_JOYSTICK = 8;
    MM_OLIVETTI_ACM_GSM = 9;
    MM_OLIVETTI_ACM_ADPCM = 10;
    MM_OLIVETTI_ACM_CELP = 11;
    MM_OLIVETTI_ACM_SBC = 12;
    MM_OLIVETTI_ACM_OPR = 13;

    (* MM_IOMAGIC product IDs *)
    MM_IOMAGIC_TEMPO_WAVEOUT = 1;
    MM_IOMAGIC_TEMPO_WAVEIN = 2;
    MM_IOMAGIC_TEMPO_SYNTH = 3;
    MM_IOMAGIC_TEMPO_MIDIOUT = 4;
    MM_IOMAGIC_TEMPO_MXDOUT = 5;
    MM_IOMAGIC_TEMPO_AUXOUT = 6;

    (* MM_MATSUSHITA product IDs *)
    MM_MATSUSHITA_WAVEIN = 1;
    MM_MATSUSHITA_WAVEOUT = 2;
    MM_MATSUSHITA_FMSYNTH_STEREO = 3;
    MM_MATSUSHITA_MIXER = 4;
    MM_MATSUSHITA_AUX = 5;

    (* MM_NEWMEDIA product IDs *)
    MM_NEWMEDIA_WAVJAMMER = 1; (*  WSS Compatible sound card.  *)

    (* MM_LYRRUS product IDs *)
    MM_LYRRUS_BRIDGE_GUITAR = 1;

    (* MM_OPTI product IDs *)
    MM_OPTI_M16_FMSYNTH_STEREO = $0001;
    MM_OPTI_M16_MIDIIN = $0002;
    MM_OPTI_M16_MIDIOUT = $0003;
    MM_OPTI_M16_WAVEIN = $0004;
    MM_OPTI_M16_WAVEOUT = $0005;
    MM_OPTI_M16_MIXER = $0006;
    MM_OPTI_M16_AUX = $0007;
    MM_OPTI_P16_FMSYNTH_STEREO = $0010;
    MM_OPTI_P16_MIDIIN = $0011;
    MM_OPTI_P16_MIDIOUT = $0012;
    MM_OPTI_P16_WAVEIN = $0013;
    MM_OPTI_P16_WAVEOUT = $0014;
    MM_OPTI_P16_MIXER = $0015;
    MM_OPTI_P16_AUX = $0016;
    MM_OPTI_M32_WAVEIN = $0020;
    MM_OPTI_M32_WAVEOUT = $0021;
    MM_OPTI_M32_MIDIIN = $0022;
    MM_OPTI_M32_MIDIOUT = $0023;
    MM_OPTI_M32_SYNTH_STEREO = $0024;
    MM_OPTI_M32_MIXER = $0025;
    MM_OPTI_M32_AUX = $0026;

    (* MM_COMPAQ product IDs *)
    MM_COMPAQ_BB_WAVEIN = 1;
    MM_COMPAQ_BB_WAVEOUT = 2;
    MM_COMPAQ_BB_WAVEAUX = 3;

    (* MM_MPTUS product IDs *)
    MM_MPTUS_SPWAVEOUT = 1; (* Sound Pallette *)

    (* MM_LERNOUT_AND_HAUSPIE product IDs *)
    MM_LERNOUT_ANDHAUSPIE_LHCODECACM = 1;

    (* MM_DIGITAL product IDs *)
    MM_DIGITAL_AV320_WAVEIN = 1; (* Digital Audio Video Compression Board *)
    MM_DIGITAL_AV320_WAVEOUT = 2; (* Digital Audio Video Compression Board *)
    MM_DIGITAL_ACM_G723 = 3;
    MM_DIGITAL_ICM_H263 = 4;
    MM_DIGITAL_ICM_H261 = 5;

    (* MM_MOTU product IDs *)
    MM_MOTU_MTP_MIDIOUT_ALL = 100;
    MM_MOTU_MTP_MIDIIN_1 = 101;
    MM_MOTU_MTP_MIDIOUT_1 = 101;
    MM_MOTU_MTP_MIDIIN_2 = 102;
    MM_MOTU_MTP_MIDIOUT_2 = 102;
    MM_MOTU_MTP_MIDIIN_3 = 103;
    MM_MOTU_MTP_MIDIOUT_3 = 103;
    MM_MOTU_MTP_MIDIIN_4 = 104;
    MM_MOTU_MTP_MIDIOUT_4 = 104;
    MM_MOTU_MTP_MIDIIN_5 = 105;
    MM_MOTU_MTP_MIDIOUT_5 = 105;
    MM_MOTU_MTP_MIDIIN_6 = 106;
    MM_MOTU_MTP_MIDIOUT_6 = 106;
    MM_MOTU_MTP_MIDIIN_7 = 107;
    MM_MOTU_MTP_MIDIOUT_7 = 107;
    MM_MOTU_MTP_MIDIIN_8 = 108;
    MM_MOTU_MTP_MIDIOUT_8 = 108;

    MM_MOTU_MTPII_MIDIOUT_ALL = 200;
    MM_MOTU_MTPII_MIDIIN_SYNC = 200;
    MM_MOTU_MTPII_MIDIIN_1 = 201;
    MM_MOTU_MTPII_MIDIOUT_1 = 201;
    MM_MOTU_MTPII_MIDIIN_2 = 202;
    MM_MOTU_MTPII_MIDIOUT_2 = 202;
    MM_MOTU_MTPII_MIDIIN_3 = 203;
    MM_MOTU_MTPII_MIDIOUT_3 = 203;
    MM_MOTU_MTPII_MIDIIN_4 = 204;
    MM_MOTU_MTPII_MIDIOUT_4 = 204;
    MM_MOTU_MTPII_MIDIIN_5 = 205;
    MM_MOTU_MTPII_MIDIOUT_5 = 205;
    MM_MOTU_MTPII_MIDIIN_6 = 206;
    MM_MOTU_MTPII_MIDIOUT_6 = 206;
    MM_MOTU_MTPII_MIDIIN_7 = 207;
    MM_MOTU_MTPII_MIDIOUT_7 = 207;
    MM_MOTU_MTPII_MIDIIN_8 = 208;
    MM_MOTU_MTPII_MIDIOUT_8 = 208;
    MM_MOTU_MTPII_NET_MIDIIN_1 = 209;
    MM_MOTU_MTPII_NET_MIDIOUT_1 = 209;
    MM_MOTU_MTPII_NET_MIDIIN_2 = 210;
    MM_MOTU_MTPII_NET_MIDIOUT_2 = 210;
    MM_MOTU_MTPII_NET_MIDIIN_3 = 211;
    MM_MOTU_MTPII_NET_MIDIOUT_3 = 211;
    MM_MOTU_MTPII_NET_MIDIIN_4 = 212;
    MM_MOTU_MTPII_NET_MIDIOUT_4 = 212;
    MM_MOTU_MTPII_NET_MIDIIN_5 = 213;
    MM_MOTU_MTPII_NET_MIDIOUT_5 = 213;
    MM_MOTU_MTPII_NET_MIDIIN_6 = 214;
    MM_MOTU_MTPII_NET_MIDIOUT_6 = 214;
    MM_MOTU_MTPII_NET_MIDIIN_7 = 215;
    MM_MOTU_MTPII_NET_MIDIOUT_7 = 215;
    MM_MOTU_MTPII_NET_MIDIIN_8 = 216;
    MM_MOTU_MTPII_NET_MIDIOUT_8 = 216;

    MM_MOTU_MXP_MIDIIN_MIDIOUT_ALL = 300;
    MM_MOTU_MXP_MIDIIN_SYNC = 300;
    MM_MOTU_MXP_MIDIIN_MIDIIN_1 = 301;
    MM_MOTU_MXP_MIDIIN_MIDIOUT_1 = 301;
    MM_MOTU_MXP_MIDIIN_MIDIIN_2 = 302;
    MM_MOTU_MXP_MIDIIN_MIDIOUT_2 = 302;
    MM_MOTU_MXP_MIDIIN_MIDIIN_3 = 303;
    MM_MOTU_MXP_MIDIIN_MIDIOUT_3 = 303;
    MM_MOTU_MXP_MIDIIN_MIDIIN_4 = 304;
    MM_MOTU_MXP_MIDIIN_MIDIOUT_4 = 304;
    MM_MOTU_MXP_MIDIIN_MIDIIN_5 = 305;
    MM_MOTU_MXP_MIDIIN_MIDIOUT_5 = 305;
    MM_MOTU_MXP_MIDIIN_MIDIIN_6 = 306;
    MM_MOTU_MXP_MIDIIN_MIDIOUT_6 = 306;

    MM_MOTU_MXPMPU_MIDIOUT_ALL = 400;
    MM_MOTU_MXPMPU_MIDIIN_SYNC = 400;
    MM_MOTU_MXPMPU_MIDIIN_1 = 401;
    MM_MOTU_MXPMPU_MIDIOUT_1 = 401;
    MM_MOTU_MXPMPU_MIDIIN_2 = 402;
    MM_MOTU_MXPMPU_MIDIOUT_2 = 402;
    MM_MOTU_MXPMPU_MIDIIN_3 = 403;
    MM_MOTU_MXPMPU_MIDIOUT_3 = 403;
    MM_MOTU_MXPMPU_MIDIIN_4 = 404;
    MM_MOTU_MXPMPU_MIDIOUT_4 = 404;
    MM_MOTU_MXPMPU_MIDIIN_5 = 405;
    MM_MOTU_MXPMPU_MIDIOUT_5 = 405;
    MM_MOTU_MXPMPU_MIDIIN_6 = 406;
    MM_MOTU_MXPMPU_MIDIOUT_6 = 406;

    MM_MOTU_MXN_MIDIOUT_ALL = 500;
    MM_MOTU_MXN_MIDIIN_SYNC = 500;
    MM_MOTU_MXN_MIDIIN_1 = 501;
    MM_MOTU_MXN_MIDIOUT_1 = 501;
    MM_MOTU_MXN_MIDIIN_2 = 502;
    MM_MOTU_MXN_MIDIOUT_2 = 502;
    MM_MOTU_MXN_MIDIIN_3 = 503;
    MM_MOTU_MXN_MIDIOUT_3 = 503;
    MM_MOTU_MXN_MIDIIN_4 = 504;
    MM_MOTU_MXN_MIDIOUT_4 = 504;

    MM_MOTU_FLYER_MIDI_IN_SYNC = 600;
    MM_MOTU_FLYER_MIDI_IN_A = 601;
    MM_MOTU_FLYER_MIDI_OUT_A = 601;
    MM_MOTU_FLYER_MIDI_IN_B = 602;
    MM_MOTU_FLYER_MIDI_OUT_B = 602;

    MM_MOTU_PKX_MIDI_IN_SYNC = 700;
    MM_MOTU_PKX_MIDI_IN_A = 701;
    MM_MOTU_PKX_MIDI_OUT_A = 701;
    MM_MOTU_PKX_MIDI_IN_B = 702;
    MM_MOTU_PKX_MIDI_OUT_B = 702;

    MM_MOTU_DTX_MIDI_IN_SYNC = 800;
    MM_MOTU_DTX_MIDI_IN_A = 801;
    MM_MOTU_DTX_MIDI_OUT_A = 801;
    MM_MOTU_DTX_MIDI_IN_B = 802;
    MM_MOTU_DTX_MIDI_OUT_B = 802;

    MM_MOTU_MTPAV_MIDIOUT_ALL = 900;
    MM_MOTU_MTPAV_MIDIIN_SYNC = 900;
    MM_MOTU_MTPAV_MIDIIN_1 = 901;
    MM_MOTU_MTPAV_MIDIOUT_1 = 901;
    MM_MOTU_MTPAV_MIDIIN_2 = 902;
    MM_MOTU_MTPAV_MIDIOUT_2 = 902;
    MM_MOTU_MTPAV_MIDIIN_3 = 903;
    MM_MOTU_MTPAV_MIDIOUT_3 = 903;
    MM_MOTU_MTPAV_MIDIIN_4 = 904;
    MM_MOTU_MTPAV_MIDIOUT_4 = 904;
    MM_MOTU_MTPAV_MIDIIN_5 = 905;
    MM_MOTU_MTPAV_MIDIOUT_5 = 905;
    MM_MOTU_MTPAV_MIDIIN_6 = 906;
    MM_MOTU_MTPAV_MIDIOUT_6 = 906;
    MM_MOTU_MTPAV_MIDIIN_7 = 907;
    MM_MOTU_MTPAV_MIDIOUT_7 = 907;
    MM_MOTU_MTPAV_MIDIIN_8 = 908;
    MM_MOTU_MTPAV_MIDIOUT_8 = 908;
    MM_MOTU_MTPAV_NET_MIDIIN_1 = 909;
    MM_MOTU_MTPAV_NET_MIDIOUT_1 = 909;
    MM_MOTU_MTPAV_NET_MIDIIN_2 = 910;
    MM_MOTU_MTPAV_NET_MIDIOUT_2 = 910;
    MM_MOTU_MTPAV_NET_MIDIIN_3 = 911;
    MM_MOTU_MTPAV_NET_MIDIOUT_3 = 911;
    MM_MOTU_MTPAV_NET_MIDIIN_4 = 912;
    MM_MOTU_MTPAV_NET_MIDIOUT_4 = 912;
    MM_MOTU_MTPAV_NET_MIDIIN_5 = 913;
    MM_MOTU_MTPAV_NET_MIDIOUT_5 = 913;
    MM_MOTU_MTPAV_NET_MIDIIN_6 = 914;
    MM_MOTU_MTPAV_NET_MIDIOUT_6 = 914;
    MM_MOTU_MTPAV_NET_MIDIIN_7 = 915;
    MM_MOTU_MTPAV_NET_MIDIOUT_7 = 915;
    MM_MOTU_MTPAV_NET_MIDIIN_8 = 916;
    MM_MOTU_MTPAV_NET_MIDIOUT_8 = 916;
    MM_MOTU_MTPAV_MIDIIN_ADAT = 917;
    MM_MOTU_MTPAV_MIDIOUT_ADAT = 917;
    MM_MOTU_MXPXT_MIDIIN_SYNC = 1000;
    MM_MOTU_MXPXT_MIDIOUT_ALL = 1000;
    MM_MOTU_MXPXT_MIDIIN_1 = 1001;
    MM_MOTU_MXPXT_MIDIOUT_1 = 1001;
    MM_MOTU_MXPXT_MIDIOUT_2 = 1002;
    MM_MOTU_MXPXT_MIDIIN_2 = 1002;
    MM_MOTU_MXPXT_MIDIIN_3 = 1003;
    MM_MOTU_MXPXT_MIDIOUT_3 = 1003;
    MM_MOTU_MXPXT_MIDIIN_4 = 1004;
    MM_MOTU_MXPXT_MIDIOUT_4 = 1004;
    MM_MOTU_MXPXT_MIDIIN_5 = 1005;
    MM_MOTU_MXPXT_MIDIOUT_5 = 1005;
    MM_MOTU_MXPXT_MIDIOUT_6 = 1006;
    MM_MOTU_MXPXT_MIDIIN_6 = 1006;
    MM_MOTU_MXPXT_MIDIOUT_7 = 1007;
    MM_MOTU_MXPXT_MIDIIN_7 = 1007;
    MM_MOTU_MXPXT_MIDIOUT_8 = 1008;
    MM_MOTU_MXPXT_MIDIIN_8 = 1008;

    (* MM_WORKBIT product IDs *)
    MM_WORKBIT_MIXER = 1; (* Harmony Mixer *)
    MM_WORKBIT_WAVEOUT = 2; (* Harmony Mixer *)
    MM_WORKBIT_WAVEIN = 3; (* Harmony Mixer *)
    MM_WORKBIT_MIDIIN = 4; (* Harmony Mixer *)
    MM_WORKBIT_MIDIOUT = 5; (* Harmony Mixer *)
    MM_WORKBIT_FMSYNTH = 6; (* Harmony Mixer *)
    MM_WORKBIT_AUX = 7; (* Harmony Mixer *)
    MM_WORKBIT_JOYSTICK = 8;

    (* MM_OSITECH product IDs *)
    MM_OSITECH_TRUMPCARD = 1; (* Trumpcard *)

    (* MM_MIRO product IDs *)
    MM_MIRO_MOVIEPRO = 1; (* miroMOVIE pro *)
    MM_MIRO_VIDEOD1 = 2; (* miroVIDEO D1 *)
    MM_MIRO_VIDEODC1TV = 3; (* miroVIDEO DC1 tv *)
    MM_MIRO_VIDEOTD = 4; (* miroVIDEO 10/20 TD *)
    MM_MIRO_DC30_WAVEOUT = 5;
    MM_MIRO_DC30_WAVEIN = 6;
    MM_MIRO_DC30_MIX = 7;


    (* MM_ISOLUTION product IDs *)
    MM_ISOLUTION_PASCAL = 1;

    (* MM_ROCKWELL product IDs *)
    MM_VOICEMIXER = 1;
    ROCKWELL_WA1_WAVEIN = 100;
    ROCKWELL_WA1_WAVEOUT = 101;
    ROCKWELL_WA1_SYNTH = 102;
    ROCKWELL_WA1_MIXER = 103;
    ROCKWELL_WA1_MPU401_IN = 104;
    ROCKWELL_WA1_MPU401_OUT = 105;
    ROCKWELL_WA2_WAVEIN = 200;
    ROCKWELL_WA2_WAVEOUT = 201;
    ROCKWELL_WA2_SYNTH = 202;
    ROCKWELL_WA2_MIXER = 203;
    ROCKWELL_WA2_MPU401_IN = 204;
    ROCKWELL_WA2_MPU401_OUT = 205;

    (* MM_VOXWARE product IDs *)
    MM_VOXWARE_CODEC = 1;

    (* MM_NORTHERN_TELECOM product IDs *)
    MM_NORTEL_MPXAC_WAVEIN = 1; (* MPX Audio Card Wave Input Device *)
    MM_NORTEL_MPXAC_WAVEOUT = 2; (* MPX Audio Card Wave Output Device *)

    (* MM_ADDX product IDs *)
    MM_ADDX_PCTV_DIGITALMIX = 1; (* MM_ADDX_PCTV_DIGITALMIX *)
    MM_ADDX_PCTV_WAVEIN = 2; (* MM_ADDX_PCTV_WAVEIN *)
    MM_ADDX_PCTV_WAVEOUT = 3; (* MM_ADDX_PCTV_WAVEOUT *)
    MM_ADDX_PCTV_MIXER = 4; (* MM_ADDX_PCTV_MIXER *)
    MM_ADDX_PCTV_AUX_CD = 5; (* MM_ADDX_PCTV_AUX_CD *)
    MM_ADDX_PCTV_AUX_LINE = 6; (* MM_ADDX_PCTV_AUX_LINE *)

    (* MM_WILDCAT product IDs *)
    MM_WILDCAT_AUTOSCOREMIDIIN = 1; (* Autoscore *)

    (* MM_RHETOREX product IDs *)
    MM_RHETOREX_WAVEIN = 1;
    MM_RHETOREX_WAVEOUT = 2;

    (* MM_BROOKTREE product IDs *)
    MM_BTV_WAVEIN = 1; (* Brooktree PCM Wave Audio In *)
    MM_BTV_WAVEOUT = 2; (* Brooktree PCM Wave Audio Out *)
    MM_BTV_MIDIIN = 3; (* Brooktree MIDI In *)
    MM_BTV_MIDIOUT = 4; (* Brooktree MIDI out *)
    MM_BTV_MIDISYNTH = 5; (* Brooktree MIDI FM synth *)
    MM_BTV_AUX_LINE = 6; (* Brooktree Line Input *)
    MM_BTV_AUX_MIC = 7; (* Brooktree Microphone Input *)
    MM_BTV_AUX_CD = 8; (* Brooktree CD Input *)
    MM_BTV_DIGITALIN = 9; (* Brooktree PCM Wave in with subcode information *)
    MM_BTV_DIGITALOUT = 10; (* Brooktree PCM Wave out with subcode information *)
    MM_BTV_MIDIWAVESTREAM = 11; (* Brooktree WaveStream *)
    MM_BTV_MIXER = 12; (* Brooktree WSS Mixer driver *)

    (* MM_ENSONIQ product IDs *)
    MM_ENSONIQ_SOUNDSCAPE = $10; (* ENSONIQ Soundscape *)
    MM_SOUNDSCAPE_WAVEOUT = MM_ENSONIQ_SOUNDSCAPE + 1;
    MM_SOUNDSCAPE_WAVEOUT_AUX = MM_ENSONIQ_SOUNDSCAPE + 2;
    MM_SOUNDSCAPE_WAVEIN = MM_ENSONIQ_SOUNDSCAPE + 3;
    MM_SOUNDSCAPE_MIDIOUT = MM_ENSONIQ_SOUNDSCAPE + 4;
    MM_SOUNDSCAPE_MIDIIN = MM_ENSONIQ_SOUNDSCAPE + 5;
    MM_SOUNDSCAPE_SYNTH = MM_ENSONIQ_SOUNDSCAPE + 6;
    MM_SOUNDSCAPE_MIXER = MM_ENSONIQ_SOUNDSCAPE + 7;
    MM_SOUNDSCAPE_AUX = MM_ENSONIQ_SOUNDSCAPE + 8;

    (* MM_NVIDIA product IDs *)
    MM_NVIDIA_WAVEOUT = 1;
    MM_NVIDIA_WAVEIN = 2;
    MM_NVIDIA_MIDIOUT = 3;
    MM_NVIDIA_MIDIIN = 4;
    MM_NVIDIA_GAMEPORT = 5;
    MM_NVIDIA_MIXER = 6;
    MM_NVIDIA_AUX = 7;

    (* MM_OKSORI product IDs *)
    MM_OKSORI_BASE = 0; (* Oksori Base *)
    MM_OKSORI_OSR8_WAVEOUT = MM_OKSORI_BASE + 1; (* Oksori 8bit Wave out *)
    MM_OKSORI_OSR8_WAVEIN = MM_OKSORI_BASE + 2; (* Oksori 8bit Wave in *)
    MM_OKSORI_OSR16_WAVEOUT = MM_OKSORI_BASE + 3; (* Oksori 16 bit Wave out *)
    MM_OKSORI_OSR16_WAVEIN = MM_OKSORI_BASE + 4; (* Oksori 16 bit Wave in *)
    MM_OKSORI_FM_OPL4 = MM_OKSORI_BASE + 5; (* Oksori FM Synth Yamaha OPL4 *)
    MM_OKSORI_MIX_MASTER = MM_OKSORI_BASE + 6; (* Oksori DSP Mixer - Master Volume *)
    MM_OKSORI_MIX_WAVE = MM_OKSORI_BASE + 7; (* Oksori DSP Mixer - Wave Volume *)
    MM_OKSORI_MIX_FM = MM_OKSORI_BASE + 8; (* Oksori DSP Mixer - FM Volume *)
    MM_OKSORI_MIX_LINE = MM_OKSORI_BASE + 9; (* Oksori DSP Mixer - Line Volume *)
    MM_OKSORI_MIX_CD = MM_OKSORI_BASE + 10; (* Oksori DSP Mixer - CD Volume *)
    MM_OKSORI_MIX_MIC = MM_OKSORI_BASE + 11; (* Oksori DSP Mixer - MIC Volume *)
    MM_OKSORI_MIX_ECHO = MM_OKSORI_BASE + 12; (* Oksori DSP Mixer - Echo Volume *)
    MM_OKSORI_MIX_AUX1 = MM_OKSORI_BASE + 13; (* Oksori AD1848 - AUX1 Volume *)
    MM_OKSORI_MIX_LINE1 = MM_OKSORI_BASE + 14; (* Oksori AD1848 - LINE1 Volume *)
    MM_OKSORI_EXT_MIC1 = MM_OKSORI_BASE + 15; (* Oksori External - One Mic Connect *)
    MM_OKSORI_EXT_MIC2 = MM_OKSORI_BASE + 16; (* Oksori External - Two Mic Connect *)
    MM_OKSORI_MIDIOUT = MM_OKSORI_BASE + 17; (* Oksori MIDI Out Device *)
    MM_OKSORI_MIDIIN = MM_OKSORI_BASE + 18; (* Oksori MIDI In Device *)
    MM_OKSORI_MPEG_CDVISION = MM_OKSORI_BASE + 19; (* Oksori CD-Vision MPEG Decoder *)

    (* MM_DIACOUSTICS product IDs *)
    MM_DIACOUSTICS_DRUM_ACTION = 1; (* Drum Action *)

    (* MM_KAY_ELEMETRICS product IDs *)
    MM_KAY_ELEMETRICS_CSL = $4300;
    MM_KAY_ELEMETRICS_CSL_DAT = $4308;
    MM_KAY_ELEMETRICS_CSL_4CHANNEL = $4309;

    (* MM_CRYSTAL product IDs *)
    MM_CRYSTAL_CS4232_WAVEIN = 1;
    MM_CRYSTAL_CS4232_WAVEOUT = 2;
    MM_CRYSTAL_CS4232_WAVEMIXER = 3;
    MM_CRYSTAL_CS4232_WAVEAUX_AUX1 = 4;
    MM_CRYSTAL_CS4232_WAVEAUX_AUX2 = 5;
    MM_CRYSTAL_CS4232_WAVEAUX_LINE = 6;
    MM_CRYSTAL_CS4232_WAVEAUX_MONO = 7;
    MM_CRYSTAL_CS4232_WAVEAUX_MASTER = 8;
    MM_CRYSTAL_CS4232_MIDIIN = 9;
    MM_CRYSTAL_CS4232_MIDIOUT = 10;
    MM_CRYSTAL_CS4232_INPUTGAIN_AUX1 = 13;
    MM_CRYSTAL_CS4232_INPUTGAIN_LOOP = 14;
    MM_CRYSTAL_SOUND_FUSION_WAVEIN = 21;
    MM_CRYSTAL_SOUND_FUSION_WAVEOUT = 22;
    MM_CRYSTAL_SOUND_FUSION_MIXER = 23;
    MM_CRYSTAL_SOUND_FUSION_MIDIIN = 24;
    MM_CRYSTAL_SOUND_FUSION_MIDIOUT = 25;
    MM_CRYSTAL_SOUND_FUSION_JOYSTICK = 26;

    (* MM_QUARTERDECK product IDs *)
    MM_QUARTERDECK_LHWAVEIN = 0; (* Quarterdeck L&H Codec Wave In *)
    MM_QUARTERDECK_LHWAVEOUT = 1; (* Quarterdeck L&H Codec Wave Out *)

    (* MM_TDK product IDs *)
    MM_TDK_MW_MIDI_SYNTH = 1;
    MM_TDK_MW_MIDI_IN = 2;
    MM_TDK_MW_MIDI_OUT = 3;
    MM_TDK_MW_WAVE_IN = 4;
    MM_TDK_MW_WAVE_OUT = 5;
    MM_TDK_MW_AUX = 6;
    MM_TDK_MW_MIXER = 10;
    MM_TDK_MW_AUX_MASTER = 100;
    MM_TDK_MW_AUX_BASS = 101;
    MM_TDK_MW_AUX_TREBLE = 102;
    MM_TDK_MW_AUX_MIDI_VOL = 103;
    MM_TDK_MW_AUX_WAVE_VOL = 104;
    MM_TDK_MW_AUX_WAVE_RVB = 105;
    MM_TDK_MW_AUX_WAVE_CHR = 106;
    MM_TDK_MW_AUX_VOL = 107;
    MM_TDK_MW_AUX_RVB = 108;
    MM_TDK_MW_AUX_CHR = 109;

    (* MM_DIGITAL_AUDIO_LABS product IDs *)
    MM_DIGITAL_AUDIO_LABS_TC = $01;
    MM_DIGITAL_AUDIO_LABS_DOC = $02;
    MM_DIGITAL_AUDIO_LABS_V8 = $10;
    MM_DIGITAL_AUDIO_LABS_CPRO = $11;
    MM_DIGITAL_AUDIO_LABS_VP = $12;
    MM_DIGITAL_AUDIO_LABS_CDLX = $13;
    MM_DIGITAL_AUDIO_LABS_CTDIF = $14;

    (* MM_SEERSYS product IDs *)
    MM_SEERSYS_SEERSYNTH = 1;
    MM_SEERSYS_SEERWAVE = 2;
    MM_SEERSYS_SEERMIX = 3;
    MM_SEERSYS_WAVESYNTH = 4;
    MM_SEERSYS_WAVESYNTH_WG = 5;
    MM_SEERSYS_REALITY = 6;

    (* MM_OSPREY product IDs *)
    MM_OSPREY_1000WAVEIN = 1;
    MM_OSPREY_1000WAVEOUT = 2;

    (* MM_SOUNDESIGNS product IDs *)
    MM_SOUNDESIGNS_WAVEIN = 1;
    MM_SOUNDESIGNS_WAVEOUT = 2;

    (* MM_SPECTRUM_SIGNAL_PROCESSING product IDs *)
    MM_SSP_SNDFESWAVEIN = 1; (* Sound Festa Wave In Device *)
    MM_SSP_SNDFESWAVEOUT = 2; (* Sound Festa Wave Out Device *)
    MM_SSP_SNDFESMIDIIN = 3; (* Sound Festa MIDI In Device *)
    MM_SSP_SNDFESMIDIOUT = 4; (* Sound Festa MIDI Out Device *)
    MM_SSP_SNDFESSYNTH = 5; (* Sound Festa MIDI Synth Device *)
    MM_SSP_SNDFESMIX = 6; (* Sound Festa Mixer Device *)
    MM_SSP_SNDFESAUX = 7; (* Sound Festa Auxilliary Device *)

    (* MM_ECS product IDs *)
    MM_ECS_AADF_MIDI_IN = 10;
    MM_ECS_AADF_MIDI_OUT = 11;
    MM_ECS_AADF_WAVE2MIDI_IN = 12;

    (* MM_AMD product IDs *)
    MM_AMD_INTERWAVE_WAVEIN = 1;
    MM_AMD_INTERWAVE_WAVEOUT = 2;
    MM_AMD_INTERWAVE_SYNTH = 3;
    MM_AMD_INTERWAVE_MIXER1 = 4;
    MM_AMD_INTERWAVE_MIXER2 = 5;
    MM_AMD_INTERWAVE_JOYSTICK = 6;
    MM_AMD_INTERWAVE_EX_CD = 7;
    MM_AMD_INTERWAVE_MIDIIN = 8;
    MM_AMD_INTERWAVE_MIDIOUT = 9;
    MM_AMD_INTERWAVE_AUX1 = 10;
    MM_AMD_INTERWAVE_AUX2 = 11;
    MM_AMD_INTERWAVE_AUX_MIC = 12;
    MM_AMD_INTERWAVE_AUX_CD = 13;
    MM_AMD_INTERWAVE_MONO_IN = 14;
    MM_AMD_INTERWAVE_MONO_OUT = 15;
    MM_AMD_INTERWAVE_EX_TELEPHONY = 16;
    MM_AMD_INTERWAVE_WAVEOUT_BASE = 17;
    MM_AMD_INTERWAVE_WAVEOUT_TREBLE = 18;
    MM_AMD_INTERWAVE_STEREO_ENHANCED = 19;

    (* MM_COREDYNAMICS product IDs *)
    MM_COREDYNAMICS_DYNAMIXHR = 1; (* DynaMax Hi-Rez *)
    MM_COREDYNAMICS_DYNASONIX_SYNTH = 2; (* DynaSonix *)
    MM_COREDYNAMICS_DYNASONIX_MIDI_IN = 3;
    MM_COREDYNAMICS_DYNASONIX_MIDI_OUT = 4;
    MM_COREDYNAMICS_DYNASONIX_WAVE_IN = 5;
    MM_COREDYNAMICS_DYNASONIX_WAVE_OUT = 6;
    MM_COREDYNAMICS_DYNASONIX_AUDIO_IN = 7;
    MM_COREDYNAMICS_DYNASONIX_AUDIO_OUT = 8;
    MM_COREDYNAMICS_DYNAGRAFX_VGA = 9; (* DynaGrfx *)
    MM_COREDYNAMICS_DYNAGRAFX_WAVE_IN = 10;
    MM_COREDYNAMICS_DYNAGRAFX_WAVE_OUT = 11;

    (* MM_CANAM product IDs *)
    MM_CANAM_CBXWAVEOUT = 1;
    MM_CANAM_CBXWAVEIN = 2;

    (* MM_SOFTSOUND product IDs *)
    MM_SOFTSOUND_CODEC = 1;

    (* MM_NORRIS product IDs *)
    MM_NORRIS_VOICELINK = 1;

    (* MM_DDD product IDs *)
    MM_DDD_MIDILINK_MIDIIN = 1;
    MM_DDD_MIDILINK_MIDIOUT = 2;

    (* MM_EUPHONICS product IDs *)
    MM_EUPHONICS_AUX_CD = 1;
    MM_EUPHONICS_AUX_LINE = 2;
    MM_EUPHONICS_AUX_MASTER = 3;
    MM_EUPHONICS_AUX_MIC = 4;
    MM_EUPHONICS_AUX_MIDI = 5;
    MM_EUPHONICS_AUX_WAVE = 6;
    MM_EUPHONICS_FMSYNTH_MONO = 7;
    MM_EUPHONICS_FMSYNTH_STEREO = 8;
    MM_EUPHONICS_MIDIIN = 9;
    MM_EUPHONICS_MIDIOUT = 10;
    MM_EUPHONICS_MIXER = 11;
    MM_EUPHONICS_WAVEIN = 12;
    MM_EUPHONICS_WAVEOUT = 13;
    MM_EUPHONICS_EUSYNTH = 14;

    (* MM_CRYSTAL_NET product IDs *)
    CRYSTAL_NET_SFM_CODEC = 1;

    (* MM_CHROMATIC product IDs *)
    MM_CHROMATIC_M1 = $0001;
    MM_CHROMATIC_M1_WAVEIN = $0002;
    MM_CHROMATIC_M1_WAVEOUT = $0003;
    MM_CHROMATIC_M1_FMSYNTH = $0004;
    MM_CHROMATIC_M1_MIXER = $0005;
    MM_CHROMATIC_M1_AUX = $0006;
    MM_CHROMATIC_M1_AUX_CD = $0007;
    MM_CHROMATIC_M1_MIDIIN = $0008;
    MM_CHROMATIC_M1_MIDIOUT = $0009;
    MM_CHROMATIC_M1_WTSYNTH = $0010;
    MM_CHROMATIC_M1_MPEGWAVEIN = $0011;
    MM_CHROMATIC_M1_MPEGWAVEOUT = $0012;
    MM_CHROMATIC_M2 = $0013;
    MM_CHROMATIC_M2_WAVEIN = $0014;
    MM_CHROMATIC_M2_WAVEOUT = $0015;
    MM_CHROMATIC_M2_FMSYNTH = $0016;
    MM_CHROMATIC_M2_MIXER = $0017;
    MM_CHROMATIC_M2_AUX = $0018;
    MM_CHROMATIC_M2_AUX_CD = $0019;
    MM_CHROMATIC_M2_MIDIIN = $0020;
    MM_CHROMATIC_M2_MIDIOUT = $0021;
    MM_CHROMATIC_M2_WTSYNTH = $0022;
    MM_CHROMATIC_M2_MPEGWAVEIN = $0023;
    MM_CHROMATIC_M2_MPEGWAVEOUT = $0024;

    (* MM_VIENNASYS product IDs *)
    MM_VIENNASYS_TSP_WAVE_DRIVER = 1;

    (* MM_CONNECTIX product IDs *)
    MM_CONNECTIX_VIDEC_CODEC = 1;

    (* MM_GADGETLABS product IDs *)
    MM_GADGETLABS_WAVE44_WAVEIN = 1;
    MM_GADGETLABS_WAVE44_WAVEOUT = 2;
    MM_GADGETLABS_WAVE42_WAVEIN = 3;
    MM_GADGETLABS_WAVE42_WAVEOUT = 4;
    MM_GADGETLABS_WAVE4_MIDIIN = 5;
    MM_GADGETLABS_WAVE4_MIDIOUT = 6;

    (* MM_FRONTIER product IDs *)
    MM_FRONTIER_WAVECENTER_MIDIIN = 1; (* WaveCenter *)
    MM_FRONTIER_WAVECENTER_MIDIOUT = 2;
    MM_FRONTIER_WAVECENTER_WAVEIN = 3;
    MM_FRONTIER_WAVECENTER_WAVEOUT = 4;

    (* MM_VIONA product IDs *)
    MM_VIONA_QVINPCI_MIXER = 1; (* Q-Motion PCI II/Bravado 2000 *)
    MM_VIONA_QVINPCI_WAVEIN = 2;
    MM_VIONAQVINPCI_WAVEOUT = 3;
    MM_VIONA_BUSTER_MIXER = 4; (* Buster *)
    MM_VIONA_CINEMASTER_MIXER = 5; (* Cinemaster *)
    MM_VIONA_CONCERTO_MIXER = 6; (* Concerto *)

    (* MM_CASIO product IDs *)
    MM_CASIO_WP150_MIDIOUT = 1; (* wp150 *)
    MM_CASIO_WP150_MIDIIN = 2;
    MM_CASIO_LSG_MIDIOUT = 3;

    (* MM_DIAMONDMM product IDs *)
    MM_DIMD_PLATFORM = 0; (* Freedom Audio *)
    MM_DIMD_DIRSOUND = 1;
    MM_DIMD_VIRTMPU = 2;
    MM_DIMD_VIRTSB = 3;
    MM_DIMD_VIRTJOY = 4;
    MM_DIMD_WAVEIN = 5;
    MM_DIMD_WAVEOUT = 6;
    MM_DIMD_MIDIIN = 7;
    MM_DIMD_MIDIOUT = 8;
    MM_DIMD_AUX_LINE = 9;
    MM_DIMD_MIXER = 10;
    MM_DIMD_WSS_WAVEIN = 14;
    MM_DIMD_WSS_WAVEOUT = 15;
    MM_DIMD_WSS_MIXER = 17;
    MM_DIMD_WSS_AUX = 21;
    MM_DIMD_WSS_SYNTH = 76;

    (* MM_S3 product IDs *)
    MM_S3_WAVEOUT = 1;
    MM_S3_WAVEIN = 2;
    MM_S3_MIDIOUT = 3;
    MM_S3_MIDIIN = 4;
    MM_S3_FMSYNTH = 5;
    MM_S3_MIXER = 6;
    MM_S3_AUX = 7;

    (* MM_VANKOEVERING product IDs *)
    MM_VKC_MPU401_MIDIIN = $0100;
    MM_VKC_SERIAL_MIDIIN = $0101;
    MM_VKC_MPU401_MIDIOUT = $0200;
    MM_VKC_SERIAL_MIDIOUT = $0201;

    (* MM_ZEFIRO product IDs *)
    MM_ZEFIRO_ZA2 = 2;

    (* MM_FRAUNHOFER_IIS product IDs *)
    MM_FHGIIS_MPEGLAYER3_DECODE = 9;
    MM_FHGIIS_MPEGLAYER3 = 10;
    MM_FHGIIS_MPEGLAYER3_LITE = 10;
    MM_FHGIIS_MPEGLAYER3_BASIC = 11;
    MM_FHGIIS_MPEGLAYER3_ADVANCED = 12;
    MM_FHGIIS_MPEGLAYER3_PROFESSIONAL = 13;
    MM_FHGIIS_MPEGLAYER3_ADVANCEDPLUS = 14;


    (* MM_QUICKNET product IDs *)
    MM_QUICKNET_PJWAVEIN = 1;
    MM_QUICKNET_PJWAVEOUT = 2;

    (* MM_SICRESOURCE product IDs *)
    MM_SICRESOURCE_SSO3D = 2;
    MM_SICRESOURCE_SSOW3DI = 3;

    (* MM_NEOMAGIC product IDs *)
    MM_NEOMAGIC_SYNTH = 1;
    MM_NEOMAGIC_WAVEOUT = 2;
    MM_NEOMAGIC_WAVEIN = 3;
    MM_NEOMAGIC_MIDIOUT = 4;
    MM_NEOMAGIC_MIDIIN = 5;
    MM_NEOMAGIC_AUX = 6;
    MM_NEOMAGIC_MW3DX_WAVEOUT = 10;
    MM_NEOMAGIC_MW3DX_WAVEIN = 11;
    MM_NEOMAGIC_MW3DX_MIDIOUT = 12;
    MM_NEOMAGIC_MW3DX_MIDIIN = 13;
    MM_NEOMAGIC_MW3DX_FMSYNTH = 14;
    MM_NEOMAGIC_MW3DX_GMSYNTH = 15;
    MM_NEOMAGIC_MW3DX_MIXER = 16;
    MM_NEOMAGIC_MW3DX_AUX = 17;
    MM_NEOMAGIC_MWAVE_WAVEOUT = 20;
    MM_NEOMAGIC_MWAVE_WAVEIN = 21;
    MM_NEOMAGIC_MWAVE_MIDIOUT = 22;
    MM_NEOMAGIC_MWAVE_MIDIIN = 23;
    MM_NEOMAGIC_MWAVE_MIXER = 24;
    MM_NEOMAGIC_MWAVE_AUX = 25;

    (* MM_MERGING_TECHNOLOGIES product IDs *)
    MM_MERGING_MPEGL3 = 1;

    (* MM_XIRLINK product IDs *)
    MM_XIRLINK_VISIONLINK = 1;

    (* MM_OTI product IDs *)
    MM_OTI_611WAVEIN = 5;
    MM_OTI_611WAVEOUT = 6;
    MM_OTI_611MIXER = 7;
    MM_OTI_611MIDIN = $12;
    MM_OTI_611MIDIOUT = $13;

    (* MM_AUREAL product IDs *)
    MM_AUREAL_AU8820 = 16;
    MM_AU8820_SYNTH = 17;
    MM_AU8820_WAVEOUT = 18;
    MM_AU8820_WAVEIN = 19;
    MM_AU8820_MIXER = 20;
    MM_AU8820_AUX = 21;
    MM_AU8820_MIDIOUT = 22;
    MM_AU8820_MIDIIN = 23;
    MM_AUREAL_AU8830 = 32;
    MM_AU8830_SYNTH = 33;
    MM_AU8830_WAVEOUT = 34;
    MM_AU8830_WAVEIN = 35;
    MM_AU8830_MIXER = 36;
    MM_AU8830_AUX = 37;
    MM_AU8830_MIDIOUT = 38;
    MM_AU8830_MIDIIN = 39;

    (* MM_VIVO product IDs *)
    MM_VIVO_AUDIO_CODEC = 1;

    (* MM_SHARP product IDs *)
    MM_SHARP_MDC_MIDI_SYNTH = 1;
    MM_SHARP_MDC_MIDI_IN = 2;
    MM_SHARP_MDC_MIDI_OUT = 3;
    MM_SHARP_MDC_WAVE_IN = 4;
    MM_SHARP_MDC_WAVE_OUT = 5;
    MM_SHARP_MDC_AUX = 6;
    MM_SHARP_MDC_MIXER = 10;
    MM_SHARP_MDC_AUX_MASTER = 100;
    MM_SHARP_MDC_AUX_BASS = 101;
    MM_SHARP_MDC_AUX_TREBLE = 102;
    MM_SHARP_MDC_AUX_MIDI_VOL = 103;
    MM_SHARP_MDC_AUX_WAVE_VOL = 104;
    MM_SHARP_MDC_AUX_WAVE_RVB = 105;
    MM_SHARP_MDC_AUX_WAVE_CHR = 106;
    MM_SHARP_MDC_AUX_VOL = 107;
    MM_SHARP_MDC_AUX_RVB = 108;
    MM_SHARP_MDC_AUX_CHR = 109;

    (* MM_LUCENT product IDs *)
    MM_LUCENT_ACM_G723 = 0;

    (* MM_ATT product IDs *)
    MM_ATT_G729A = 1;

    (* MM_MARIAN product IDs *)
    MM_MARIAN_ARC44WAVEIN = 1;
    MM_MARIAN_ARC44WAVEOUT = 2;
    MM_MARIAN_PRODIF24WAVEIN = 3;
    MM_MARIAN_PRODIF24WAVEOUT = 4;
    MM_MARIAN_ARC88WAVEIN = 5;
    MM_MARIAN_ARC88WAVEOUT = 6;

    (* MM_BCB product IDs *)
    MM_BCB_NETBOARD_10 = 1;
    MM_BCB_TT75_10 = 2;

    (* MM_MOTIONPIXELS product IDs *)
    MM_MOTIONPIXELS_MVI2 = 1;

    (* MM_QDESIGN product IDs *)
    MM_QDESIGN_ACM_MPEG = 1;
    MM_QDESIGN_ACM_QDESIGN_MUSIC = 2;

    (* MM_NMP product IDs *)
    MM_NMP_CCP_WAVEIN = 1;
    MM_NMP_CCP_WAVEOUT = 2;
    MM_NMP_ACM_AMR = 10;

    (* MM_DATAFUSION product IDs *)
    MM_DF_ACM_G726 = 1;
    MM_DF_ACM_GSM610 = 2;

    (* MM_BERCOS product IDs *)
    MM_BERCOS_WAVEIN = 1;
    MM_BERCOS_MIXER = 2;
    MM_BERCOS_WAVEOUT = 3;

    (* MM_ONLIVE product IDs *)
    MM_ONLIVE_MPCODEC = 1;

    (* MM_PHONET product IDs *)
    MM_PHONET_PP_WAVEOUT = 1;
    MM_PHONET_PP_WAVEIN = 2;
    MM_PHONET_PP_MIXER = 3;

    (* MM_FTR product IDs *)
    MM_FTR_ENCODER_WAVEIN = 1;
    MM_FTR_ACM = 2;

    (* MM_ENET product IDs *)
    MM_ENET_T2000_LINEIN = 1;
    MM_ENET_T2000_LINEOUT = 2;
    MM_ENET_T2000_HANDSETIN = 3;
    MM_ENET_T2000_HANDSETOUT = 4;

    (*  MM_EMAGIC product IDs *)
    MM_EMAGIC_UNITOR8 = 1;

    (*  MM_SIPROLAB product IDs *)
    MM_SIPROLAB_ACELPNET = 1;

    (*  MM_DICTAPHONE product IDs *)
    MM_DICTAPHONE_G726 = 1; (* G726 ACM codec (g726pcm.acm) *)

    (*  MM_RZS product IDs *)
    MM_RZS_ACM_TUBGSM = 1; (* GSM 06.10 CODEC *)

    (*  MM_EES product IDs *)
    MM_EES_PCMIDI14 = 1;
    MM_EES_PCMIDI14_IN = 2;
    MM_EES_PCMIDI14_OUT1 = 3;
    MM_EES_PCMIDI14_OUT2 = 4;
    MM_EES_PCMIDI14_OUT3 = 5;
    MM_EES_PCMIDI14_OUT4 = 6;

    (*  MM_HAFTMANN product IDs *)
    MM_HAFTMANN_LPTDAC2 = 1;

    (*  MM_LUCID product IDs *)
    MM_LUCID_PCI24WAVEIN = 1;
    MM_LUCID_PCI24WAVEOUT = 2;

    (*  MM_HEADSPACE product IDs *)
    MM_HEADSPACE_HAESYNTH = 1;
    MM_HEADSPACE_HAEWAVEOUT = 2;
    MM_HEADSPACE_HAEWAVEIN = 3;
    MM_HEADSPACE_HAEMIXER = 4;

    (*  MM_UNISYS product IDs *)
    MM_UNISYS_ACM_NAP = 1;

    (*  MM_LUMINOSITI product IDs *)

    MM_LUMINOSITI_SCWAVEIN = 1;
    MM_LUMINOSITI_SCWAVEOUT = 2;
    MM_LUMINOSITI_SCWAVEMIX = 3;

    (*  MM_ACTIVEVOICE product IDs *)
    MM_ACTIVEVOICE_ACM_VOXADPCM = 1;

    (*  MM_DTS product IDs *)
    MM_DTS_DS = 1;

    (*  MM_SOFTLAB_NSK product IDs *)
    MM_SOFTLAB_NSK_FRW_WAVEIN = 1;
    MM_SOFTLAB_NSK_FRW_WAVEOUT = 2;
    MM_SOFTLAB_NSK_FRW_MIXER = 3;
    MM_SOFTLAB_NSK_FRW_AUX = 4;

    (*  MM_FORTEMEDIA product IDs *)
    MM_FORTEMEDIA_WAVEIN = 1;
    MM_FORTEMEDIA_WAVEOUT = 2;
    MM_FORTEMEDIA_FMSYNC = 3;
    MM_FORTEMEDIA_MIXER = 4;
    MM_FORTEMEDIA_AUX = 5;

    (*  MM_SONORUS product IDs *)
    MM_SONORUS_STUDIO = 1;

    (*  MM_I_LINK product IDs *)
    MM_I_LINK_VOICE_CODER = 1;

    (*  MM_SELSIUS_SYSTEMS product IDs *)
    MM_SELSIUS_SYSTEMS_RTPWAVEOUT = 1;
    MM_SELSIUS_SYSTEMS_RTPWAVEIN = 2;

    (*  MM_ADMOS product IDs *)
    MM_ADMOS_FM_SYNTH = 1;
    MM_ADMOS_QS3AMIDIOUT = 2;
    MM_ADMOS_QS3AMIDIIN = 3;
    MM_ADMOS_QS3AWAVEOUT = 4;
    MM_ADMOS_QS3AWAVEIN = 5;

    (* MM_LEXICON product IDs *)
    MM_LEXICON_STUDIO_WAVE_OUT = 1;
    MM_LEXICON_STUDIO_WAVE_IN = 2;

    (* MM_SGI product IDs *)
    MM_SGI_320_WAVEIN = 1;
    MM_SGI_320_WAVEOUT = 2;
    MM_SGI_320_MIXER = 3;
    MM_SGI_540_WAVEIN = 4;
    MM_SGI_540_WAVEOUT = 5;
    MM_SGI_540_MIXER = 6;
    MM_SGI_RAD_ADATMONO1_WAVEIN = 7;
    MM_SGI_RAD_ADATMONO2_WAVEIN = 8;
    MM_SGI_RAD_ADATMONO3_WAVEIN = 9;
    MM_SGI_RAD_ADATMONO4_WAVEIN = 10;
    MM_SGI_RAD_ADATMONO5_WAVEIN = 11;
    MM_SGI_RAD_ADATMONO6_WAVEIN = 12;
    MM_SGI_RAD_ADATMONO7_WAVEIN = 13;
    MM_SGI_RAD_ADATMONO8_WAVEIN = 14;
    MM_SGI_RAD_ADATSTEREO12_WAVEIN = 15;
    MM_SGI_RAD_ADATSTEREO34_WAVEIN = 16;
    MM_SGI_RAD_ADATSTEREO56_WAVEIN = 17;
    MM_SGI_RAD_ADATSTEREO78_WAVEIN = 18;
    MM_SGI_RAD_ADAT8CHAN_WAVEIN = 19;
    MM_SGI_RAD_ADATMONO1_WAVEOUT = 20;
    MM_SGI_RAD_ADATMONO2_WAVEOUT = 21;
    MM_SGI_RAD_ADATMONO3_WAVEOUT = 22;
    MM_SGI_RAD_ADATMONO4_WAVEOUT = 23;
    MM_SGI_RAD_ADATMONO5_WAVEOUT = 24;
    MM_SGI_RAD_ADATMONO6_WAVEOUT = 25;
    MM_SGI_RAD_ADATMONO7_WAVEOUT = 26;
    MM_SGI_RAD_ADATMONO8_WAVEOUT = 27;
    MM_SGI_RAD_ADATSTEREO12_WAVEOUT = 28;
    MM_SGI_RAD_ADATSTEREO32_WAVEOUT = 29;
    MM_SGI_RAD_ADATSTEREO56_WAVEOUT = 30;
    MM_SGI_RAD_ADATSTEREO78_WAVEOUT = 31;
    MM_SGI_RAD_ADAT8CHAN_WAVEOUT = 32;
    MM_SGI_RAD_AESMONO1_WAVEIN = 33;
    MM_SGI_RAD_AESMONO2_WAVEIN = 34;
    MM_SGI_RAD_AESSTEREO_WAVEIN = 35;
    MM_SGI_RAD_AESMONO1_WAVEOUT = 36;
    MM_SGI_RAD_AESMONO2_WAVEOUT = 37;
    MM_SGI_RAD_AESSTEREO_WAVEOUT = 38;

    (* MM_IPI product IDs *)
    MM_IPI_ACM_HSX = 1;
    MM_IPI_ACM_RPELP = 2;
    MM_IPI_WF_ASSS = 3;
    MM_IPI_AT_WAVEOUT = 4;
    MM_IPI_AT_WAVEIN = 5;
    MM_IPI_AT_MIXER = 6;

    (* MM_ICE product IDs *)
    MM_ICE_WAVEOUT = 1;
    MM_ICE_WAVEIN = 2;
    MM_ICE_MTWAVEOUT = 3;
    MM_ICE_MTWAVEIN = 4;
    MM_ICE_MIDIOUT1 = 5;
    MM_ICE_MIDIIN1 = 6;
    MM_ICE_MIDIOUT2 = 7;
    MM_ICE_MIDIIN2 = 8;
    MM_ICE_SYNTH = 9;
    MM_ICE_MIXER = 10;
    MM_ICE_AUX = 11;

    (* MM_VQST product IDs *)
    MM_VQST_VQC1 = 1;
    MM_VQST_VQC2 = 2;

    (* MM_ETEK product IDs *)
    MM_ETEK_KWIKMIDI_MIDIIN = 1;
    MM_ETEK_KWIKMIDI_MIDIOUT = 2;

    (* MM_INTERNET product IDs *)
    MM_INTERNET_SSW_MIDIOUT = 10;
    MM_INTERNET_SSW_MIDIIN = 11;
    MM_INTERNET_SSW_WAVEOUT = 12;
    MM_INTERNET_SSW_WAVEIN = 13;

    (* MM_SONY product IDs *)
    MM_SONY_ACM_SCX = 1;

    (* MM_UHER_INFORMATIC product IDs *)
    MM_UH_ACM_ADPCM = 1;

    (* MM_SYDEC_NV product IDs *)
    MM_SYDEC_NV_WAVEIN = 1;
    MM_SYDEC_NV_WAVEOUT = 2;

    (* MM_FLEXION product IDs *)
    MM_FLEXION_X300_WAVEIN = 1;
    MM_FLEXION_X300_WAVEOUT = 2;

    (* MM_VIA product IDs *)
    MM_VIA_WAVEOUT = 1;
    MM_VIA_WAVEIN = 2;
    MM_VIA_MIXER = 3;
    MM_VIA_AUX = 4;
    MM_VIA_MPU401_MIDIOUT = 5;
    MM_VIA_MPU401_MIDIIN = 6;
    MM_VIA_SWFM_SYNTH = 7;
    MM_VIA_WDM_WAVEOUT = 8;
    MM_VIA_WDM_WAVEIN = 9;
    MM_VIA_WDM_MIXER = 10;
    MM_VIA_WDM_MPU401_MIDIOUT = 11;
    MM_VIA_WDM_MPU401_MIDIIN = 12;

    (* MM_MICRONAS product IDs *)
    MM_MICRONAS_SC4 = 1;
    MM_MICRONAS_CLP833 = 2;

    (* MM_HP product IDs *)
    MM_HP_WAVEOUT = 1;
    MM_HP_WAVEIN = 2;

    (* MM_QUICKAUDIO product IDs *)
    MM_QUICKAUDIO_MINIMIDI = 1;
    MM_QUICKAUDIO_MAXIMIDI = 2;

    (* MM_ICCC product IDs *)
    MM_ICCC_UNA3_WAVEIN = 1;
    MM_ICCC_UNA3_WAVEOUT = 2;
    MM_ICCC_UNA3_AUX = 3;
    MM_ICCC_UNA3_MIXER = 4;

    (* MM_3COM product IDs *)
    MM_3COM_CB_MIXER = 1;
    MM_3COM_CB_WAVEIN = 2;
    MM_3COM_CB_WAVEOUT = 3;

    (* MM_MINDMAKER product IDs *)
    MM_MINDMAKER_GC_WAVEIN = 1;
    MM_MINDMAKER_GC_WAVEOUT = 2;
    MM_MINDMAKER_GC_MIXER = 3;

    (* MM_TELEKOL product IDs *)
    MM_TELEKOL_WAVEOUT = 1;
    MM_TELEKOL_WAVEIN = 2;

    (* MM_ALGOVISION product IDs *)
    MM_ALGOVISION_VB80WAVEOUT = 1;
    MM_ALGOVISION_VB80WAVEIN = 2;
    MM_ALGOVISION_VB80MIXER = 3;
    MM_ALGOVISION_VB80AUX = 4;
    MM_ALGOVISION_VB80AUX2 = 5;


    (* ------------------------------------------------------------------------------ *)
(*              INFO LIST CHUNKS (from the Multimedia Programmer's Reference
                                        plus new ones)
*)

    RIFFINFO_IARL = (Ord('I') or (Ord('A') shl 8) or (Ord('R') shl 16) or (Ord('L') shl 24)); (*Archival location  *)
    RIFFINFO_IART = (Ord('I') or (Ord('A') shl 8) or (Ord('R') shl 16) or (Ord('T') shl 24)); (*Artist  *)
    RIFFINFO_ICMS = (Ord('I') or (Ord('C') shl 8) or (Ord('M') shl 16) or (Ord('S') shl 24)); (*Commissioned  *)
    RIFFINFO_ICMT = (Ord('I') or (Ord('C') shl 8) or (Ord('M') shl 16) or (Ord('T') shl 24)); (*Comments  *)
    RIFFINFO_ICOP = (Ord('I') or (Ord('C') shl 8) or (Ord('O') shl 16) or (Ord('P') shl 24)); (*Copyright  *)
    RIFFINFO_ICRD = (Ord('I') or (Ord('C') shl 8) or (Ord('R') shl 16) or (Ord('D') shl 24)); (*Creation date of subject  *)
    RIFFINFO_ICRP = (Ord('I') or (Ord('C') shl 8) or (Ord('R') shl 16) or (Ord('P') shl 24)); (*Cropped  *)
    RIFFINFO_IDIM = (Ord('I') or (Ord('D') shl 8) or (Ord('I') shl 16) or (Ord('M') shl 24)); (*Dimensions  *)
    RIFFINFO_IDPI = (Ord('I') or (Ord('D') shl 8) or (Ord('P') shl 16) or (Ord('I') shl 24)); (*Dots per inch  *)
    RIFFINFO_IENG = (Ord('I') or (Ord('E') shl 8) or (Ord('N') shl 16) or (Ord('G') shl 24)); (*Engineer  *)
    RIFFINFO_IGNR = (Ord('I') or (Ord('G') shl 8) or (Ord('N') shl 16) or (Ord('R') shl 24)); (*Genre  *)
    RIFFINFO_IKEY = (Ord('I') or (Ord('K') shl 8) or (Ord('E') shl 16) or (Ord('Y') shl 24)); (*Keywords  *)
    RIFFINFO_ILGT = (Ord('I') or (Ord('L') shl 8) or (Ord('G') shl 16) or (Ord('T') shl 24)); (*Lightness settings  *)
    RIFFINFO_IMED = (Ord('I') or (Ord('M') shl 8) or (Ord('E') shl 16) or (Ord('D') shl 24)); (*Medium  *)
    RIFFINFO_INAM = (Ord('I') or (Ord('N') shl 8) or (Ord('A') shl 16) or (Ord('M') shl 24)); (*Name of subject  *)
    RIFFINFO_IPLT = (Ord('I') or (Ord('P') shl 8) or (Ord('L') shl 16) or (Ord('T') shl 24)); (*Palette Settings. No. of colors requested.   *)
    RIFFINFO_IPRD = (Ord('I') or (Ord('P') shl 8) or (Ord('R') shl 16) or (Ord('D') shl 24)); (*Product  *)
    RIFFINFO_ISBJ = (Ord('I') or (Ord('S') shl 8) or (Ord('B') shl 16) or (Ord('J') shl 24)); (*Subject description  *)
    RIFFINFO_ISFT = (Ord('I') or (Ord('S') shl 8) or (Ord('F') shl 16) or (Ord('T') shl 24)); (*Software. Name of package used to create file.  *)
    RIFFINFO_ISHP = (Ord('I') or (Ord('S') shl 8) or (Ord('H') shl 16) or (Ord('P') shl 24)); (*Sharpness.  *)
    RIFFINFO_ISRC = (Ord('I') or (Ord('S') shl 8) or (Ord('R') shl 16) or (Ord('C') shl 24)); (*Source.   *)
    RIFFINFO_ISRF = (Ord('I') or (Ord('S') shl 8) or (Ord('R') shl 16) or (Ord('F') shl 24)); (*Source Form. ie slide, paper  *)
    RIFFINFO_ITCH = (Ord('I') or (Ord('T') shl 8) or (Ord('C') shl 16) or (Ord('H') shl 24)); (*Technician who digitized the subject.  *)

    (* New INFO Chunks as of August 30, 1993: *)
    RIFFINFO_ISMP = (Ord('I') or (Ord('S') shl 8) or (Ord('M') shl 16) or (Ord('P') shl 24)); (*SMPTE time code  *)
(* ISMP: SMPTE time code of digitization start point expressed as a NULL terminated
                text string "HH:MM:SS:FF". If performing MCI capture in AVICAP, this
                chunk will be automatically set based on the MCI start time.
*)
    RIFFINFO_IDIT = (Ord('I') or (Ord('D') shl 8) or (Ord('I') shl 16) or (Ord('T') shl 24)); (*Digitization Time  *)
(* IDIT: "Digitization Time" Specifies the time and date that the digitization commenced.
                The digitization time is contained in an ASCII string which
                contains exactly 26 characters and is in the format
                "Wed Jan 02 02:03:55 1990\n\0".
                The ctime(), asctime(), functions can be used to create strings
                in this format. This chunk is automatically added to the capture
                file based on the current system time at the moment capture is initiated.
*)

    RIFFINFO_ITRK = (Ord('I') or (Ord('T') shl 8) or (Ord('R') shl 16) or (Ord('K') shl 24)); (*ASCIIZ representation of the 1-based track number of the content.  *)
    RIFFINFO_ITOC = (Ord('I') or (Ord('T') shl 8) or (Ord('O') shl 16) or (Ord('C') shl 24)); (*A dump of the table of contents from the CD the content originated from.  *)

    (*Template line for new additions*)
    (*#define RIFFINFO_I      MAKEFOURCC('I', '', '', '')        *)
    (* ------------------------------------------------------------------------------ *)


    (* WAVE form wFormatTag IDs *)
    WAVE_FORMAT_UNKNOWN = $0000; (* Microsoft Corporation *)
    WAVE_FORMAT_ADPCM = $0002; (* Microsoft Corporation *)
    WAVE_FORMAT_IEEE_FLOAT = $0003; (* Microsoft Corporation *)
    WAVE_FORMAT_VSELP = $0004; (* Compaq Computer Corp. *)
    WAVE_FORMAT_IBM_CVSD = $0005; (* IBM Corporation *)
    WAVE_FORMAT_ALAW = $0006; (* Microsoft Corporation *)
    WAVE_FORMAT_MULAW = $0007; (* Microsoft Corporation *)
    WAVE_FORMAT_DTS = $0008; (* Microsoft Corporation *)
    WAVE_FORMAT_DRM = $0009; (* Microsoft Corporation *)
    WAVE_FORMAT_WMAVOICE9 = $000A; (* Microsoft Corporation *)
    WAVE_FORMAT_WMAVOICE10 = $000B; (* Microsoft Corporation *)
    WAVE_FORMAT_OKI_ADPCM = $0010; (* OKI *)
    WAVE_FORMAT_DVI_ADPCM = $0011; (* Intel Corporation *)
    WAVE_FORMAT_IMA_ADPCM = (WAVE_FORMAT_DVI_ADPCM); (*  Intel Corporation *)
    WAVE_FORMAT_MEDIASPACE_ADPCM = $0012; (* Videologic *)
    WAVE_FORMAT_SIERRA_ADPCM = $0013; (* Sierra Semiconductor Corp *)
    WAVE_FORMAT_G723_ADPCM = $0014; (* Antex Electronics Corporation *)
    WAVE_FORMAT_DIGISTD = $0015; (* DSP Solutions, Inc. *)
    WAVE_FORMAT_DIGIFIX = $0016; (* DSP Solutions, Inc. *)
    WAVE_FORMAT_DIALOGIC_OKI_ADPCM = $0017; (* Dialogic Corporation *)
    WAVE_FORMAT_MEDIAVISION_ADPCM = $0018; (* Media Vision, Inc. *)
    WAVE_FORMAT_CU_CODEC = $0019; (* Hewlett-Packard Company *)
    WAVE_FORMAT_HP_DYN_VOICE = $001A; (* Hewlett-Packard Company *)
    WAVE_FORMAT_YAMAHA_ADPCM = $0020; (* Yamaha Corporation of America *)
    WAVE_FORMAT_SONARC = $0021; (* Speech Compression *)
    WAVE_FORMAT_DSPGROUP_TRUESPEECH = $0022; (* DSP Group, Inc *)
    WAVE_FORMAT_ECHOSC1 = $0023; (* Echo Speech Corporation *)
    WAVE_FORMAT_AUDIOFILE_AF36 = $0024; (* Virtual Music, Inc. *)
    WAVE_FORMAT_APTX = $0025; (* Audio Processing Technology *)
    WAVE_FORMAT_AUDIOFILE_AF10 = $0026; (* Virtual Music, Inc. *)
    WAVE_FORMAT_PROSODY_1612 = $0027; (* Aculab plc *)
    WAVE_FORMAT_LRC = $0028; (* Merging Technologies S.A. *)
    WAVE_FORMAT_DOLBY_AC2 = $0030; (* Dolby Laboratories *)
    WAVE_FORMAT_GSM610 = $0031; (* Microsoft Corporation *)
    WAVE_FORMAT_MSNAUDIO = $0032; (* Microsoft Corporation *)
    WAVE_FORMAT_ANTEX_ADPCME = $0033; (* Antex Electronics Corporation *)
    WAVE_FORMAT_CONTROL_RES_VQLPC = $0034; (* Control Resources Limited *)
    WAVE_FORMAT_DIGIREAL = $0035; (* DSP Solutions, Inc. *)
    WAVE_FORMAT_DIGIADPCM = $0036; (* DSP Solutions, Inc. *)
    WAVE_FORMAT_CONTROL_RES_CR10 = $0037; (* Control Resources Limited *)
    WAVE_FORMAT_NMS_VBXADPCM = $0038; (* Natural MicroSystems *)
    WAVE_FORMAT_CS_IMAADPCM = $0039; (* Crystal Semiconductor IMA ADPCM *)
    WAVE_FORMAT_ECHOSC3 = $003A; (* Echo Speech Corporation *)
    WAVE_FORMAT_ROCKWELL_ADPCM = $003B; (* Rockwell International *)
    WAVE_FORMAT_ROCKWELL_DIGITALK = $003C; (* Rockwell International *)
    WAVE_FORMAT_XEBEC = $003D; (* Xebec Multimedia Solutions Limited *)
    WAVE_FORMAT_G721_ADPCM = $0040; (* Antex Electronics Corporation *)
    WAVE_FORMAT_G728_CELP = $0041; (* Antex Electronics Corporation *)
    WAVE_FORMAT_MSG723 = $0042; (* Microsoft Corporation *)
    WAVE_FORMAT_INTEL_G723_1 = $0043; (* Intel Corp. *)
    WAVE_FORMAT_INTEL_G729 = $0044; (* Intel Corp. *)
    WAVE_FORMAT_SHARP_G726 = $0045; (* Sharp *)
    WAVE_FORMAT_MPEG = $0050; (* Microsoft Corporation *)
    WAVE_FORMAT_RT24 = $0052; (* InSoft, Inc. *)
    WAVE_FORMAT_PAC = $0053; (* InSoft, Inc. *)
    WAVE_FORMAT_MPEGLAYER3 = $0055; (* ISO/MPEG Layer3 Format Tag *)
    WAVE_FORMAT_LUCENT_G723 = $0059; (* Lucent Technologies *)
    WAVE_FORMAT_CIRRUS = $0060; (* Cirrus Logic *)
    WAVE_FORMAT_ESPCM = $0061; (* ESS Technology *)
    WAVE_FORMAT_VOXWARE = $0062; (* Voxware Inc *)
    WAVE_FORMAT_CANOPUS_ATRAC = $0063; (* Canopus, co., Ltd. *)
    WAVE_FORMAT_G726_ADPCM = $0064; (* APICOM *)
    WAVE_FORMAT_G722_ADPCM = $0065; (* APICOM *)
    WAVE_FORMAT_DSAT = $0066; (* Microsoft Corporation *)
    WAVE_FORMAT_DSAT_DISPLAY = $0067; (* Microsoft Corporation *)
    WAVE_FORMAT_VOXWARE_BYTE_ALIGNED = $0069; (* Voxware Inc *)
    WAVE_FORMAT_VOXWARE_AC8 = $0070; (* Voxware Inc *)
    WAVE_FORMAT_VOXWARE_AC10 = $0071; (* Voxware Inc *)
    WAVE_FORMAT_VOXWARE_AC16 = $0072; (* Voxware Inc *)
    WAVE_FORMAT_VOXWARE_AC20 = $0073; (* Voxware Inc *)
    WAVE_FORMAT_VOXWARE_RT24 = $0074; (* Voxware Inc *)
    WAVE_FORMAT_VOXWARE_RT29 = $0075; (* Voxware Inc *)
    WAVE_FORMAT_VOXWARE_RT29HW = $0076; (* Voxware Inc *)
    WAVE_FORMAT_VOXWARE_VR12 = $0077; (* Voxware Inc *)
    WAVE_FORMAT_VOXWARE_VR18 = $0078; (* Voxware Inc *)
    WAVE_FORMAT_VOXWARE_TQ40 = $0079; (* Voxware Inc *)
    WAVE_FORMAT_VOXWARE_SC3 = $007A; (* Voxware Inc *)
    WAVE_FORMAT_VOXWARE_SC3_1 = $007B; (* Voxware Inc *)
    WAVE_FORMAT_SOFTSOUND = $0080; (* Softsound, Ltd. *)
    WAVE_FORMAT_VOXWARE_TQ60 = $0081; (* Voxware Inc *)
    WAVE_FORMAT_MSRT24 = $0082; (* Microsoft Corporation *)
    WAVE_FORMAT_G729A = $0083; (* AT&T Labs, Inc. *)
    WAVE_FORMAT_MVI_MVI2 = $0084; (* Motion Pixels *)
    WAVE_FORMAT_DF_G726 = $0085; (* DataFusion Systems (Pty) (Ltd) *)
    WAVE_FORMAT_DF_GSM610 = $0086; (* DataFusion Systems (Pty) (Ltd) *)
    WAVE_FORMAT_ISIAUDIO = $0088; (* Iterated Systems, Inc. *)
    WAVE_FORMAT_ONLIVE = $0089; (* OnLive! Technologies, Inc. *)
    WAVE_FORMAT_MULTITUDE_FT_SX20 = $008A; (* Multitude Inc. *)
    WAVE_FORMAT_INFOCOM_ITS_G721_ADPCM = $008B; (* Infocom *)
    WAVE_FORMAT_CONVEDIA_G729 = $008C; (* Convedia Corp. *)
    WAVE_FORMAT_CONGRUENCY = $008D; (* Congruency Inc. *)
    WAVE_FORMAT_SBC24 = $0091; (* Siemens Business Communications Sys *)
    WAVE_FORMAT_DOLBY_AC3_SPDIF = $0092; (* Sonic Foundry *)
    WAVE_FORMAT_MEDIASONIC_G723 = $0093; (* MediaSonic *)
    WAVE_FORMAT_PROSODY_8KBPS = $0094; (* Aculab plc *)
    WAVE_FORMAT_ZYXEL_ADPCM = $0097; (* ZyXEL Communications, Inc. *)
    WAVE_FORMAT_PHILIPS_LPCBB = $0098; (* Philips Speech Processing *)
    WAVE_FORMAT_PACKED = $0099; (* Studer Professional Audio AG *)
    WAVE_FORMAT_MALDEN_PHONYTALK = $00A0; (* Malden Electronics Ltd. *)
    WAVE_FORMAT_RACAL_RECORDER_GSM = $00A1; (* Racal recorders *)
    WAVE_FORMAT_RACAL_RECORDER_G720_A = $00A2; (* Racal recorders *)
    WAVE_FORMAT_RACAL_RECORDER_G723_1 = $00A3; (* Racal recorders *)
    WAVE_FORMAT_RACAL_RECORDER_TETRA_ACELP = $00A4; (* Racal recorders *)
    WAVE_FORMAT_NEC_AAC = $00B0; (* NEC Corp. *)
    WAVE_FORMAT_RAW_AAC1 = $00FF; (* For Raw AAC, with format block AudioSpecificConfig() (as defined by MPEG-4), that follows WAVEFORMATEX *)
    WAVE_FORMAT_RHETOREX_ADPCM = $0100; (* Rhetorex Inc. *)
    WAVE_FORMAT_IRAT = $0101; (* BeCubed Software Inc. *)
    WAVE_FORMAT_VIVO_G723 = $0111; (* Vivo Software *)
    WAVE_FORMAT_VIVO_SIREN = $0112; (* Vivo Software *)
    WAVE_FORMAT_PHILIPS_CELP = $0120; (* Philips Speech Processing *)
    WAVE_FORMAT_PHILIPS_GRUNDIG = $0121; (* Philips Speech Processing *)
    WAVE_FORMAT_DIGITAL_G723 = $0123; (* Digital Equipment Corporation *)
    WAVE_FORMAT_SANYO_LD_ADPCM = $0125; (* Sanyo Electric Co., Ltd. *)
    WAVE_FORMAT_SIPROLAB_ACEPLNET = $0130; (* Sipro Lab Telecom Inc. *)
    WAVE_FORMAT_SIPROLAB_ACELP4800 = $0131; (* Sipro Lab Telecom Inc. *)
    WAVE_FORMAT_SIPROLAB_ACELP8V3 = $0132; (* Sipro Lab Telecom Inc. *)
    WAVE_FORMAT_SIPROLAB_G729 = $0133; (* Sipro Lab Telecom Inc. *)
    WAVE_FORMAT_SIPROLAB_G729A = $0134; (* Sipro Lab Telecom Inc. *)
    WAVE_FORMAT_SIPROLAB_KELVIN = $0135; (* Sipro Lab Telecom Inc. *)
    WAVE_FORMAT_VOICEAGE_AMR = $0136; (* VoiceAge Corp. *)
    WAVE_FORMAT_G726ADPCM = $0140; (* Dictaphone Corporation *)
    WAVE_FORMAT_DICTAPHONE_CELP68 = $0141; (* Dictaphone Corporation *)
    WAVE_FORMAT_DICTAPHONE_CELP54 = $0142; (* Dictaphone Corporation *)
    WAVE_FORMAT_QUALCOMM_PUREVOICE = $0150; (* Qualcomm, Inc. *)
    WAVE_FORMAT_QUALCOMM_HALFRATE = $0151; (* Qualcomm, Inc. *)
    WAVE_FORMAT_TUBGSM = $0155; (* Ring Zero Systems, Inc. *)
    WAVE_FORMAT_MSAUDIO1 = $0160; (* Microsoft Corporation *)
    WAVE_FORMAT_WMAUDIO2 = $0161; (* Microsoft Corporation *)
    WAVE_FORMAT_WMAUDIO3 = $0162; (* Microsoft Corporation *)
    WAVE_FORMAT_WMAUDIO_LOSSLESS = $0163; (* Microsoft Corporation *)
    WAVE_FORMAT_WMASPDIF = $0164; (* Microsoft Corporation *)
    WAVE_FORMAT_UNISYS_NAP_ADPCM = $0170; (* Unisys Corp. *)
    WAVE_FORMAT_UNISYS_NAP_ULAW = $0171; (* Unisys Corp. *)
    WAVE_FORMAT_UNISYS_NAP_ALAW = $0172; (* Unisys Corp. *)
    WAVE_FORMAT_UNISYS_NAP_16K = $0173; (* Unisys Corp. *)
    WAVE_FORMAT_SYCOM_ACM_SYC008 = $0174; (* SyCom Technologies *)
    WAVE_FORMAT_SYCOM_ACM_SYC701_G726L = $0175; (* SyCom Technologies *)
    WAVE_FORMAT_SYCOM_ACM_SYC701_CELP54 = $0176; (* SyCom Technologies *)
    WAVE_FORMAT_SYCOM_ACM_SYC701_CELP68 = $0177; (* SyCom Technologies *)
    WAVE_FORMAT_KNOWLEDGE_ADVENTURE_ADPCM = $0178; (* Knowledge Adventure, Inc. *)
    WAVE_FORMAT_FRAUNHOFER_IIS_MPEG2_AAC = $0180; (* Fraunhofer IIS *)
    WAVE_FORMAT_DTS_DS = $0190; (* Digital Theatre Systems, Inc. *)
    WAVE_FORMAT_CREATIVE_ADPCM = $0200; (* Creative Labs, Inc *)
    WAVE_FORMAT_CREATIVE_FASTSPEECH8 = $0202; (* Creative Labs, Inc *)
    WAVE_FORMAT_CREATIVE_FASTSPEECH10 = $0203; (* Creative Labs, Inc *)
    WAVE_FORMAT_UHER_ADPCM = $0210; (* UHER informatic GmbH *)
    WAVE_FORMAT_ULEAD_DV_AUDIO = $0215; (* Ulead Systems, Inc. *)
    WAVE_FORMAT_ULEAD_DV_AUDIO_1 = $0216; (* Ulead Systems, Inc. *)
    WAVE_FORMAT_QUARTERDECK = $0220; (* Quarterdeck Corporation *)
    WAVE_FORMAT_ILINK_VC = $0230; (* I-link Worldwide *)
    WAVE_FORMAT_RAW_SPORT = $0240; (* Aureal Semiconductor *)
    WAVE_FORMAT_ESST_AC3 = $0241; (* ESS Technology, Inc. *)
    WAVE_FORMAT_GENERIC_PASSTHRU = $0249;
    WAVE_FORMAT_IPI_HSX = $0250; (* Interactive Products, Inc. *)
    WAVE_FORMAT_IPI_RPELP = $0251; (* Interactive Products, Inc. *)
    WAVE_FORMAT_CS2 = $0260; (* Consistent Software *)
    WAVE_FORMAT_SONY_SCX = $0270; (* Sony Corp. *)
    WAVE_FORMAT_SONY_SCY = $0271; (* Sony Corp. *)
    WAVE_FORMAT_SONY_ATRAC3 = $0272; (* Sony Corp. *)
    WAVE_FORMAT_SONY_SPC = $0273; (* Sony Corp. *)
    WAVE_FORMAT_TELUM_AUDIO = $0280; (* Telum Inc. *)
    WAVE_FORMAT_TELUM_IA_AUDIO = $0281; (* Telum Inc. *)
    WAVE_FORMAT_NORCOM_VOICE_SYSTEMS_ADPCM = $0285; (* Norcom Electronics Corp. *)
    WAVE_FORMAT_FM_TOWNS_SND = $0300; (* Fujitsu Corp. *)
    WAVE_FORMAT_MICRONAS = $0350; (* Micronas Semiconductors, Inc. *)
    WAVE_FORMAT_MICRONAS_CELP833 = $0351; (* Micronas Semiconductors, Inc. *)
    WAVE_FORMAT_BTV_DIGITAL = $0400; (* Brooktree Corporation *)
    WAVE_FORMAT_INTEL_MUSIC_CODER = $0401; (* Intel Corp. *)
    WAVE_FORMAT_INDEO_AUDIO = $0402; (* Ligos *)
    WAVE_FORMAT_QDESIGN_MUSIC = $0450; (* QDesign Corporation *)
    WAVE_FORMAT_ON2_VP7_AUDIO = $0500; (* On2 Technologies *)
    WAVE_FORMAT_ON2_VP6_AUDIO = $0501; (* On2 Technologies *)
    WAVE_FORMAT_VME_VMPCM = $0680; (* AT&T Labs, Inc. *)
    WAVE_FORMAT_TPC = $0681; (* AT&T Labs, Inc. *)
    WAVE_FORMAT_LIGHTWAVE_LOSSLESS = $08AE; (* Clearjump *)
    WAVE_FORMAT_OLIGSM = $1000; (* Ing C. Olivetti & C., S.p.A. *)
    WAVE_FORMAT_OLIADPCM = $1001; (* Ing C. Olivetti & C., S.p.A. *)
    WAVE_FORMAT_OLICELP = $1002; (* Ing C. Olivetti & C., S.p.A. *)
    WAVE_FORMAT_OLISBC = $1003; (* Ing C. Olivetti & C., S.p.A. *)
    WAVE_FORMAT_OLIOPR = $1004; (* Ing C. Olivetti & C., S.p.A. *)
    WAVE_FORMAT_LH_CODEC = $1100; (* Lernout & Hauspie *)
    WAVE_FORMAT_LH_CODEC_CELP = $1101; (* Lernout & Hauspie *)
    WAVE_FORMAT_LH_CODEC_SBC8 = $1102; (* Lernout & Hauspie *)
    WAVE_FORMAT_LH_CODEC_SBC12 = $1103; (* Lernout & Hauspie *)
    WAVE_FORMAT_LH_CODEC_SBC16 = $1104; (* Lernout & Hauspie *)
    WAVE_FORMAT_NORRIS = $1400; (* Norris Communications, Inc. *)
    WAVE_FORMAT_ISIAUDIO_2 = $1401; (* ISIAudio *)
    WAVE_FORMAT_SOUNDSPACE_MUSICOMPRESS = $1500; (* AT&T Labs, Inc. *)
    WAVE_FORMAT_MPEG_ADTS_AAC = $1600; (* Microsoft Corporation *)
    WAVE_FORMAT_MPEG_RAW_AAC = $1601; (* Microsoft Corporation *)
    WAVE_FORMAT_MPEG_LOAS = $1602; (* Microsoft Corporation (MPEG-4 Audio Transport Streams (LOAS/LATM) *)
    WAVE_FORMAT_NOKIA_MPEG_ADTS_AAC = $1608; (* Microsoft Corporation *)
    WAVE_FORMAT_NOKIA_MPEG_RAW_AAC = $1609; (* Microsoft Corporation *)
    WAVE_FORMAT_VODAFONE_MPEG_ADTS_AAC = $160A; (* Microsoft Corporation *)
    WAVE_FORMAT_VODAFONE_MPEG_RAW_AAC = $160B; (* Microsoft Corporation *)
    WAVE_FORMAT_MPEG_HEAAC = $1610; (* Microsoft Corporation (MPEG-2 AAC or MPEG-4 HE-AAC v1/v2 streams with any payload (ADTS, ADIF, LOAS/LATM, RAW). Format block includes MP4 AudioSpecificConfig() -- see HEAACWAVEFORMAT below *)
    WAVE_FORMAT_VOXWARE_RT24_SPEECH = $181C; (* Voxware Inc. *)
    WAVE_FORMAT_SONICFOUNDRY_LOSSLESS = $1971; (* Sonic Foundry *)
    WAVE_FORMAT_INNINGS_TELECOM_ADPCM = $1979; (* Innings Telecom Inc. *)
    WAVE_FORMAT_LUCENT_SX8300P = $1C07; (* Lucent Technologies *)
    WAVE_FORMAT_LUCENT_SX5363S = $1C0C; (* Lucent Technologies *)
    WAVE_FORMAT_CUSEEME = $1F03; (* CUSeeMe *)
    WAVE_FORMAT_NTCSOFT_ALF2CM_ACM = $1FC4; (* NTCSoft *)
    WAVE_FORMAT_DVM = $2000; (* FAST Multimedia AG *)
    WAVE_FORMAT_DTS2 = $2001;
    WAVE_FORMAT_MAKEAVIS = $3313;
    WAVE_FORMAT_DIVIO_MPEG4_AAC = $4143; (* Divio, Inc. *)
    WAVE_FORMAT_NOKIA_ADAPTIVE_MULTIRATE = $4201; (* Nokia *)
    WAVE_FORMAT_DIVIO_G726 = $4243; (* Divio, Inc. *)
    WAVE_FORMAT_LEAD_SPEECH = $434C; (* LEAD Technologies *)
    WAVE_FORMAT_LEAD_VORBIS = $564C; (* LEAD Technologies *)
    WAVE_FORMAT_WAVPACK_AUDIO = $5756; (* xiph.org *)
    WAVE_FORMAT_ALAC = $6C61; (* Apple Lossless *)
    WAVE_FORMAT_OGG_VORBIS_MODE_1 = $674F; (* Ogg Vorbis *)
    WAVE_FORMAT_OGG_VORBIS_MODE_2 = $6750; (* Ogg Vorbis *)
    WAVE_FORMAT_OGG_VORBIS_MODE_3 = $6751; (* Ogg Vorbis *)
    WAVE_FORMAT_OGG_VORBIS_MODE_1_PLUS = $676F; (* Ogg Vorbis *)
    WAVE_FORMAT_OGG_VORBIS_MODE_2_PLUS = $6770; (* Ogg Vorbis *)
    WAVE_FORMAT_OGG_VORBIS_MODE_3_PLUS = $6771; (* Ogg Vorbis *)
    WAVE_FORMAT_3COM_NBX = $7000; (* 3COM Corp. *)
    WAVE_FORMAT_OPUS = $704F; (* Opus *)
    WAVE_FORMAT_FAAD_AAC = $706D;
    WAVE_FORMAT_AMR_NB = $7361; (* AMR Narrowband *)
    WAVE_FORMAT_AMR_WB = $7362; (* AMR Wideband *)
    WAVE_FORMAT_AMR_WP = $7363; (* AMR Wideband Plus *)
    WAVE_FORMAT_GSM_AMR_CBR = $7A21; (* GSMA/3GPP *)
    WAVE_FORMAT_GSM_AMR_VBR_SID = $7A22; (* GSMA/3GPP *)
    WAVE_FORMAT_COMVERSE_INFOSYS_G723_1 = $A100; (* Comverse Infosys *)
    WAVE_FORMAT_COMVERSE_INFOSYS_AVQSBC = $A101; (* Comverse Infosys *)
    WAVE_FORMAT_COMVERSE_INFOSYS_SBC = $A102; (* Comverse Infosys *)
    WAVE_FORMAT_SYMBOL_G729_A = $A103; (* Symbol Technologies *)
    WAVE_FORMAT_VOICEAGE_AMR_WB = $A104; (* VoiceAge Corp. *)
    WAVE_FORMAT_INGENIENT_G726 = $A105; (* Ingenient Technologies, Inc. *)
    WAVE_FORMAT_MPEG4_AAC = $A106; (* ISO/MPEG-4 *)
    WAVE_FORMAT_ENCORE_G726 = $A107; (* Encore Software *)
    WAVE_FORMAT_ZOLL_ASAO = $A108; (* ZOLL Medical Corp. *)
    WAVE_FORMAT_SPEEX_VOICE = $A109; (* xiph.org *)
    WAVE_FORMAT_VIANIX_MASC = $A10A; (* Vianix LLC *)
    WAVE_FORMAT_WM9_SPECTRUM_ANALYZER = $A10B; (* Microsoft *)
    WAVE_FORMAT_WMF_SPECTRUM_ANAYZER = $A10C; (* Microsoft *)
    WAVE_FORMAT_GSM_610 = $A10D;
    WAVE_FORMAT_GSM_620 = $A10E;
    WAVE_FORMAT_GSM_660 = $A10F;
    WAVE_FORMAT_GSM_690 = $A110;
    WAVE_FORMAT_GSM_ADAPTIVE_MULTIRATE_WB = $A111;
    WAVE_FORMAT_POLYCOM_G722 = $A112; (* Polycom *)
    WAVE_FORMAT_POLYCOM_G728 = $A113; (* Polycom *)
    WAVE_FORMAT_POLYCOM_G729_A = $A114; (* Polycom *)
    WAVE_FORMAT_POLYCOM_SIREN = $A115; (* Polycom *)
    WAVE_FORMAT_GLOBAL_IP_ILBC = $A116; (* Global IP *)
    WAVE_FORMAT_RADIOTIME_TIME_SHIFT_RADIO = $A117; (* RadioTime *)
    WAVE_FORMAT_NICE_ACA = $A118; (* Nice Systems *)
    WAVE_FORMAT_NICE_ADPCM = $A119; (* Nice Systems *)
    WAVE_FORMAT_VOCORD_G721 = $A11A; (* Vocord Telecom *)
    WAVE_FORMAT_VOCORD_G726 = $A11B; (* Vocord Telecom *)
    WAVE_FORMAT_VOCORD_G722_1 = $A11C; (* Vocord Telecom *)
    WAVE_FORMAT_VOCORD_G728 = $A11D; (* Vocord Telecom *)
    WAVE_FORMAT_VOCORD_G729 = $A11E; (* Vocord Telecom *)
    WAVE_FORMAT_VOCORD_G729_A = $A11F; (* Vocord Telecom *)
    WAVE_FORMAT_VOCORD_G723_1 = $A120; (* Vocord Telecom *)
    WAVE_FORMAT_VOCORD_LBC = $A121; (* Vocord Telecom *)
    WAVE_FORMAT_NICE_G728 = $A122; (* Nice Systems *)
    WAVE_FORMAT_FRACE_TELECOM_G729 = $A123; (* France Telecom *)
    WAVE_FORMAT_CODIAN = $A124; (* CODIAN *)
    WAVE_FORMAT_DOLBY_AC4 = $AC40; (* Dolby AC-4 *)
    WAVE_FORMAT_FLAC = $F1AC; (* flac.sourceforge.net *)


    WAVE_FORMAT_EXTENSIBLE = $FFFE; (* Microsoft *)


    //  New wave format development should be based on the
    //  WAVEFORMATEXTENSIBLE structure. WAVEFORMATEXTENSIBLE allows you to
    //  avoid having to register a new format tag with Microsoft. However, if
    //  you must still define a new format tag, the WAVE_FORMAT_DEVELOPMENT
    //  format tag can be used during the development phase of a new wave
    //  format.  Before shipping, you MUST acquire an official format tag from
    //  Microsoft.

    WAVE_FORMAT_DEVELOPMENT = ($FFFF);


    WAVE_FORMAT_PCM = 1;


    // Speaker Positions for dwChannelMask in WAVEFORMATEXTENSIBLE:
    SPEAKER_FRONT_LEFT = $1;
    SPEAKER_FRONT_RIGHT = $2;
    SPEAKER_FRONT_CENTER = $4;
    SPEAKER_LOW_FREQUENCY = $8;
    SPEAKER_BACK_LEFT = $10;
    SPEAKER_BACK_RIGHT = $20;
    SPEAKER_FRONT_LEFT_OF_CENTER = $40;
    SPEAKER_FRONT_RIGHT_OF_CENTER = $80;
    SPEAKER_BACK_CENTER = $100;
    SPEAKER_SIDE_LEFT = $200;
    SPEAKER_SIDE_RIGHT = $400;
    SPEAKER_TOP_CENTER = $800;
    SPEAKER_TOP_FRONT_LEFT = $1000;
    SPEAKER_TOP_FRONT_CENTER = $2000;
    SPEAKER_TOP_FRONT_RIGHT = $4000;
    SPEAKER_TOP_BACK_LEFT = $8000;
    SPEAKER_TOP_BACK_CENTER = $10000;
    SPEAKER_TOP_BACK_RIGHT = $20000;

    // Bit mask locations reserved for future use
    SPEAKER_RESERVED = $7FFC0000;

    // Used to specify that any possible permutation of speaker configurations
    SPEAKER_ALL = $80000000;


    ACM_MPEG_LAYER1 = ($0001);
    ACM_MPEG_LAYER2 = ($0002);
    ACM_MPEG_LAYER3 = ($0004);
    ACM_MPEG_STEREO = ($0001);
    ACM_MPEG_JOINTSTEREO = ($0002);
    ACM_MPEG_DUALCHANNEL = ($0004);
    ACM_MPEG_SINGLECHANNEL = ($0008);
    ACM_MPEG_PRIVATEBIT = ($0001);
    ACM_MPEG_COPYRIGHT = ($0002);
    ACM_MPEG_ORIGINALHOME = ($0004);
    ACM_MPEG_PROTECTIONBIT = ($0008);
    ACM_MPEG_ID_MPEG1 = ($0010);


    // MPEG Layer3 WAVEFORMATEX structure
    // for WAVE_FORMAT_MPEGLAYER3 (0x0055)

    MPEGLAYER3_WFX_EXTRA_BYTES = 12;

    MPEGLAYER3_ID_UNKNOWN = 0;
    MPEGLAYER3_ID_MPEG = 1;
    MPEGLAYER3_ID_CONSTANTFRAMESIZE = 2;

    MPEGLAYER3_FLAG_PADDING_ISO = $00000000;
    MPEGLAYER3_FLAG_PADDING_ON = $00000001;
    MPEGLAYER3_FLAG_PADDING_OFF = $00000002;


    //  Windows Media Audio (common)


    MM_MSFT_ACM_WMAUDIO = 39;

    WMAUDIO_BITS_PER_SAMPLE = 16; // just an uncompressed size...
    WMAUDIO_MAX_CHANNELS = 2;


    //  Windows Media Audio V1 (a.k.a. "MSAudio")

    //      for WAVE_FORMAT_MSAUDIO1        (0x0160)


    MM_MSFT_ACM_MSAUDIO1 = 39;

    MSAUDIO1_BITS_PER_SAMPLE = WMAUDIO_BITS_PER_SAMPLE;
    MSAUDIO1_MAX_CHANNELS = WMAUDIO_MAX_CHANNELS;

    MM_MSFT_ACM_WMAUDIO2 = 101;
    WMAUDIO2_BITS_PER_SAMPLE = WMAUDIO_BITS_PER_SAMPLE;
    WMAUDIO2_MAX_CHANNELS = WMAUDIO_MAX_CHANNELS;
    WAVE_FILTER_UNKNOWN = $0000;
    WAVE_FILTER_DEVELOPMENT = ($FFFF);
    WAVE_FILTER_VOLUME = $0001;
    WAVE_FILTER_ECHO = $0002;


    RIFFWAVE_inst = (Ord('i') or (Ord('n') shl 8) or (Ord('s') shl 16) or (Ord('t') shl 24));

    (* ------------------------------------------------------------------------------ *)

    // New RIFF Forms

    (* RIFF AVI *)

    // AVI file format is specified in a seperate file (AVIFMT.H),
    // which is available in the VfW and Win 32 SDK

    (* RIFF CPPO *)


    RIFFCPPO = (Ord('C') or (Ord('P') shl 8) or (Ord('P') shl 16) or (Ord('O') shl 24));

    RIFFCPPO_objr = (Ord('o') or (Ord('b') shl 8) or (Ord('j') shl 16) or (Ord('r') shl 24));
    RIFFCPPO_obji = (Ord('o') or (Ord('b') shl 8) or (Ord('j') shl 16) or (Ord('i') shl 24));

    RIFFCPPO_clsr = (Ord('c') or (Ord('l') shl 8) or (Ord('s') shl 16) or (Ord('r') shl 24));
    RIFFCPPO_clsi = (Ord('c') or (Ord('l') shl 8) or (Ord('s') shl 16) or (Ord('i') shl 24));

    RIFFCPPO_mbr = (Ord('m') or (Ord('b') shl 8) or (Ord('r') shl 16) or (Ord(' ') shl 24));

    RIFFCPPO_char = (Ord('c') or (Ord('h') shl 8) or (Ord('a') shl 16) or (Ord('r') shl 24));

    RIFFCPPO_byte = (Ord('b') or (Ord('y') shl 8) or (Ord('t') shl 16) or (Ord('e') shl 24));
    RIFFCPPO_int = (Ord('i') or (Ord('n') shl 8) or (Ord('t') shl 16) or (Ord(' ') shl 24));
    RIFFCPPO_word = (Ord('w') or (Ord('o') shl 8) or (Ord('r') shl 16) or (Ord('d') shl 24));
    RIFFCPPO_long = (Ord('l') or (Ord('o') shl 8) or (Ord('n') shl 16) or (Ord('g') shl 24));
    RIFFCPPO_dwrd = (Ord('d') or (Ord('w') shl 8) or (Ord('r') shl 16) or (Ord('d') shl 24));
    RIFFCPPO_flt = (Ord('f') or (Ord('l') shl 8) or (Ord('t') shl 16) or (Ord(' ') shl 24));
    RIFFCPPO_dbl = (Ord('d') or (Ord('b') shl 8) or (Ord('l') shl 16) or (Ord(' ') shl 24));
    RIFFCPPO_str = (Ord('s') or (Ord('t') shl 8) or (Ord('r') shl 16) or (Ord(' ') shl 24));


(*
//////////////////////////////////////////////////////////////////////////
//
// DIB Compression Defines
//
*)


    BI_BITFIELDS = 3;


    QUERYDIBSUPPORT = 3073;
    QDI_SETDIBITS = $0001;
    QDI_GETDIBITS = $0002;
    QDI_DIBTOSCREEN = $0004;
    QDI_STRETCHDIB = $0008;


    (* New DIB Compression Defines *)

    BICOMP_IBMULTIMOTION = (Ord('U') or (Ord('L') shl 8) or (Ord('T') shl 16) or (Ord('I') shl 24));
    BICOMP_IBMPHOTOMOTION = (Ord('P') or (Ord('H') shl 8) or (Ord('M') shl 16) or (Ord('O') shl 24));
    BICOMP_CREATIVEYUV = (Ord('c') or (Ord('y') shl 8) or (Ord('u') shl 16) or (Ord('v') shl 24));


    (* New DIB Compression Defines *)
    JPEG_DIB = (Ord('J') or (Ord('P') shl 8) or (Ord('E') shl 16) or (Ord('G') shl 24)); (* Still image JPEG DIB biCompression *)
    MJPG_DIB = (Ord('M') or (Ord('J') shl 8) or (Ord('P') shl 16) or (Ord('G') shl 24)); (* Motion JPEG DIB biCompression     *)

    (* JPEGProcess Definitions *)
    JPEG_PROCESS_BASELINE = 0; (* Baseline DCT *)

    (* AVI File format extensions *)
    AVIIF_CONTROLFRAME = $00000200; (* This is a control frame *)

    (* JIF Marker byte pairs in JPEG Interchange Format sequence *)
    JIFMK_SOF0 = $FFC0; (* SOF Huff  - Baseline DCT*)
    JIFMK_SOF1 = $FFC1; (* SOF Huff  - Extended sequential DCT*)
    JIFMK_SOF2 = $FFC2; (* SOF Huff  - Progressive DCT*)
    JIFMK_SOF3 = $FFC3; (* SOF Huff  - Spatial (sequential) lossless*)
    JIFMK_SOF5 = $FFC5; (* SOF Huff  - Differential sequential DCT*)
    JIFMK_SOF6 = $FFC6; (* SOF Huff  - Differential progressive DCT*)
    JIFMK_SOF7 = $FFC7; (* SOF Huff  - Differential spatial*)
    JIFMK_JPG = $FFC8; (* SOF Arith - Reserved for JPEG extensions*)
    JIFMK_SOF9 = $FFC9; (* SOF Arith - Extended sequential DCT*)
    JIFMK_SOF10 = $FFCA; (* SOF Arith - Progressive DCT*)
    JIFMK_SOF11 = $FFCB; (* SOF Arith - Spatial (sequential) lossless*)
    JIFMK_SOF13 = $FFCD; (* SOF Arith - Differential sequential DCT*)
    JIFMK_SOF14 = $FFCE; (* SOF Arith - Differential progressive DCT*)
    JIFMK_SOF15 = $FFCF; (* SOF Arith - Differential spatial*)
    JIFMK_DHT = $FFC4; (* Define Huffman Table(s) *)
    JIFMK_DAC = $FFCC; (* Define Arithmetic coding conditioning(s) *)
    JIFMK_RST0 = $FFD0; (* Restart with modulo 8 count 0 *)
    JIFMK_RST1 = $FFD1; (* Restart with modulo 8 count 1 *)
    JIFMK_RST2 = $FFD2; (* Restart with modulo 8 count 2 *)
    JIFMK_RST3 = $FFD3; (* Restart with modulo 8 count 3 *)
    JIFMK_RST4 = $FFD4; (* Restart with modulo 8 count 4 *)
    JIFMK_RST5 = $FFD5; (* Restart with modulo 8 count 5 *)
    JIFMK_RST6 = $FFD6; (* Restart with modulo 8 count 6 *)
    JIFMK_RST7 = $FFD7; (* Restart with modulo 8 count 7 *)
    JIFMK_SOI = $FFD8; (* Start of Image *)
    JIFMK_EOI = $FFD9; (* End of Image *)
    JIFMK_SOS = $FFDA; (* Start of Scan *)
    JIFMK_DQT = $FFDB; (* Define quantization Table(s) *)
    JIFMK_DNL = $FFDC; (* Define Number of Lines *)
    JIFMK_DRI = $FFDD; (* Define Restart Interval *)
    JIFMK_DHP = $FFDE; (* Define Hierarchical progression *)
    JIFMK_EXP = $FFDF; (* Expand Reference Component(s) *)
    JIFMK_APP0 = $FFE0; (* Application Field 0*)
    JIFMK_APP1 = $FFE1; (* Application Field 1*)
    JIFMK_APP2 = $FFE2; (* Application Field 2*)
    JIFMK_APP3 = $FFE3; (* Application Field 3*)
    JIFMK_APP4 = $FFE4; (* Application Field 4*)
    JIFMK_APP5 = $FFE5; (* Application Field 5*)
    JIFMK_APP6 = $FFE6; (* Application Field 6*)
    JIFMK_APP7 = $FFE7; (* Application Field 7*)
    JIFMK_JPG0 = $FFF0; (* Reserved for JPEG extensions *)
    JIFMK_JPG1 = $FFF1; (* Reserved for JPEG extensions *)
    JIFMK_JPG2 = $FFF2; (* Reserved for JPEG extensions *)
    JIFMK_JPG3 = $FFF3; (* Reserved for JPEG extensions *)
    JIFMK_JPG4 = $FFF4; (* Reserved for JPEG extensions *)
    JIFMK_JPG5 = $FFF5; (* Reserved for JPEG extensions *)
    JIFMK_JPG6 = $FFF6; (* Reserved for JPEG extensions *)
    JIFMK_JPG7 = $FFF7; (* Reserved for JPEG extensions *)
    JIFMK_JPG8 = $FFF8; (* Reserved for JPEG extensions *)
    JIFMK_JPG9 = $FFF9; (* Reserved for JPEG extensions *)
    JIFMK_JPG10 = $FFFA; (* Reserved for JPEG extensions *)
    JIFMK_JPG11 = $FFFB; (* Reserved for JPEG extensions *)
    JIFMK_JPG12 = $FFFC; (* Reserved for JPEG extensions *)
    JIFMK_JPG13 = $FFFD; (* Reserved for JPEG extensions *)
    JIFMK_COM = $FFFE; (* Comment *)
    JIFMK_TEM = $FF01; (* for temp private use arith code *)
    JIFMK_RES = $FF02; (* Reserved *)
    JIFMK_00 = $FF00; (* Zero stuffed byte - entropy data *)
    JIFMK_FF = $FFFF; (* Fill byte *)

    (* JPEGColorSpaceID Definitions *)
    JPEG_Y = 1; (* Y only component of YCbCr *)
    JPEG_YCbCr = 2; (* YCbCr as define by CCIR 601 *)
    JPEG_RGB = 3; (* 3 component RGB *)


    (* Default DHT Segment *)

    MJPGDHTSeg: array [0..$1A4 - 1] of byte = (
        (* JPEG DHT Segment for YCrCb omitted from MJPG data *)
        $FF, $C4, $01, $A2,
        $00, $00, $01, $05, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00,
        $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $01, $00, $03, $01, $01, $01, $01,
        $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $01, $02, $03, $04, $05, $06, $07,
        $08, $09, $0A, $0B, $10, $00, $02, $01, $03, $03, $02, $04, $03, $05, $05, $04, $04, $00,
        $00, $01, $7D, $01, $02, $03, $00, $04, $11, $05, $12, $21, $31, $41, $06, $13, $51, $61,
        $07, $22, $71, $14, $32, $81, $91, $A1, $08, $23, $42, $B1, $C1, $15, $52, $D1, $F0, $24,
        $33, $62, $72, $82, $09, $0A, $16, $17, $18, $19, $1A, $25, $26, $27, $28, $29, $2A, $34,
        $35, $36, $37, $38, $39, $3A, $43, $44, $45, $46, $47, $48, $49, $4A, $53, $54, $55, $56,
        $57, $58, $59, $5A, $63, $64, $65, $66, $67, $68, $69, $6A, $73, $74, $75, $76, $77, $78,
        $79, $7A, $83, $84, $85, $86, $87, $88, $89, $8A, $92, $93, $94, $95, $96, $97, $98, $99,
        $9A, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $B2, $B3, $B4, $B5, $B6, $B7, $B8, $B9,
        $BA, $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $CA, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9,
        $DA, $E1, $E2, $E3, $E4, $E5, $E6, $E7, $E8, $E9, $EA, $F1, $F2, $F3, $F4, $F5, $F6, $F7,
        $F8, $F9, $FA, $11, $00, $02, $01, $02, $04, $04, $03, $04, $07, $05, $04, $04, $00, $01,
        $02, $77, $00, $01, $02, $03, $11, $04, $05, $21, $31, $06, $12, $41, $51, $07, $61, $71,
        $13, $22, $32, $81, $08, $14, $42, $91, $A1, $B1, $C1, $09, $23, $33, $52, $F0, $15, $62,
        $72, $D1, $0A, $16, $24, $34, $E1, $25, $F1, $17, $18, $19, $1A, $26, $27, $28, $29, $2A,
        $35, $36, $37, $38, $39, $3A, $43, $44, $45, $46, $47, $48, $49, $4A, $53, $54, $55, $56,
        $57, $58, $59, $5A, $63, $64, $65, $66, $67, $68, $69, $6A, $73, $74, $75, $76, $77, $78,
        $79, $7A, $82, $83, $84, $85, $86, $87, $88, $89, $8A, $92, $93, $94, $95, $96, $97, $98,
        $99, $9A, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $B2, $B3, $B4, $B5, $B6, $B7, $B8,
        $B9, $BA, $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $CA, $D2, $D3, $D4, $D5, $D6, $D7, $D8,
        $D9, $DA, $E2, $E3, $E4, $E5, $E6, $E7, $E8, $E9, $EA, $F2, $F3, $F4, $F5, $F6, $F7, $F8,
        $F9, $FA);


    (* End DHT default *)


    (* End JPEG *)


    (* ------------------------------------------------------------------------------ *)

    // Defined IC types


    ICTYPE_VIDEO = (Ord('v') or (Ord('i') shl 8) or (Ord('d') shl 16) or (Ord('c') shl 24));
    ICTYPE_AUDIO = (Ord('a') or (Ord('u') shl 8) or (Ord('d') shl 16) or (Ord('c') shl 24));

(*
//   Misc. FOURCC registration
*)
(* Sierra Semiconductor: RDSP- Proprietary RIFF file format
//       for the storage and downloading of DSP
//       code for Audio and communications devices.
*)

    FOURCC_RDSP = (Ord('R') or (Ord('D') shl 8) or (Ord('S') shl 16) or (Ord('P') shl 24));

    MIXERCONTROL_CT_CLASS_SWITCH = $20000000;
    MIXERCONTROL_CT_SC_SWITCH_BOOLEAN = $00000000;
    MIXERCONTROL_CT_UNITS_BOOLEAN = $00010000;


    MIXERCONTROL_CONTROLTYPE_BOOLEAN = (MIXERCONTROL_CT_CLASS_SWITCH or MIXERCONTROL_CT_SC_SWITCH_BOOLEAN or MIXERCONTROL_CT_UNITS_BOOLEAN);

    MIXERCONTROL_CONTROLTYPE_SRS_MTS = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 6);
    MIXERCONTROL_CONTROLTYPE_SRS_ONOFF = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 7);
    MIXERCONTROL_CONTROLTYPE_SRS_SYNTHSELECT = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 8);

    KSDATAFORMAT_SUBTYPE_PCM: TGUID = '{00000001-0000-0010-8000-00aa00389b71}';
    KSDATAFORMAT_SUBTYPE_IEEE_FLOAT: TGUID = '{00000003-0000-0010-8000-00aa00389b71}';
    KSDATAFORMAT_SUBTYPE_WAVEFORMATEX: TGUID = '{00000000-0000-0010-8000-00aa00389b71}';

type

    {$PackRecords 1}


    (* general waveform format structure (information common to all formats) *)
    Twaveformat_tag = record
        wFormatTag: word; (* format type *)
        nChannels: word; (* number of channels (i.e. mono, stereo...) *)
        nSamplesPerSec: DWORD; (* sample rate *)
        nAvgBytesPerSec: DWORD; (* for buffer estimation *)
        nBlockAlign: word; (* block size of data *)
    end;
    Pwaveformat_tag = ^Twaveformat_tag;

    TWAVEFORMAT = Twaveformat_tag;
    PWAVEFORMAT = ^TWAVEFORMAT;
    NPWAVEFORMAT = ^TWAVEFORMAT;
    LPWAVEFORMAT = ^TWAVEFORMAT;

    (* specific waveform format structure for PCM data *)
    Tpcmwaveformat_tag = record
        wf: TWAVEFORMAT;
        wBitsPerSample: word;
    end;
    Ppcmwaveformat_tag = ^Tpcmwaveformat_tag;

    TPCMWAVEFORMAT = Tpcmwaveformat_tag;
    PPCMWAVEFORMAT = ^TPCMWAVEFORMAT;
    NPPCMWAVEFORMAT = ^TPCMWAVEFORMAT;
    LPPCMWAVEFORMAT = ^TPCMWAVEFORMAT;


(* general extended waveform format structure
   Use this for all NON PCM formats
   (information common to all formats)
*)

    TWAVEFORMATEX = record
        wFormatTag: word; (* format type *)
        nChannels: word; (* number of channels (i.e. mono, stereo...) *)
        nSamplesPerSec: DWORD; (* sample rate *)
        nAvgBytesPerSec: DWORD; (* for buffer estimation *)
        nBlockAlign: word; (* block size of data *)
        wBitsPerSample: word; (* Number of bits per sample of mono data *)
        cbSize: word; (* The count in bytes of the size of extra information (after cbSize) *)
    end;
    PWAVEFORMATEX = ^TWAVEFORMATEX;
    NPWAVEFORMATEX = ^TWAVEFORMATEX;
    LPWAVEFORMATEX = ^TWAVEFORMATEX;


    //  New wave format development should be based on the
    //  WAVEFORMATEXTENSIBLE structure. WAVEFORMATEXTENSIBLE allows you to
    //  avoid having to register a new format tag with Microsoft. Simply
    //  define a new GUID value for the WAVEFORMATEXTENSIBLE.SubFormat field
    //  and use WAVE_FORMAT_EXTENSIBLE in the
    //  WAVEFORMATEXTENSIBLE.Format.wFormatTag field.


    TWAVEFORMATEXTENSIBLE = record
        Format: TWAVEFORMATEX;
        case integer of
            0: (Samples: record
                    wValidBitsPerSample: word; (* bits of precision  *)
                    dwChannelMask: DWORD; (* which channels are *)
                    (* present in stream  *)
                    SubFormat: TGUID;
                    end;
            );
            1: (
                wSamplesPerBlock: word; (* valid if wBitsPerSample==0 *)
            );
            2: (
                wReserved: word; (* If neither applies, set to zero. *)
            );
            3: (
                wValidBitsPerSample: word; (* bits of precision  *)
                dwChannelMask: DWORD; (* which channels are *)
                (* present in stream  *)
                SubFormat: TGUID;

            );
    end;
    PWAVEFORMATEXTENSIBLE = ^TWAVEFORMATEXTENSIBLE;


    //  Extended PCM waveform format structure based on WAVEFORMATEXTENSIBLE.
    //  Use this for multiple channel and hi-resolution PCM data

    TWAVEFORMATPCMEX = TWAVEFORMATEXTENSIBLE;
    (* Format.cbSize = 22 *)
    PWAVEFORMATPCMEX = ^TWAVEFORMATPCMEX;
    NPWAVEFORMATPCMEX = ^TWAVEFORMATPCMEX;
    LPWAVEFORMATPCMEX = ^TWAVEFORMATPCMEX;


    //  Extended format structure using IEEE Float data and based
    //  on WAVEFORMATEXTENSIBLE.  Use this for multiple channel
    //  and hi-resolution PCM data in IEEE floating point format.

    TWAVEFORMATIEEEFLOATEX = TWAVEFORMATEXTENSIBLE;
    (* Format.cbSize = 22 *)
    PWAVEFORMATIEEEFLOATEX = ^TWAVEFORMATIEEEFLOATEX;
    NPWAVEFORMATIEEEFLOATEX = ^TWAVEFORMATIEEEFLOATEX;
    LPWAVEFORMATIEEEFLOATEX = ^TWAVEFORMATIEEEFLOATEX;


    (* Define data for MS ADPCM *)

    Tadpcmcoef_tag = record
        iCoef1: short;
        iCoef2: short;
    end;
    Padpcmcoef_tag = ^Tadpcmcoef_tag;

    TADPCMCOEFSET = Tadpcmcoef_tag;
    PADPCMCOEFSET = ^TADPCMCOEFSET;
    NPADPCMCOEFSET = ^TADPCMCOEFSET;
    LPADPCMCOEFSET = ^TADPCMCOEFSET;


    Tadpcmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wSamplesPerBlock: word;
        wNumCoef: word;
        aCoef: PADPCMCOEFSET;
    end;
    Padpcmwaveformat_tag = ^Tadpcmwaveformat_tag;

    TADPCMWAVEFORMAT = Tadpcmwaveformat_tag;
    PADPCMWAVEFORMAT = ^TADPCMWAVEFORMAT;
    NPADPCMWAVEFORMAT = ^TADPCMWAVEFORMAT;
    LPADPCMWAVEFORMAT = ^TADPCMWAVEFORMAT;


    //  Microsoft's DRM structure definitions

    Tdrmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wReserved: word;
        ulContentId: ULONG;
        wfxSecure: TWAVEFORMATEX;
    end;
    Pdrmwaveformat_tag = ^Tdrmwaveformat_tag;

    TDRMWAVEFORMAT = Tdrmwaveformat_tag;
    PDRMWAVEFORMAT = ^TDRMWAVEFORMAT;
    NPDRMWAVEFORMAT = ^TDRMWAVEFORMAT;
    LPDRMWAVEFORMAT = ^TDRMWAVEFORMAT;


    //  Intel's DVI ADPCM structure definitions

    //      for WAVE_FORMAT_DVI_ADPCM   (0x0011)


    Tdvi_adpcmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wSamplesPerBlock: word;
    end;
    Pdvi_adpcmwaveformat_tag = ^Tdvi_adpcmwaveformat_tag;

    TDVIADPCMWAVEFORMAT = Tdvi_adpcmwaveformat_tag;
    PDVIADPCMWAVEFORMAT = ^TDVIADPCMWAVEFORMAT;
    NPDVIADPCMWAVEFORMAT = ^TDVIADPCMWAVEFORMAT;
    LPDVIADPCMWAVEFORMAT = ^TDVIADPCMWAVEFORMAT;


    //  IMA endorsed ADPCM structure definitions--note that this is exactly
    //  the same format as Intel's DVI ADPCM.

    //      for WAVE_FORMAT_IMA_ADPCM   (0x0011)


    Tima_adpcmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wSamplesPerBlock: word;
    end;
    Pima_adpcmwaveformat_tag = ^Tima_adpcmwaveformat_tag;

    TIMAADPCMWAVEFORMAT = Tima_adpcmwaveformat_tag;
    PIMAADPCMWAVEFORMAT = ^TIMAADPCMWAVEFORMAT;
    NPIMAADPCMWAVEFORMAT = ^TIMAADPCMWAVEFORMAT;
    LPIMAADPCMWAVEFORMAT = ^TIMAADPCMWAVEFORMAT;


(*
//VideoLogic's Media Space ADPCM Structure definitions
// for  WAVE_FORMAT_MEDIASPACE_ADPCM    (0x0012)
//
//
*)
    Tmediaspace_adpcmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wRevision: word;
    end;
    Pmediaspace_adpcmwaveformat_tag = ^Tmediaspace_adpcmwaveformat_tag;

    TMEDIASPACEADPCMWAVEFORMAT = Tmediaspace_adpcmwaveformat_tag;
    PMEDIASPACEADPCMWAVEFORMAT = ^TMEDIASPACEADPCMWAVEFORMAT;
    NPMEDIASPACEADPCMWAVEFORMAT = ^TMEDIASPACEADPCMWAVEFORMAT;
    LPMEDIASPACEADPCMWAVEFORMAT = ^TMEDIASPACEADPCMWAVEFORMAT;


    //  Sierra Semiconductor

    //      for WAVE_FORMAT_SIERRA_ADPCM   (0x0013)


    Tsierra_adpcmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wRevision: word;
    end;
    Psierra_adpcmwaveformat_tag = ^Tsierra_adpcmwaveformat_tag;

    TSIERRAADPCMWAVEFORMAT = Tsierra_adpcmwaveformat_tag;
    PSIERRAADPCMWAVEFORMAT = ^TSIERRAADPCMWAVEFORMAT;
    NPSIERRAADPCMWAVEFORMAT = ^TSIERRAADPCMWAVEFORMAT;
    LPSIERRAADPCMWAVEFORMAT = ^TSIERRAADPCMWAVEFORMAT;


    //  Antex Electronics  structure definitions

    //      for WAVE_FORMAT_G723_ADPCM   (0x0014)


    Tg723_adpcmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        cbExtraSize: word;
        nAuxBlockSize: word;
    end;
    Pg723_adpcmwaveformat_tag = ^Tg723_adpcmwaveformat_tag;

    TG723_ADPCMWAVEFORMAT = Tg723_adpcmwaveformat_tag;
    PG723_ADPCMWAVEFORMAT = ^TG723_ADPCMWAVEFORMAT;
    NPG723_ADPCMWAVEFORMAT = ^TG723_ADPCMWAVEFORMAT;
    LPG723_ADPCMWAVEFORMAT = ^TG723_ADPCMWAVEFORMAT;


    //  DSP Solutions (formerly DIGISPEECH) structure definitions

    //      for WAVE_FORMAT_DIGISTD   (0x0015)


    Tdigistdwaveformat_tag = record
        wfx: TWAVEFORMATEX;
    end;
    Pdigistdwaveformat_tag = ^Tdigistdwaveformat_tag;

    TDIGISTDWAVEFORMAT = Tdigistdwaveformat_tag;
    PDIGISTDWAVEFORMAT = ^TDIGISTDWAVEFORMAT;
    NPDIGISTDWAVEFORMAT = ^TDIGISTDWAVEFORMAT;
    LPDIGISTDWAVEFORMAT = ^TDIGISTDWAVEFORMAT;


    //  DSP Solutions (formerly DIGISPEECH) structure definitions

    //      for WAVE_FORMAT_DIGIFIX   (0x0016)


    Tdigifixwaveformat_tag = record
        wfx: TWAVEFORMATEX;
    end;
    Pdigifixwaveformat_tag = ^Tdigifixwaveformat_tag;

    TDIGIFIXWAVEFORMAT = Tdigifixwaveformat_tag;
    PDIGIFIXWAVEFORMAT = ^TDIGIFIXWAVEFORMAT;
    NPDIGIFIXWAVEFORMAT = ^TDIGIFIXWAVEFORMAT;
    LPDIGIFIXWAVEFORMAT = ^TDIGIFIXWAVEFORMAT;


    //   Dialogic Corporation
    // WAVEFORMAT_DIALOGIC_OKI_ADPCM   (0x0017)

    Tcreative_fastspeechformat_tag = record
        ewf: TWAVEFORMATEX;
    end;
    Pcreative_fastspeechformat_tag = ^Tcreative_fastspeechformat_tag;

    TDIALOGICOKIADPCMWAVEFORMAT = Tcreative_fastspeechformat_tag;
    PDIALOGICOKIADPCMWAVEFORMAT = ^TDIALOGICOKIADPCMWAVEFORMAT;
    NPDIALOGICOKIADPCMWAVEFORMAT = ^TDIALOGICOKIADPCMWAVEFORMAT;
    LPDIALOGICOKIADPCMWAVEFORMAT = ^TDIALOGICOKIADPCMWAVEFORMAT;


    //  Yamaha Compression's ADPCM structure definitions

    //      for WAVE_FORMAT_YAMAHA_ADPCM   (0x0020)


    Tyamaha_adpmcwaveformat_tag = record
        wfx: TWAVEFORMATEX;
    end;
    Pyamaha_adpmcwaveformat_tag = ^Tyamaha_adpmcwaveformat_tag;

    TYAMAHA_ADPCMWAVEFORMAT = Tyamaha_adpmcwaveformat_tag;
    PYAMAHA_ADPCMWAVEFORMAT = ^TYAMAHA_ADPCMWAVEFORMAT;
    NPYAMAHA_ADPCMWAVEFORMAT = ^TYAMAHA_ADPCMWAVEFORMAT;
    LPYAMAHA_ADPCMWAVEFORMAT = ^TYAMAHA_ADPCMWAVEFORMAT;


    //  Speech Compression's Sonarc structure definitions

    //      for WAVE_FORMAT_SONARC   (0x0021)


    Tsonarcwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wCompType: word;
    end;
    Psonarcwaveformat_tag = ^Tsonarcwaveformat_tag;

    TSONARCWAVEFORMAT = Tsonarcwaveformat_tag;
    PSONARCWAVEFORMAT = ^TSONARCWAVEFORMAT;
    NPSONARCWAVEFORMAT = ^TSONARCWAVEFORMAT;
    LPSONARCWAVEFORMAT = ^TSONARCWAVEFORMAT;


    //  DSP Groups's TRUESPEECH structure definitions

    //      for WAVE_FORMAT_DSPGROUP_TRUESPEECH   (0x0022)


    Ttruespeechwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wRevision: word;
        nSamplesPerBlock: word;
        abReserved: array [0..28 - 1] of TBYTE;
    end;
    Ptruespeechwaveformat_tag = ^Ttruespeechwaveformat_tag;

    TTRUESPEECHWAVEFORMAT = Ttruespeechwaveformat_tag;
    PTRUESPEECHWAVEFORMAT = ^TTRUESPEECHWAVEFORMAT;
    NPTRUESPEECHWAVEFORMAT = ^TTRUESPEECHWAVEFORMAT;
    LPTRUESPEECHWAVEFORMAT = ^TTRUESPEECHWAVEFORMAT;


    //  Echo Speech Corp structure definitions

    //      for WAVE_FORMAT_ECHOSC1   (0x0023)


    Techosc1waveformat_tag = record
        wfx: TWAVEFORMATEX;
    end;
    Pechosc1waveformat_tag = ^Techosc1waveformat_tag;

    TECHOSC1WAVEFORMAT = Techosc1waveformat_tag;
    PECHOSC1WAVEFORMAT = ^TECHOSC1WAVEFORMAT;
    NPECHOSC1WAVEFORMAT = ^TECHOSC1WAVEFORMAT;
    LPECHOSC1WAVEFORMAT = ^TECHOSC1WAVEFORMAT;


    //  Audiofile Inc.structure definitions

    //      for WAVE_FORMAT_AUDIOFILE_AF36   (0x0024)


    Taudiofile_af36waveformat_tag = record
        wfx: TWAVEFORMATEX;
    end;
    Paudiofile_af36waveformat_tag = ^Taudiofile_af36waveformat_tag;

    TAUDIOFILE_AF36WAVEFORMAT = Taudiofile_af36waveformat_tag;
    PAUDIOFILE_AF36WAVEFORMAT = ^TAUDIOFILE_AF36WAVEFORMAT;
    NPAUDIOFILE_AF36WAVEFORMAT = ^TAUDIOFILE_AF36WAVEFORMAT;
    LPAUDIOFILE_AF36WAVEFORMAT = ^TAUDIOFILE_AF36WAVEFORMAT;


    //  Audio Processing Technology structure definitions

    //      for WAVE_FORMAT_APTX   (0x0025)


    Taptxwaveformat_tag = record
        wfx: TWAVEFORMATEX;
    end;
    Paptxwaveformat_tag = ^Taptxwaveformat_tag;

    TAPTXWAVEFORMAT = Taptxwaveformat_tag;
    PAPTXWAVEFORMAT = ^TAPTXWAVEFORMAT;
    NPAPTXWAVEFORMAT = ^TAPTXWAVEFORMAT;
    LPAPTXWAVEFORMAT = ^TAPTXWAVEFORMAT;


    //  Audiofile Inc.structure definitions

    //      for WAVE_FORMAT_AUDIOFILE_AF10   (0x0026)


    Taudiofile_af10waveformat_tag = record
        wfx: TWAVEFORMATEX;
    end;
    Paudiofile_af10waveformat_tag = ^Taudiofile_af10waveformat_tag;

    TAUDIOFILE_AF10WAVEFORMAT = Taudiofile_af10waveformat_tag;
    PAUDIOFILE_AF10WAVEFORMAT = ^TAUDIOFILE_AF10WAVEFORMAT;
    NPAUDIOFILE_AF10WAVEFORMAT = ^TAUDIOFILE_AF10WAVEFORMAT;
    LPAUDIOFILE_AF10WAVEFORMAT = ^TAUDIOFILE_AF10WAVEFORMAT;


(* Dolby's AC-2 wave format structure definition
           WAVE_FORMAT_DOLBY_AC2    (0x0030)*)

    Tdolbyac2waveformat_tag = record
        wfx: TWAVEFORMATEX;
        nAuxBitsCode: word;
    end;
    Pdolbyac2waveformat_tag = ^Tdolbyac2waveformat_tag;

    TDOLBYAC2WAVEFORMAT = Tdolbyac2waveformat_tag;


    (*Microsoft's *)
    // WAVE_FORMAT_GSM 610           0x0031

    Tgsm610waveformat_tag = record
        wfx: TWAVEFORMATEX;
        wSamplesPerBlock: word;
    end;
    Pgsm610waveformat_tag = ^Tgsm610waveformat_tag;

    TGSM610WAVEFORMAT = Tgsm610waveformat_tag;
    PGSM610WAVEFORMAT = ^TGSM610WAVEFORMAT;
    NPGSM610WAVEFORMAT = ^TGSM610WAVEFORMAT;
    LPGSM610WAVEFORMAT = ^TGSM610WAVEFORMAT;


    //      Antex Electronics Corp

    //      for WAVE_FORMAT_ADPCME                  (0x0033)


    Tadpcmewaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wSamplesPerBlock: word;
    end;
    Padpcmewaveformat_tag = ^Tadpcmewaveformat_tag;

    TADPCMEWAVEFORMAT = Tadpcmewaveformat_tag;
    PADPCMEWAVEFORMAT = ^TADPCMEWAVEFORMAT;
    NPADPCMEWAVEFORMAT = ^TADPCMEWAVEFORMAT;
    LPADPCMEWAVEFORMAT = ^TADPCMEWAVEFORMAT;

    (*       Control Resources Limited *)
    // WAVE_FORMAT_CONTROL_RES_VQLPC                 0x0034

    Tcontres_vqlpcwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wSamplesPerBlock: word;
    end;
    Pcontres_vqlpcwaveformat_tag = ^Tcontres_vqlpcwaveformat_tag;

    TCONTRESVQLPCWAVEFORMAT = Tcontres_vqlpcwaveformat_tag;
    PCONTRESVQLPCWAVEFORMAT = ^TCONTRESVQLPCWAVEFORMAT;
    NPCONTRESVQLPCWAVEFORMAT = ^TCONTRESVQLPCWAVEFORMAT;
    LPCONTRESVQLPCWAVEFORMAT = ^TCONTRESVQLPCWAVEFORMAT;


    //      for WAVE_FORMAT_DIGIREAL                   (0x0035)


    Tdigirealwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wSamplesPerBlock: word;
    end;
    Pdigirealwaveformat_tag = ^Tdigirealwaveformat_tag;

    TDIGIREALWAVEFORMAT = Tdigirealwaveformat_tag;
    PDIGIREALWAVEFORMAT = ^TDIGIREALWAVEFORMAT;
    NPDIGIREALWAVEFORMAT = ^TDIGIREALWAVEFORMAT;
    LPDIGIREALWAVEFORMAT = ^TDIGIREALWAVEFORMAT;


    //  DSP Solutions

    //      for WAVE_FORMAT_DIGIADPCM   (0x0036)


    Tdigiadpcmmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wSamplesPerBlock: word;
    end;
    Pdigiadpcmmwaveformat_tag = ^Tdigiadpcmmwaveformat_tag;

    TDIGIADPCMWAVEFORMAT = Tdigiadpcmmwaveformat_tag;
    PDIGIADPCMWAVEFORMAT = ^TDIGIADPCMWAVEFORMAT;
    NPDIGIADPCMWAVEFORMAT = ^TDIGIADPCMWAVEFORMAT;
    LPDIGIADPCMWAVEFORMAT = ^TDIGIADPCMWAVEFORMAT;

    (*       Control Resources Limited *)
    // WAVE_FORMAT_CONTROL_RES_CR10          0x0037

    Tcontres_cr10waveformat_tag = record
        wfx: TWAVEFORMATEX;
        wSamplesPerBlock: word;
    end;
    Pcontres_cr10waveformat_tag = ^Tcontres_cr10waveformat_tag;

    TCONTRESCR10WAVEFORMAT = Tcontres_cr10waveformat_tag;
    PCONTRESCR10WAVEFORMAT = ^TCONTRESCR10WAVEFORMAT;
    NPCONTRESCR10WAVEFORMAT = ^TCONTRESCR10WAVEFORMAT;
    LPCONTRESCR10WAVEFORMAT = ^TCONTRESCR10WAVEFORMAT;


    //  Natural Microsystems

    //      for WAVE_FORMAT_NMS_VBXADPCM   (0x0038)


    Tnms_vbxadpcmmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wSamplesPerBlock: word;
    end;
    Pnms_vbxadpcmmwaveformat_tag = ^Tnms_vbxadpcmmwaveformat_tag;

    TNMS_VBXADPCMWAVEFORMAT = Tnms_vbxadpcmmwaveformat_tag;
    PNMS_VBXADPCMWAVEFORMAT = ^TNMS_VBXADPCMWAVEFORMAT;
    NPNMS_VBXADPCMWAVEFORMAT = ^TNMS_VBXADPCMWAVEFORMAT;
    LPNMS_VBXADPCMWAVEFORMAT = ^TNMS_VBXADPCMWAVEFORMAT;


    //  Antex Electronics  structure definitions

    //      for WAVE_FORMAT_G721_ADPCM   (0x0040)


    Tg721_adpcmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        nAuxBlockSize: word;
    end;
    Pg721_adpcmwaveformat_tag = ^Tg721_adpcmwaveformat_tag;

    TG721_ADPCMWAVEFORMAT = Tg721_adpcmwaveformat_tag;
    PG721_ADPCMWAVEFORMAT = ^TG721_ADPCMWAVEFORMAT;
    NPG721_ADPCMWAVEFORMAT = ^TG721_ADPCMWAVEFORMAT;
    LPG721_ADPCMWAVEFORMAT = ^TG721_ADPCMWAVEFORMAT;


    // Microsoft MPEG audio WAV definition

    (*  MPEG-1 audio wave format (audio layer only).   (0x0050)   *)
    Tmpeg1waveformat_tag = record
        wfx: TWAVEFORMATEX;
        fwHeadLayer: word;
        dwHeadBitrate: DWORD;
        fwHeadMode: word;
        fwHeadModeExt: word;
        wHeadEmphasis: word;
        fwHeadFlags: word;
        dwPTSLow: DWORD;
        dwPTSHigh: DWORD;
    end;
    Pmpeg1waveformat_tag = ^Tmpeg1waveformat_tag;

    TMPEG1WAVEFORMAT = Tmpeg1waveformat_tag;
    PMPEG1WAVEFORMAT = ^TMPEG1WAVEFORMAT;
    NPMPEG1WAVEFORMAT = ^TMPEG1WAVEFORMAT;
    LPMPEG1WAVEFORMAT = ^TMPEG1WAVEFORMAT;


    // WAVE_FORMAT_MPEGLAYER3 format sructure

    Tmpeglayer3waveformat_tag = record
        wfx: TWAVEFORMATEX;
        wID: word;
        fdwFlags: DWORD;
        nBlockSize: word;
        nFramesPerBlock: word;
        nCodecDelay: word;
    end;
    Pmpeglayer3waveformat_tag = ^Tmpeglayer3waveformat_tag;

    TMPEGLAYER3WAVEFORMAT = Tmpeglayer3waveformat_tag;

    PMPEGLAYER3WAVEFORMAT = ^TMPEGLAYER3WAVEFORMAT;
    NPMPEGLAYER3WAVEFORMAT = ^TMPEGLAYER3WAVEFORMAT;
    LPMPEGLAYER3WAVEFORMAT = ^TMPEGLAYER3WAVEFORMAT;


    // Xbox One supports a custom hardware-compressed audio format known as XMA
    // WAVE_FORMAT_XMA2 (0x166)
    // Older versions of the Xbox supported XMA v1 indicated with WAVE_FORMAT_XMA (0x165).
    TXMA2WAVEFORMATEX = record
        wfx: TWAVEFORMATEX;
        NumStreams: word;
        ChannelMask: DWORD;
        SamplesEncoded: DWORD;
        BytesPerBlock: DWORD;
        PlayBegin: DWORD;
        PlayLength: DWORD;
        LoopBegin: DWORD;
        LoopLength: DWORD;
        LoopCount: byte;
        EncoderVersion: byte;
        BlockCount: word;
    end;
    PXMA2WAVEFORMATEX = ^TXMA2WAVEFORMATEX;


    //==========================================================================;
(* ==========================================================================

      For WAVE_FORMAT_MPEG_HEAAC (0x1610)


 "MPEG-2" in the comments below refers to ISO/IEC 13818-7 (MPEG-2 AAC spec).
 "MPEG-4" in the comments below refers to ISO/IEC 14496-3 (MPEG-4 Audio spec).

 The following defines the format block to be used for MPEG-2 AAC or MPEG-4 HE-AAC v1/v2 streams.
 When setting media type attributes in Media Foundation (MF) objects, this will appear in conjunction with
 major type MFMediaType_Audio and sub type MFAudioFormat_AAC (=MEDIASUBTYPE_MPEG_HEAAC).
 The format block structure HEAACWAVEFORMAT is defined below.  It starts with the structure
 HEAACWAVEINFO (which is an extension of WAVEFORMATEX), followed by AudioSpecificConfig() as
 defined by ISO/IEC 14496-3 (MPEG-4 audio). Since the length of AudioSpecificConfig() may vary
 from one stream to another, this is a variable size format block.

 The WAVEFORMATEX fields describe the properties of the core AAC stream,
 without SBR/PS extensions (if exists). This is the description of the WAVEFORMATEX fields:

 wfx.wFormatTag - Set this to WAVE_FORMAT_MPEG_HEAAC (0x1610).

 wfx.nChannels - Total number of channels in core AAC stream (including LFE if exists).
 This might be different than the decoded number of channels if the MPEG-4 Parametric Stereo (PS)
 tool exists. If unknown, set to zero.

 wfx.nSamplesPerSec - Sampling rate of core AAC stream. This will be one of the 12 supported
 sampling rate between 8000 and 96000 Hz, as defined in MPEG-2.  This might be different than
 the decoded sampling rate if the MPEG-4 Spectral Band Replication (SBR) tool exists.
 If not know in advance, the sampling rate can be extracted from:
 - the 4-bit sampling_frequency_index field in adts_fixed_header(), or
 - program_config_element() in adif_header for MPEG-2 streams, or
 - the 4-bit samplingFrequencyIndex field in AudioSpecificConfig() for MPEG-4 streams.

 wfx.nAvgBytesPerSec - The average bytes per second calculated based on the average bit rate of
 the compressed stream. This value may be used by parsers to seek into a particular time offset
 in the stream. It may also be used by applications to determine roughly how much buffer length to allocate.
 If this is not known in advance, this value can be estimated by parsing some (or all) of the
 compressed HE-AAC frames and calculating bit rate based on average compressed frame size.
 If unknown, set to zero.

 wfx.nBlockAlign - Set this to 1.

 wfx.wBitsPerSample - Desired bit depth of the decoded PCM. If unknown, set to zero.

 wfx.cbSize - Set this to 12 (=sizeof(HEAACWAVEINFO)-sizeof(WAVEFORMATEX)) plus the
 size of AudioSpecificConfig() in bytes.

 ===================================

 How do we parse this format block? assume pbBuff is the address of the first
 byte in the format block. We do the following:

 HEAACWAVEINFO* pwfInfo = (HEAACWAVEINFO * )pbBuff;

 if ( 0 == pwfInfo->wStructType)
 {
    HEAACWAVEFORMAT* pwf = (HEAACWAVEFORMAT* )pbBuff;

    // All HEAACWAVEFORMAT fields can now be accessed through pwf
    // ...

    //
    // To parse AudioSpecifiConfig(), write a function such as
    // ParseAudioSpecificConfig(BYTE *pbASC, DWORD dwASCLen),
    // and call:
    //
    DWORD dwASCLen = pwf->wfInfo.wfx.cbSize - sizeof(HEAACWAVEINFO) + sizeof(WAVEFORMATEX);

    ParseAudioSpecificConfig(pwf->pbAudioSpecificConfig, dwASCLen);
 }
 else
 {
    // Reserved
 }
*)


    THEAACWAVEINFO = record
        // Defines core AAC properties. See description above. WAVEFORMATEX is of size 18 bytes.
        wfx: TWAVEFORMATEX;
        // Defines the payload type
        // 0-RAW.  The stream contains raw_data_block() elements only.
        // 1-ADTS. The stream contains an adts_sequence(), as defined by MPEG-2.
        // 2-ADIF. The stream contains an adif_sequence(), as defined by MPEG-2.
        // 3-LOAS. The stream contains an MPEG-4 audio transport stream with a
        //         synchronization layer LOAS and a multiplex layer LATM.
        // All other codes are reserved.
        wPayloadType: word;
        // This is the 8-bit field audioProfileLevelIndication available in the
        // MPEG-4 object descriptor.  It is an indication (as defined in MPEG-4 audio)
        // of the audio profile and level required to process the content associated
        // with this stream. For example values 0x28-0x2B correspond to AAC Profile,
        // values 0x2C-0x2F correspond to HE-AAC profile and 0x30-0x33 for HE-AAC v2 profile.
        // If unknown, set to zero or 0xFE ("no audio profile specified").
        wAudioProfileLevelIndication: word;
        // Defines the data that follows this structure. Currently only one data type is supported:
        // 0- AudioSpecificConfig() (as defined by MPEG-4 Audio, ISO/IEC 14496-3) will follow this structure.
        //    wfx.cbSize will indicate the total length including AudioSpecificConfig().
        //    Use HEAACWAVEFORMAT to gain easy access to the address of the first byte of
        //    AudioSpecificConfig() for parsing.
        //    Typical values for the size of AudioSpecificConfig (ASC) are:
        //    - 2 bytes for AAC or HE-AAC v1/v2 with implicit signaling of SBR,
        //    - 5 bytes for HE-AAC v1 with explicit signaling of SBR,
        //    - 7 bytes for HE-AAC v2 with explicit signaling of SBR and PS.
        //    The size may be longer than 7 bytes if the 4-bit channelConfiguration field in ASC is zero,
        //    which means program_config_element() is present in ASC.

        // All other codes are reserved.
        wStructType: word;
        // Set these to zero
        wReserved1: word;
        dwReserved2: DWORD;
    end; // this structure has a size of 30 bytes

    PHEAACWAVEINFO = ^THEAACWAVEINFO;
    NPHEAACWAVEINFO = ^THEAACWAVEINFO;
    LPHEAACWAVEINFO = ^THEAACWAVEINFO;


    // This structure describes the format block for wStructType=0

    THEAACWAVEFORMAT = record
        wfInfo: THEAACWAVEINFO; // This structure has a size of 30 bytes
        pbAudioSpecificConfig: byte; // First byte of AudioSpecificConfig()
    end; // This structure has a size of 31 bytes


    PHEAACWAVEFORMAT = ^THEAACWAVEFORMAT;
    NPHEAACWAVEFORMAT = ^THEAACWAVEFORMAT;
    LPHEAACWAVEFORMAT = ^THEAACWAVEFORMAT;


    //==========================================================================

    //  Windows Media Audio (common)


    //  Windows Media Audio V1 (a.k.a. "MSAudio")

    //      for WAVE_FORMAT_MSAUDIO1        (0x0160)


    Tmsaudio1waveformat_tag = record
        wfx: TWAVEFORMATEX;
        wSamplesPerBlock: word; // only counting "new" samples "= half of what will be used due to overlapping
        wEncodeOptions: word;
    end;
    Pmsaudio1waveformat_tag = ^Tmsaudio1waveformat_tag;

    TMSAUDIO1WAVEFORMAT = Tmsaudio1waveformat_tag;
    PMSAUDIO1WAVEFORMAT = ^TMSAUDIO1WAVEFORMAT;
    LPMSAUDIO1WAVEFORMAT = ^TMSAUDIO1WAVEFORMAT;


    //  Windows Media Audio V2

    //      for WAVE_FORMAT_WMAUDIO2        (0x0161)


    Twmaudio2waveformat_tag = record
        wfx: TWAVEFORMATEX;
        dwSamplesPerBlock: DWORD; // only counting "new" samples "= half of what will be used due to overlapping
        wEncodeOptions: word;
        dwSuperBlockAlign: DWORD; // the big size...  should be multiples of wfx.nBlockAlign.
    end;
    Pwmaudio2waveformat_tag = ^Twmaudio2waveformat_tag;

    TWMAUDIO2WAVEFORMAT = Twmaudio2waveformat_tag;

    LPWMAUDIO2WAVEFORMAT = ^TWMAUDIO2WAVEFORMAT;


    //  Windows Media Audio V3

    //      for WAVE_FORMAT_WMAUDIO3        (0x0162)


    Twmaudio3waveformat_tag = record
        wfx: TWAVEFORMATEX;
        wValidBitsPerSample: word; // bits of precision
        dwChannelMask: DWORD; // which channels are present in stream
        dwReserved1: DWORD;
        dwReserved2: DWORD;
        wEncodeOptions: word;
        wReserved3: word;
    end;
    Pwmaudio3waveformat_tag = ^Twmaudio3waveformat_tag;

    TWMAUDIO3WAVEFORMAT = Twmaudio3waveformat_tag;
    LPWMAUDIO3WAVEFORMAT = ^TWMAUDIO3WAVEFORMAT;


    //  Creative's ADPCM structure definitions

    //      for WAVE_FORMAT_CREATIVE_ADPCM   (0x0200)


    Tcreative_adpcmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
        wRevision: word;
    end;
    Pcreative_adpcmwaveformat_tag = ^Tcreative_adpcmwaveformat_tag;

    TCREATIVEADPCMWAVEFORMAT = Tcreative_adpcmwaveformat_tag;
    PCREATIVEADPCMWAVEFORMAT = ^TCREATIVEADPCMWAVEFORMAT;
    NPCREATIVEADPCMWAVEFORMAT = ^TCREATIVEADPCMWAVEFORMAT;
    LPCREATIVEADPCMWAVEFORMAT = ^TCREATIVEADPCMWAVEFORMAT;


    //    Creative FASTSPEECH
    // WAVEFORMAT_CREATIVE_FASTSPEECH8   (0x0202)

    Tcreative_fastspeech8format_tag = record
        wfx: TWAVEFORMATEX;
        wRevision: word;
    end;
    Pcreative_fastspeech8format_tag = ^Tcreative_fastspeech8format_tag;

    TCREATIVEFASTSPEECH8WAVEFORMAT = Tcreative_fastspeech8format_tag;
    PCREATIVEFASTSPEECH8WAVEFORMAT = ^TCREATIVEFASTSPEECH8WAVEFORMAT;
    NPCREATIVEFASTSPEECH8WAVEFORMAT = ^TCREATIVEFASTSPEECH8WAVEFORMAT;
    LPCREATIVEFASTSPEECH8WAVEFORMAT = ^TCREATIVEFASTSPEECH8WAVEFORMAT;

    //    Creative FASTSPEECH
    // WAVEFORMAT_CREATIVE_FASTSPEECH10   (0x0203)

    Tcreative_fastspeech10format_tag = record
        wfx: TWAVEFORMATEX;
        wRevision: word;
    end;
    Pcreative_fastspeech10format_tag = ^Tcreative_fastspeech10format_tag;

    TCREATIVEFASTSPEECH10WAVEFORMAT = Tcreative_fastspeech10format_tag;
    PCREATIVEFASTSPEECH10WAVEFORMAT = ^TCREATIVEFASTSPEECH10WAVEFORMAT;
    NPCREATIVEFASTSPEECH10WAVEFORMAT = ^TCREATIVEFASTSPEECH10WAVEFORMAT;
    LPCREATIVEFASTSPEECH10WAVEFORMAT = ^TCREATIVEFASTSPEECH10WAVEFORMAT;


    //  Fujitsu FM Towns 'SND' structure

    //      for WAVE_FORMAT_FMMTOWNS_SND   (0x0300)


    Tfmtowns_snd_waveformat_tag = record
        wfx: TWAVEFORMATEX;
        wRevision: word;
    end;
    Pfmtowns_snd_waveformat_tag = ^Tfmtowns_snd_waveformat_tag;

    TFMTOWNS_SND_WAVEFORMAT = Tfmtowns_snd_waveformat_tag;
    PFMTOWNS_SND_WAVEFORMAT = ^TFMTOWNS_SND_WAVEFORMAT;
    NPFMTOWNS_SND_WAVEFORMAT = ^TFMTOWNS_SND_WAVEFORMAT;
    LPFMTOWNS_SND_WAVEFORMAT = ^TFMTOWNS_SND_WAVEFORMAT;


    //  Olivetti structure

    //      for WAVE_FORMAT_OLIGSM   (0x1000)


    Toligsmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
    end;
    Poligsmwaveformat_tag = ^Toligsmwaveformat_tag;

    TOLIGSMWAVEFORMAT = Toligsmwaveformat_tag;
    POLIGSMWAVEFORMAT = ^TOLIGSMWAVEFORMAT;
    NPOLIGSMWAVEFORMAT = ^TOLIGSMWAVEFORMAT;
    LPOLIGSMWAVEFORMAT = ^TOLIGSMWAVEFORMAT;


    //  Olivetti structure

    //      for WAVE_FORMAT_OLIADPCM   (0x1001)


    Toliadpcmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
    end;
    Poliadpcmwaveformat_tag = ^Toliadpcmwaveformat_tag;

    TOLIADPCMWAVEFORMAT = Toliadpcmwaveformat_tag;
    POLIADPCMWAVEFORMAT = ^TOLIADPCMWAVEFORMAT;
    NPOLIADPCMWAVEFORMAT = ^TOLIADPCMWAVEFORMAT;
    LPOLIADPCMWAVEFORMAT = ^TOLIADPCMWAVEFORMAT;


    //  Olivetti structure

    //      for WAVE_FORMAT_OLICELP   (0x1002)


    Tolicelpwaveformat_tag = record
        wfx: TWAVEFORMATEX;
    end;
    Policelpwaveformat_tag = ^Tolicelpwaveformat_tag;

    TOLICELPWAVEFORMAT = Tolicelpwaveformat_tag;
    POLICELPWAVEFORMAT = ^TOLICELPWAVEFORMAT;
    NPOLICELPWAVEFORMAT = ^TOLICELPWAVEFORMAT;
    LPOLICELPWAVEFORMAT = ^TOLICELPWAVEFORMAT;


    //  Olivetti structure

    //      for WAVE_FORMAT_OLISBC   (0x1003)


    Tolisbcwaveformat_tag = record
        wfx: TWAVEFORMATEX;
    end;
    Polisbcwaveformat_tag = ^Tolisbcwaveformat_tag;

    TOLISBCWAVEFORMAT = Tolisbcwaveformat_tag;
    POLISBCWAVEFORMAT = ^TOLISBCWAVEFORMAT;
    NPOLISBCWAVEFORMAT = ^TOLISBCWAVEFORMAT;
    LPOLISBCWAVEFORMAT = ^TOLISBCWAVEFORMAT;


    //  Olivetti structure

    //      for WAVE_FORMAT_OLIOPR   (0x1004)


    Tolioprwaveformat_tag = record
        wfx: TWAVEFORMATEX;
    end;
    Polioprwaveformat_tag = ^Tolioprwaveformat_tag;

    TOLIOPRWAVEFORMAT = Tolioprwaveformat_tag;
    POLIOPRWAVEFORMAT = ^TOLIOPRWAVEFORMAT;
    NPOLIOPRWAVEFORMAT = ^TOLIOPRWAVEFORMAT;
    LPOLIOPRWAVEFORMAT = ^TOLIOPRWAVEFORMAT;


    //  Crystal Semiconductor IMA ADPCM format

    //      for WAVE_FORMAT_CS_IMAADPCM   (0x0039)


    Tcsimaadpcmwaveformat_tag = record
        wfx: TWAVEFORMATEX;
    end;
    Pcsimaadpcmwaveformat_tag = ^Tcsimaadpcmwaveformat_tag;

    TCSIMAADPCMWAVEFORMAT = Tcsimaadpcmwaveformat_tag;
    PCSIMAADPCMWAVEFORMAT = ^TCSIMAADPCMWAVEFORMAT;
    NPCSIMAADPCMWAVEFORMAT = ^TCSIMAADPCMWAVEFORMAT;
    LPCSIMAADPCMWAVEFORMAT = ^TCSIMAADPCMWAVEFORMAT;

    //==========================================================================;

    //  ACM Wave Filters


    //==========================================================================;


    Twavefilter_tag = record
        cbStruct: DWORD; (* Size of the filter in bytes *)
        dwFilterTag: DWORD; (* filter type *)
        fdwFilter: DWORD; (* Flags for the filter (Universal Dfns) *)
        dwReserved: array [0..5 - 1] of DWORD; (* Reserved for system use *)
    end;
    Pwavefilter_tag = ^Twavefilter_tag;

    TWAVEFILTER = Twavefilter_tag;
    PWAVEFILTER = ^TWAVEFILTER;
    NPWAVEFILTER = ^TWAVEFILTER;
    LPWAVEFILTER = ^TWAVEFILTER;


    Twavefilter_volume_tag = record
        wfltr: TWAVEFILTER;
        dwVolume: DWORD;
    end;
    Pwavefilter_volume_tag = ^Twavefilter_volume_tag;

    TVOLUMEWAVEFILTER = Twavefilter_volume_tag;
    PVOLUMEWAVEFILTER = ^TVOLUMEWAVEFILTER;
    NPVOLUMEWAVEFILTER = ^TVOLUMEWAVEFILTER;
    LPVOLUMEWAVEFILTER = ^TVOLUMEWAVEFILTER;


    Twavefilter_echo_tag = record
        wfltr: TWAVEFILTER;
        dwVolume: DWORD;
        dwDelay: DWORD;
    end;
    Pwavefilter_echo_tag = ^Twavefilter_echo_tag;

    TECHOWAVEFILTER = Twavefilter_echo_tag;
    PECHOWAVEFILTER = ^TECHOWAVEFILTER;
    NPECHOWAVEFILTER = ^TECHOWAVEFILTER;
    LPECHOWAVEFILTER = ^TECHOWAVEFILTER;


    (* ------------------------------------------------------------------------------ *)

    // New RIFF WAVE Chunks


    tag_s_RIFFWAVE_inst = record
        bUnshiftedNote: byte;
        chFineTune: char;
        chGain: char;
        bLowNote: byte;
        bHighNote: byte;
        bLowVelocity: byte;
        bHighVelocity: byte;
    end;
    T_s_RIFFWAVE_inst = tag_s_RIFFWAVE_inst;
    P_s_RIFFWAVE_inst = ^T_s_RIFFWAVE_inst;


    (* Structure definitions *)

    tagEXBMINFOHEADER = record
        bmi: TBITMAPINFOHEADER; (* extended BITMAPINFOHEADER fields *)
        biExtDataOffset: DWORD;
        (* Other stuff will go here *)
        (* ... *)
        (* Format-specific information *)
        (* biExtDataOffset points here *)
    end;
    TEXBMINFOHEADER = tagEXBMINFOHEADER;
    PEXBMINFOHEADER = ^TEXBMINFOHEADER;


    (* Structure definitions *)

    tagJPEGINFOHEADER = record
        (* compression-specific fields *)
        (* these fields are defined for 'JPEG' and 'MJPG' *)
        JPEGSize: DWORD;
        JPEGProcess: DWORD;
        (* Process specific fields *)
        JPEGColorSpaceID: DWORD;
        JPEGBitsPerSample: DWORD;
        JPEGHSubSampling: DWORD;
        JPEGVSubSampling: DWORD;
    end;
    TJPEGINFOHEADER = tagJPEGINFOHEADER;
    PJPEGINFOHEADER = ^TJPEGINFOHEADER;


    // Revert to default packing
    {$PackRecords default}

const
    MSAUDIO1_WFX_EXTRA_BYTES = (sizeof(TMSAUDIO1WAVEFORMAT) - sizeof(TWAVEFORMATEX));
    WMAUDIO2_WFX_EXTRA_BYTES = (sizeof(TWMAUDIO2WAVEFORMAT) - sizeof(TWAVEFORMATEX));
    WMAUDIO3_WFX_EXTRA_BYTES = (sizeof(TWMAUDIO3WAVEFORMAT) - sizeof(TWAVEFORMATEX));


procedure INIT_MMREG_MID(var guid: TGUID; id: USHORT);
function EXTRACT_MMREG_MID(guid: TGUID): USHORT;
function DEFINE_MMREG_MID_GUID(id: USHORT): TGUID;
function IS_COMPATIBLE_MMREG_MID(guid: TGUID): boolean;
procedure INIT_MMREG_PID(var guid: TGUID; id: USHORT);
function EXTRACT_MMREG_PID(guid: TGUID): USHORT;
function DEFINE_MMREG_PID_GUID(id: USHORT): TGUID;
function IS_COMPATIBLE_MMREG_PID(guid: TGUID): boolean;
function DEFINE_WAVEFORMATEX_GUID(x: USHORT): TGUID;
procedure INIT_WAVEFORMATEX_GUID(var Guid: TGUID; x: USHORT);
function EXTRACT_WAVEFORMATEX_ID(Guid: TGUID): USHORT;
function IS_VALID_WAVEFORMATEX_GUID(Guid: TGUID): boolean;


implementation


//{d5a47fa7-6d98-11d1-a21a-00a0c9223196}
procedure INIT_MMREG_MID(var guid: TGUID; id: USHORT);
begin
    guid.Data1 := $d5a47fa7 + id;
    guid.Data2 := $6d98;
    guid.Data3 := $11d1;
    guid.Data4[0] := $a2;
    guid.Data4[1] := $1a;
    guid.Data4[2] := $00;
    guid.Data4[3] := $a0;
    guid.Data4[4] := $c9;
    guid.Data4[5] := $22;
    guid.Data4[6] := $31;
    guid.Data4[7] := $96;
end;



function EXTRACT_MMREG_MID(guid: TGUID): USHORT;
begin
    Result := (guid.Data1 - $d5a47fa7);
end;



function DEFINE_MMREG_MID_GUID(id: USHORT): TGUID;
var
    lGUID: TGUID;
begin
    lGUID.Data1 := $d5a47fa7 + id;
    lGUID.Data2 := $6d98;
    lGUID.Data3 := $11d1;
    lGUID.Data4[0] := $a2;
    lGUID.Data4[1] := $1a;
    lGUID.Data4[2] := $00;
    lGUID.Data4[3] := $a0;
    lGUID.Data4[4] := $c9;
    lGUID.Data4[5] := $22;
    lGUID.Data4[6] := $31;
    lGUID.Data4[7] := $96;
    Result := lGUID;
end;



function IS_COMPATIBLE_MMREG_MID(guid: TGUID): boolean;
begin
    Result := ((guid.Data1 >= $d5a47fa7) and (guid.Data1 < $d5a47fa7 + $ffff) and (guid.Data2 = $6d98) and (guid.Data3 = $11d1) and (guid.Data4[0] = $a2) and (guid.Data4[1] = $1a) and
        (guid.Data4[2] = $00) and (guid.Data4[3] = $a0) and (guid.Data4[4] = $c9) and (guid.Data4[5] = $22) and (guid.Data4[6] = $31) and (guid.Data4[7] = $96));
end;


//{e36dc2ac-6d9a-11d1-a21a-00a0c9223196}
procedure INIT_MMREG_PID(var guid: TGUID; id: USHORT);
begin
    guid.Data1 := $e36dc2ac + id;
    guid.Data2 := $6d9a;
    guid.Data3 := $11d1;
    guid.Data4[0] := $a2;
    guid.Data4[1] := $1a;
    guid.Data4[2] := $00;
    guid.Data4[3] := $a0;
    guid.Data4[4] := $c9;
    guid.Data4[5] := $22;
    guid.Data4[6] := $31;
    guid.Data4[7] := $96;
end;



function EXTRACT_MMREG_PID(guid: TGUID): USHORT;
begin
    Result := (guid.Data1 - $e36dc2ac);
end;



function DEFINE_MMREG_PID_GUID(id: USHORT): TGUID;
var
    lGUID: TGUID;
begin
    lGUID.Data1 := $e36dc2ac + id;
    lGUID.Data2 := $6d9a;
    lGUID.Data3 := $11d1;
    lGUID.Data4[0] := $a2;
    lGUID.Data4[1] := $1a;
    lGUID.Data4[2] := $00;
    lGUID.Data4[3] := $a0;
    lGUID.Data4[4] := $c9;
    lGUID.Data4[5] := $22;
    lGUID.Data4[6] := $31;
    lGUID.Data4[7] := $96;
    Result := lGUID;
end;



function IS_COMPATIBLE_MMREG_PID(guid: TGUID): boolean;
begin
    Result :=
        ((guid.Data1 >= $e36dc2ac) and (guid.Data1 < $e36dc2ac + $ffff) and (guid.Data2 = $6d9a) and (guid.Data3 = $11d1) and (guid.Data4[0] = $a2) and (guid.Data4[1] = $1a) and
        (guid.Data4[2] = $00) and (guid.Data4[3] = $a0) and (guid.Data4[4] = $c9) and (guid.Data4[5] = $22) and (guid.Data4[6] = $31) and (guid.Data4[7] = $96));
end;



function DEFINE_WAVEFORMATEX_GUID(x: USHORT): TGUID;
var
    lGUID: TGUID;
begin
    lGUID.Data1 := x;
    lGUID.Data2 := $0000;
    lGUID.Data3 := $0010;
    lGUID.Data4[0] := $80;
    lGUID.Data4[1] := $00;
    lGUID.Data4[2] := $00;
    lGUID.Data4[3] := $aa;
    lGUID.Data4[4] := $00;
    lGUID.Data4[5] := $38;

    lGUID.Data4[6] := $9b;
    lGUID.Data4[7] := $71;
    Result := lGUID;
end;



procedure INIT_WAVEFORMATEX_GUID(var Guid: TGUID; x: USHORT);
begin
    Guid := KSDATAFORMAT_SUBTYPE_WAVEFORMATEX;
    Guid.Data1 := x;
end;



function EXTRACT_WAVEFORMATEX_ID(Guid: TGUID): USHORT;
begin
    Result := Guid.Data1;
end;



function IS_VALID_WAVEFORMATEX_GUID(Guid: TGUID): boolean;
begin
    Result :=
        ((guid.Data2 = KSDATAFORMAT_SUBTYPE_WAVEFORMATEX.Data2) and (guid.Data3 = KSDATAFORMAT_SUBTYPE_WAVEFORMATEX.Data3) and (guid.Data4[0] = KSDATAFORMAT_SUBTYPE_WAVEFORMATEX.Data4[0]) and
        (guid.Data4[1] = KSDATAFORMAT_SUBTYPE_WAVEFORMATEX.Data4[1]) and (guid.Data4[2] = KSDATAFORMAT_SUBTYPE_WAVEFORMATEX.Data4[2]) and (guid.Data4[3] = KSDATAFORMAT_SUBTYPE_WAVEFORMATEX.Data4[3]) and
        (guid.Data4[4] = KSDATAFORMAT_SUBTYPE_WAVEFORMATEX.Data4[4]) and (guid.Data4[5] = KSDATAFORMAT_SUBTYPE_WAVEFORMATEX.Data4[5]) and (guid.Data4[6] = KSDATAFORMAT_SUBTYPE_WAVEFORMATEX.Data4[6]) and
        (guid.Data4[7] = KSDATAFORMAT_SUBTYPE_WAVEFORMATEX.Data4[7]));

end;


end.
