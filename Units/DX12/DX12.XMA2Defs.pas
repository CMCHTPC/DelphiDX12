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

   Copyright (c) Microsoft Corporation.  All rights reserved.
   Content:  Constants, data types and functions for XMA2 compressed audio.

   This unit consists of the following header files
   File name: xma2defs.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.XMA2Defs;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.AudioDefs,  // Basic data types and constants for audio work
    Win32.MMREG;

    {$Z4}

(***************************************************************************
 *  Overview
 ***************************************************************************)

    // A typical XMA2 file contains these RIFF chunks:

    // 'fmt' or 'XMA2' chunk (or both): A description of the XMA data's structure
    // and characteristics (length, channels, sample rate, loops, block size, etc).

    // 'seek' chunk: A seek table to help navigate the XMA data.

    // 'data' chunk: The encoded XMA2 data.

    // The encoded XMA2 data is structured as a set of BLOCKS, which contain PACKETS,
    // which contain FRAMES, which contain SUBFRAMES (roughly speaking).  The frames
    // in a file may also be divided into several subsets, called STREAMS.

    // FRAME: A variable-sized segment of XMA data that decodes to exactly 512 mono
    //      or stereo PCM samples.  This is the smallest unit of XMA data that can
    //      be decoded in isolation.  Frames are an arbitrary number of bits in
    //      length, and need not be byte-aligned.  See "XMA frame structure" below.

    // SUBFRAME: A region of bits in an XMA frame that decodes to 128 mono or stereo
    //      samples.  The XMA decoder cannot decode a subframe in isolation; it needs
    //      a whole frame to work with.  However, it can begin emitting the frame's
    //      decoded samples at any one of the four subframe boundaries.  Subframes
    //      can be addressed for seeking and looping purposes.

    // PACKET: A 2Kb region containing a 32-bit header and some XMA frames.  Frames
    //      can (and usually do) span packets.  A packet's header includes the offset
    //      in bits of the first frame that begins within that packet.  All of the
    //      frames that begin in a given packet belong to the same "stream" (see the
    //      Multichannel Audio section below).

    // STREAM: A set of packets within an XMA file that all contain data for the
    //      same mono or stereo component of a PCM file with more than two channels.
    //      The packets comprising a given stream may be interleaved with each other
    //      more or less arbitrarily; see Multichannel Audio.

    // BLOCK: An array of XMA packets; or, to break it down differently, a series of
    //      consecutive XMA frames, padded at the end with reserved data.  A block
    //      must contain at least one 2Kb packet per stream, and it can hold up to
    //      4095 packets (8190Kb), but its size is typically in the 32Kb-128Kb range.
    //      (The size chosen involves a trade-off between memory use and efficiency
    //      of reading from permanent storage.)

    //      XMA frames do not span blocks, so a block is guaranteed to begin with a
    //      set of complete frames, one per stream.  Also, a block in a multi-stream
    //      XMA2 file always contains the same number of samples for each stream;
    //      see Multichannel Audio.

    // The 'data' chunk in an XMA2 file is an array of XMA2WAVEFORMAT.BlockCount XMA
    // blocks, all the same size (as specified in XMA2WAVEFORMAT.BlockSizeInBytes)
    // except for the last one, which may be shorter.


    // MULTICHANNEL AUDIO: the XMA decoder can only decode raw XMA data into either
    // mono or stereo PCM data.  In order to encode a 6-channel file (say), the file
    // must be deinterleaved into 3 stereo streams that are encoded independently,
    // producing 3 encoded XMA data streams.  Then the packets in these 3 streams
    // are interleaved to produce a single XMA2 file, and some information is added
    // to the file so that the original 6-channel audio can be reconstructed at
    // decode time.  This works using the concept of an XMA stream (see above).

    // The frames for all the streams in an XMA file are interleaved in an arbitrary
    // order.  To locate a frame that belongs to a given stream in a given XMA block,
    // you must examine the first few packets in the block.  Here (and only here) the
    // packets are guaranteed to be presented in stream order, so that all frames
    // beginning in packet 0 belong to stream 0 (the first stereo pair), etc.

    // (This means that when decoding multi-stream XMA files, only entire XMA blocks
    // should be submitted to the decoder; otherwise it cannot know which frames
    // belong to which stream.)

    // Once you have one frame that belongs to a given stream, you can find the next
    // one by looking at the frame's 'NextFrameOffsetBits' value (which is stored in
    // its first 15 bits; see XMAFRAME below).  The GetXmaFrameBitPosition function
    // uses this technique.


    // SEEKING IN XMA2 FILES: Here is some pseudocode to find the byte position and
    // subframe in an XMA2 file which will contain sample S when decoded.

    // 1. Traverse the seek table to find the XMA2 block containing sample S. The
    //    seek table is an array of big-endian DWORDs, one per block in the file.
    //    The Nth DWORD is the total number of PCM samples that would be obtained
    //    by decoding the entire XMA file up to the end of block N.  Hence, the
    //    block we want is the first one whose seek table entry is greater than S.
    //    (See the GetXmaBlockContainingSample helper function.)

    // 2. Calculate which frame F within the block found above contains sample S.
    //    Since each frame decodes to 512 samples, this is straightforward.  The
    //    first frame in the block produces samples X to X + 512, where X is the
    //    seek table entry for the prior block.  So F is (S - X) / 512.

    // 3. Find the bit offset within the block where frame F starts.  Since frames
    //    are variable-sized, this can only be done by traversing all the frames in
    //    the block until we reach frame F.  (See GetXmaFrameBitPosition.)

    // 4. Frame F has four 128-sample subframes.  To find the subframe containing S,
    //    we can use the formula (S % 512) / 128.

    // In the case of multi-stream XMA files, sample S is a multichannel sample with
    // parts coming from several frames, one per stream.  To find all these frames,
    // steps 2-4 need to be repeated for each stream N, using the knowledge that the
    // first packets in a block are presented in stream order.  The frame traversal
    // in step 3 must be started at the first frame in the Nth packet of the block,
    // which will be the first frame for stream N.  (And the packet header will tell
    // you the first frame's start position within the packet.)

    // Step 1 can be performed using the GetXmaBlockContainingSample function below,
    // and steps 2-4 by calling GetXmaDecodePositionForSample once for each stream.


const

(***************************************************************************
 *  XMA constants
 ***************************************************************************)


    // Size of the PCM samples produced by the XMA decoder
    XMA_OUTPUT_SAMPLE_BYTES = 2;
    XMA_OUTPUT_SAMPLE_BITS = (XMA_OUTPUT_SAMPLE_BYTES * 8);

    // Size of an XMA packet
    XMA_BYTES_PER_PACKET = 2048;
    XMA_BITS_PER_PACKET = (XMA_BYTES_PER_PACKET * 8);

    // Size of an XMA packet header
    XMA_PACKET_HEADER_BYTES = 4;
    XMA_PACKET_HEADER_BITS = (XMA_PACKET_HEADER_BYTES * 8);

    // Sample blocks in a decoded XMA frame
    XMA_SAMPLES_PER_FRAME = 512;

    // Sample blocks in a decoded XMA subframe
    XMA_SAMPLES_PER_SUBFRAME = 128;

    // Maximum encoded data that can be submitted to the XMA decoder at a time
    XMA_READBUFFER_MAX_PACKETS = 4095;
    XMA_READBUFFER_MAX_BYTES = (XMA_READBUFFER_MAX_PACKETS * XMA_BYTES_PER_PACKET);

    // Maximum size allowed for the XMA decoder's output buffers
    XMA_WRITEBUFFER_MAX_BYTES = (31 * 256);

    // Required byte alignment of the XMA decoder's output buffers
    XMA_WRITEBUFFER_BYTE_ALIGNMENT = 256;

    // Decode chunk sizes for the XMA_PLAYBACK_INIT.subframesToDecode field
    XMA_MIN_SUBFRAMES_TO_DECODE = 1;
    XMA_MAX_SUBFRAMES_TO_DECODE = 8;
    XMA_OPTIMAL_SUBFRAMES_TO_DECODE = 4;

    // LoopCount<255 means finite repetitions; LoopCount=255 means infinite looping
    XMA_MAX_LOOPCOUNT = 254;
    XMA_INFINITE_LOOP = 255;


    WAVE_FORMAT_XMA2 = $166;
    WAVE_FORMAT_XMA = $0165;


    // Values used in the ChannelMask fields below.  Similar to the SPEAKER_xxx
    // values defined in audiodefs.h, but modified to fit in a single byte.

    XMA_SPEAKER_LEFT = $01;
    XMA_SPEAKER_RIGHT = $02;
    XMA_SPEAKER_CENTER = $04;
    XMA_SPEAKER_LFE = $08;
    XMA_SPEAKER_LEFT_SURROUND = $10;
    XMA_SPEAKER_RIGHT_SURROUND = $20;
    XMA_SPEAKER_LEFT_BACK = $40;
    XMA_SPEAKER_RIGHT_BACK = $80;

(***************************************************************************
 *  XMA frame structure
 ***************************************************************************)
    // There is no way to represent the XMA frame as a C struct, since it is a
    // variable-sized string of bits that need not be stored at a byte-aligned
    // position in memory.  This is the layout:

    // XMAFRAME
    // {
    //    LengthInBits: A 15-bit number representing the length of this frame.
    //    XmaData: Encoded XMA data; its size in bits is (LengthInBits - 15).
    // }
    // Size in bits of the frame's initial LengthInBits field


    XMA_BITS_IN_FRAME_LENGTH_FIELD = 15;

    // Special LengthInBits value that marks an invalid final frame
    XMA_FINAL_FRAME_MARKER = $7FFF;


type


(***************************************************************************
 *  XMA format structures
 ***************************************************************************)
    // The currently recommended way to express format information for XMA2 files
    // is the XMA2WAVEFORMATEX structure.  This structure is fully compliant with
    // the WAVEFORMATEX standard and contains all the information needed to parse
    // and manage XMA2 files in a compact way.


    TXMA2WAVEFORMATEX = packed record
        wfx: TWAVEFORMATEX; // Meaning of the WAVEFORMATEX fields here:
        //    wFormatTag;        // Audio format type; always WAVE_FORMAT_XMA2
        //    nChannels;         // Channel count of the decoded audio
        //    nSamplesPerSec;    // Sample rate of the decoded audio
        //    nAvgBytesPerSec;   // Used internally by the XMA encoder
        //    nBlockAlign;       // Decoded sample size; channels * wBitsPerSample / 8
        //    wBitsPerSample;    // Bits per decoded mono sample; always 16 for XMA
        //    cbSize;            // Size in bytes of the rest of this structure (34)
        NumStreams: word; // Number of audio streams (1 or 2 channels each)
        ChannelMask: DWORD; // Spatial positions of the channels in this file,
        // stored as SPEAKER_xxx values (see audiodefs.h)
        SamplesEncoded: DWORD; // Total number of PCM samples the file decodes to
        BytesPerBlock: DWORD; // XMA block size (but the last one may be shorter)
        PlayBegin: DWORD; // First valid sample in the decoded audio
        PlayLength: DWORD; // Length of the valid part of the decoded audio
        LoopBegin: DWORD; // Beginning of the loop region in decoded sample terms
        LoopLength: DWORD; // Length of the loop region in decoded sample terms
        LoopCount: byte; // Number of loop repetitions; 255 = infinite
        EncoderVersion: byte; // Version of XMA encoder that generated the file
        BlockCount: word; // XMA blocks in file (and entries in its seek table)
    end;
    PXMA2WAVEFORMATEX = ^TXMA2WAVEFORMATEX;


    // The legacy XMA format structures are described here for reference, but they
    // should not be used in new content.  XMAWAVEFORMAT was the structure used in
    // XMA version 1 files.  XMA2WAVEFORMAT was used in early XMA2 files; it is not
    // placed in the usual 'fmt' RIFF chunk but in its own 'XMA2' chunk.
    // Used in XMAWAVEFORMAT for per-stream data


    TXMASTREAMFORMAT = packed record
        PsuedoBytesPerSec: DWORD; // Used by the XMA encoder (typo preserved for legacy reasons)
        SampleRate: DWORD; // The stream's decoded sample rate (in XMA2 files,
        LoopStart: DWORD; // Bit offset of the frame containing the loop start
        LoopEnd: DWORD; // Bit offset of the frame containing the loop end.
        SubframeData: byte; // Two 4-bit numbers specifying the exact location of
        //   SubframeEnd: Subframe of the loop end frame where
        //                the loop ends.  Ranges from 0 to 3.
        //   SubframeSkip: Subframes to skip in the start frame to
        //                 reach the loop.  Ranges from 0 to 4.
        Channels: byte; // Number of channels in the stream (1 or 2)
        ChannelMask: word; // Spatial positions of the channels in the stream
    end;
    PXMASTREAMFORMAT = ^TXMASTREAMFORMAT;


    // Legacy XMA1 format structure
    TXMAWAVEFORMAT = packed record
        FormatTag: word; // Audio format type (always WAVE_FORMAT_XMA)
        BitsPerSample: word; // Bit depth (currently required to be 16)
        EncodeOptions: word; // Options for XMA encoder/decoder
        LargestSkip: word; // Largest skip used in interleaving streams
        NumStreams: word; // Number of interleaved audio streams
        LoopCount: byte; // Number of loop repetitions; 255 = infinite
        Version: byte; // XMA encoder version that generated the file.
        XmaStreams: PXMASTREAMFORMAT; // Per-stream format information; the actual
    end;
    PXMAWAVEFORMAT = ^TXMAWAVEFORMAT;


    // Used in XMA2WAVEFORMAT for per-stream data
    TXMA2STREAMFORMAT = packed record
        Channels: byte; // Number of channels in the stream (1 or 2)
        RESERVED: byte; // Reserved for future use
        ChannelMask: word; // Spatial positions of the channels in the stream
    end;
    PXMA2STREAMFORMAT = ^TXMA2STREAMFORMAT;


    // Legacy XMA2 format structure (big-endian byte ordering)
    TXMA2WAVEFORMAT = packed record
        Version: byte; // XMA encoder version that generated the file.
        NumStreams: byte; // Number of interleaved audio streams
        RESERVED: byte; // Reserved for future use
        LoopCount: byte; // Number of loop repetitions; 255 = infinite
        LoopBegin: DWORD; // Loop begin point, in samples
        LoopEnd: DWORD; // Loop end point, in samples
        SampleRate: DWORD; // The file's decoded sample rate
        EncodeOptions: DWORD; // Options for the XMA encoder/decoder
        PsuedoBytesPerSec: DWORD; // Used internally by the XMA encoder
        BlockSizeInBytes: DWORD; // Size in bytes of this file's XMA blocks (except
        // 2Kb, since XMA blocks are arrays of 2Kb packets.
        SamplesEncoded: DWORD; // Total number of PCM samples encoded in this file
        SamplesInSource: DWORD; // Actual number of PCM samples in the source
        // material used to generate this file
        BlockCount: DWORD; // Number of XMA blocks in this file (and hence
        // also the number of entries in its seek table)
        Streams: PXMA2STREAMFORMAT; // Per-stream format information; the actual
        // array length is in the NumStreams field.
    end;
    PXMA2WAVEFORMAT = ^TXMA2WAVEFORMAT;


(***************************************************************************
 *  XMA packet structure (in big-endian form)
 ***************************************************************************)

    TXMA2PACKET = bitpacked record
        FrameCount: 0..63; // Number of XMA frames that begin in this packet
        FrameOffsetInBits: 0..32767; // Bit of XmaData where the first complete frame begins
        PacketMetaData: 0..7; // Metadata stored in the packet (always 1 for XMA2)
        PacketSkipCount: 0..255; // How many packets belonging to other streams must be
        XmaData: array [0..XMA_BYTES_PER_PACKET - sizeof(DWORD) - 1] of byte; // XMA encoded data
    end;
    PXMA2PACKET = ^TXMA2PACKET;


    // E.g. if the first DWORD of a packet is 0x30107902:

    // 001100 000001000001111 001 00000010
    //    |          |         |      |____ Skip 2 packets to find the next one for this stream
    //    |          |         |___________ XMA2 signature (always 001)
    //    |          |_____________________ First frame starts 527 bits into packet
    //    |________________________________ Packet contains 12 frames
    // Helper functions to extract the fields above from an XMA packet.  (Note that
    // the bitfields cannot be read directly on little-endian architectures such as
    // the Intel x86, as they are laid out in big-endian form.)


implementation



function GetXmaPacketFrameCount({__in_bcount(1)} pPacket: pbyte): DWORD; inline;
begin
    Result := (pPacket[0] shr 2);
end;



function GetXmaPacketFirstFrameOffsetInBits({__in_bcount(3)}  pPacket: pbyte): DWORD; inline;
begin
    Result := (DWORD(pPacket[0] and $3) shl 13) or (DWORD(pPacket[1]) shl 5) or (DWORD(pPacket[2]) shr 3);
end;



function GetXmaPacketMetadata({__in_bcount(3)}  pPacket: pbyte): DWORD; inline;
begin
    Result := DWORD(pPacket[2] and $7);
end;



function GetXmaPacketSkipCount({__in_bcount(4)}  pPacket: pbyte): DWORD; inline;
begin
    Result := DWORD(pPacket[3]);
end;


// GetXmaBlockContainingSample: Use a given seek table to find the XMA block
// containing a given decoded sample.  Note that the seek table entries in an
// XMA file are stored in big-endian form and may need to be converted prior
// to calling this function.

function GetXmaBlockContainingSample(nBlockCount: DWORD;                      // Blocks in the file (= seek table entries)
    {__in_ecount(nBlockCount)}   pSeekTable: PDWORD;  // Pointer to the seek table data
    nDesiredSample: DWORD;                   // Decoded sample to locate
    {__out}  pnBlockContainingSample: PDWORD;   // Index of the block containing the sample
    {__out}  pnSampleOffsetWithinBlock: PDWORD  // Position of the sample in this block
    ): HRESULT; inline;
var
    nPreviousTotalSamples: DWORD = 0;
    nBlock: DWORD;
    nTotalSamplesSoFar: DWORD;
begin

    {$IFOPT D+}
    ASSERT(pSeekTable<>nil);
     ASSERT(pnBlockContainingSample<>nil);
     ASSERT(pnSampleOffsetWithinBlock<>nil);
    {$ENDIF}

    for nBlock := 0 to nBlockCount - 1 do
    begin
        nTotalSamplesSoFar := pSeekTable[nBlock];
        if (nTotalSamplesSoFar > nDesiredSample) then
        begin
            pnBlockContainingSample^ := nBlock;
            pnSampleOffsetWithinBlock^ := nDesiredSample - nPreviousTotalSamples;
            Result := S_OK;
            Exit;
        end;
        nPreviousTotalSamples := nTotalSamplesSoFar;
    end;

    Result := E_FAIL;
end;


(***************************************************************************
 *  XMA helper functions
 ***************************************************************************)


// GetXmaFrameLengthInBits: Reads a given frame's LengthInBits field.

function GetXmaFrameLengthInBits(
    {__in_bcount(nBitPosition / 8 + 3)}
    {__in}  pPacket: pbyte;  // Pointer to XMA packet[s] containing the frame
    nBitPosition: DWORD         // Bit offset of the frame within this packet
    ): DWORD; inline;
var
    nRegion: DWORD;
    nBytePosition: DWORD;
    nBitOffset: DWORD;
begin

    nBytePosition := nBitPosition div 8;
    nBitOffset := nBitPosition mod 8;

    if (nBitOffset < 2) then // Only need to read 2 bytes (and might not be safe to read more)
    begin
        nRegion := DWORD(pPacket[nBytePosition + 0]) shl 8 or DWORD(pPacket[nBytePosition + 1]);
        Result := (nRegion shr (1 - nBitOffset)) and $7FFF;  // Last 15 bits

    end
    else // Need to read 3 bytes
    begin
        nRegion := DWORD(pPacket[nBytePosition + 0]) shl 16 or DWORD(pPacket[nBytePosition + 1]) shl 8 or DWORD(pPacket[nBytePosition + 2]);
        Result := (nRegion shr (9 - nBitOffset)) and $7FFF;  // Last 15 bits
    end;
end;


// GetXmaFrameBitPosition: Calculates the bit offset of a given frame within
// an XMA block or set of blocks.  Returns 0 on failure.

function GetXmaFrameBitPosition(
    {__in_bcount(nXmaDataBytes)}  pXmaData: pbyte;  // Pointer to XMA block[s]
    nXmaDataBytes: DWORD;                              // Size of pXmaData in bytes
    nStreamIndex: DWORD;                               // Stream within which to seek
    nDesiredFrame: DWORD                               // Frame sought
    ): DWORD; inline;
var
    pCurrentPacket: pbyte;
    nPacketsExamined: DWORD = 0;
    nFrameCountSoFar: DWORD = 0;
    nFramesToSkip: DWORD;
    nFrameBitOffset: DWORD;
begin

    ASSERT(pXmaData <> nil);
    ASSERT(nXmaDataBytes mod XMA_BYTES_PER_PACKET = 0);

    // Get the first XMA packet belonging to the desired stream, relying on the
    // fact that the first packets for each stream are in consecutive order at
    // the beginning of an XMA block.

    pCurrentPacket := pXmaData + nStreamIndex * XMA_BYTES_PER_PACKET;
    while True do
    begin
        // If we have exceeded the size of the XMA data, return failure
        if (pCurrentPacket + XMA_BYTES_PER_PACKET > pXmaData + nXmaDataBytes) then
        begin
            Result := 0;
            Exit;
        end;

        // If the current packet contains the frame we are looking for...
        if (nFrameCountSoFar + GetXmaPacketFrameCount(pCurrentPacket) > nDesiredFrame) then
        begin
            // See how many frames in this packet we need to skip to get to it
            ASSERT(nDesiredFrame >= nFrameCountSoFar);
            nFramesToSkip := nDesiredFrame - nFrameCountSoFar;

            // Get the bit offset of the first frame in this packet
            nFrameBitOffset := XMA_PACKET_HEADER_BITS + GetXmaPacketFirstFrameOffsetInBits(pCurrentPacket);

            // Advance nFrameBitOffset to the frame of interest
            while (nFramesToSkip > 0) do
            begin
                nFrameBitOffset := nFrameBitOffset + GetXmaFrameLengthInBits(pCurrentPacket, nFrameBitOffset);
                Dec(nFramesToSkip);
            end;

            // The bit offset to return is the number of bits from pXmaData to
            // pCurrentPacket plus the bit offset of the frame of interest
            Result := DWORD(pCurrentPacket - pXmaData) * 8 + nFrameBitOffset;
            Exit;
        end;

        // If we haven't found the right packet yet, advance our counters
        Inc(nPacketsExamined);
        nFrameCountSoFar := nFrameCountSoFar + GetXmaPacketFrameCount(pCurrentPacket);

        // And skip to the next packet belonging to the same stream
        pCurrentPacket := pCurrentPacket + XMA_BYTES_PER_PACKET * (GetXmaPacketSkipCount(pCurrentPacket) + 1);
    end;
end;


// GetLastXmaFrameBitPosition: Calculates the bit offset of the last complete
// frame in an XMA block or set of blocks.

function GetLastXmaFrameBitPosition(
    {__in_bcount(nXmaDataBytes)}  pXmaData: pbyte;  // Pointer to XMA block[s]
    nXmaDataBytes: DWORD;                             // Size of pXmaData in bytes
    nStreamIndex: DWORD                               // Stream within which to seek
    ): DWORD; inline;
var
    pLastPacket: pbyte;
    nBytesToNextPacket: DWORD;
    nFrameBitOffset: DWORD;
    nFramesInLastPacket: DWORD;
begin

    ASSERT(pXmaData <> nil);
    ASSERT(nXmaDataBytes mod XMA_BYTES_PER_PACKET = 0);
    ASSERT(nXmaDataBytes >= XMA_BYTES_PER_PACKET * (nStreamIndex + 1));

    // Get the first XMA packet belonging to the desired stream, relying on the
    // fact that the first packets for each stream are in consecutive order at
    // the beginning of an XMA block.
    pLastPacket := pXmaData + nStreamIndex * XMA_BYTES_PER_PACKET;

    // Search for the last packet belonging to the desired stream
    while True do
    begin
        nBytesToNextPacket := XMA_BYTES_PER_PACKET * (GetXmaPacketSkipCount(pLastPacket) + 1);
        ASSERT(nBytesToNextPacket <> 0);
        if (pLastPacket + nBytesToNextPacket + XMA_BYTES_PER_PACKET > pXmaData + nXmaDataBytes) then
        begin
            break;  // The next packet would extend beyond the end of pXmaData
        end;
        pLastPacket := pLastPacket + nBytesToNextPacket;
    end;

    // The last packet can sometimes have no seekable frames, in which case we
    // have to use the previous one
    if (GetXmaPacketFrameCount(pLastPacket) = 0) then
    begin
        pLastPacket := pLastPacket - nBytesToNextPacket;
    end;

    // Found the last packet.  Get the bit offset of its first frame.
    nFrameBitOffset := XMA_PACKET_HEADER_BITS + GetXmaPacketFirstFrameOffsetInBits(pLastPacket);

    // Traverse frames until we reach the last one
    nFramesInLastPacket := GetXmaPacketFrameCount(pLastPacket);
    while (nFramesInLastPacket > 0) do
    begin
        nFrameBitOffset += GetXmaFrameLengthInBits(pLastPacket, nFrameBitOffset);
        Dec(nFramesInLastPacket);
    end;

    // The bit offset to return is the number of bits from pXmaData to
    // pLastPacket plus the offset of the last frame in this packet.
    Result := DWORD(pLastPacket - pXmaData) * 8 + nFrameBitOffset;
end;


// GetXmaDecodePositionForSample: Obtains the information needed to make the
// decoder generate audio starting at a given sample position relative to the
// beginning of the given XMA block: the bit offset of the appropriate frame,
// and the right subframe within that frame.  This data can be passed directly
// to the XMAPlaybackSetDecodePosition function.

function GetXmaDecodePositionForSample(
    {__in_bcount(nXmaDataBytes)} const pXmaData: pbyte;  // Pointer to XMA block[s]
    nXmaDataBytes: DWORD;                              // Size of pXmaData in bytes
    nStreamIndex: DWORD;                               // Stream within which to seek
    nDesiredSample: DWORD;                             // Sample sought
    {__out}  pnBitOffset: PDWORD;                         // Returns the bit offset within pXmaData of
    // the frame containing the sample sought
    {__out}  pnSubFrame: PDWORD                          // Returns the subframe containing the sample
    ): HRESULT; inline;
var
    nDesiredFrame: DWORD;
    nSubFrame: DWORD;
    nBitOffset: DWORD;
begin
    nDesiredFrame := nDesiredSample div XMA_SAMPLES_PER_FRAME;
    nSubFrame := (nDesiredSample mod XMA_SAMPLES_PER_FRAME) div XMA_SAMPLES_PER_SUBFRAME;
    nBitOffset := GetXmaFrameBitPosition(pXmaData, nXmaDataBytes, nStreamIndex, nDesiredFrame);

    ASSERT(pnBitOffset <> nil);
    ASSERT(pnSubFrame <> nil);

    if (nBitOffset > 0) then
    begin
        pnBitOffset^ := nBitOffset;
        pnSubFrame^ := nSubFrame;
        Result := S_OK;
    end
    else
    begin
        Result := E_FAIL;
    end;
end;


// GetXmaSampleRate: Obtains the legal XMA sample rate (24, 32, 44.1 or 48Khz)
// corresponding to a generic sample rate.

function GetXmaSampleRate(dwGeneralRate: DWORD): DWORD; inline;
var
    dwXmaRate: DWORD = 48000; // Default XMA rate for all rates above 44100Hz
begin

    if (dwGeneralRate <= 24000) then    dwXmaRate := 24000
    else if (dwGeneralRate <= 32000) then dwXmaRate := 32000
    else if (dwGeneralRate <= 44100) then dwXmaRate := 44100;

    Result := dwXmaRate;
end;


// Functions to convert between WAVEFORMATEXTENSIBLE channel masks (combinations
// of the SPEAKER_xxx flags defined in audiodefs.h) and XMA channel masks (which
// are limited to eight possible speaker positions: left, right, center, low
// frequency, side left, side right, back left and back right).

function GetStandardChannelMaskFromXmaMask(bXmaMask: byte): DWORD; inline;
var
    dwStandardMask: DWORD = 0;
begin

    if ((bXmaMask and XMA_SPEAKER_LEFT) = XMA_SPEAKER_LEFT) then    dwStandardMask := dwStandardMask or SPEAKER_FRONT_LEFT;
    if ((bXmaMask and XMA_SPEAKER_RIGHT) = XMA_SPEAKER_RIGHT) then    dwStandardMask := dwStandardMask or SPEAKER_FRONT_RIGHT;
    if ((bXmaMask and XMA_SPEAKER_CENTER) = XMA_SPEAKER_CENTER) then    dwStandardMask := dwStandardMask or SPEAKER_FRONT_CENTER;
    if ((bXmaMask and XMA_SPEAKER_LFE) = XMA_SPEAKER_LFE) then    dwStandardMask := dwStandardMask or SPEAKER_LOW_FREQUENCY;
    if ((bXmaMask and XMA_SPEAKER_LEFT_SURROUND) = XMA_SPEAKER_LEFT_SURROUND) then  dwStandardMask := dwStandardMask or SPEAKER_SIDE_LEFT;
    if ((bXmaMask and XMA_SPEAKER_RIGHT_SURROUND) = XMA_SPEAKER_RIGHT_SURROUND) then dwStandardMask := dwStandardMask or SPEAKER_SIDE_RIGHT;
    if ((bXmaMask and XMA_SPEAKER_LEFT_BACK) = XMA_SPEAKER_LEFT_BACK) then  dwStandardMask := dwStandardMask or SPEAKER_BACK_LEFT;
    if ((bXmaMask and XMA_SPEAKER_RIGHT_BACK) = XMA_SPEAKER_RIGHT_BACK) then  dwStandardMask := dwStandardMask or SPEAKER_BACK_RIGHT;

    Result := dwStandardMask;
end;



function GetXmaChannelMaskFromStandardMask(dwStandardMask: DWORD): byte; inline;
var
    bXmaMask: byte = 0;
begin

    if ((dwStandardMask and SPEAKER_FRONT_LEFT) = SPEAKER_FRONT_LEFT) then   bXmaMask := bXmaMask or XMA_SPEAKER_LEFT;
    if ((dwStandardMask and SPEAKER_FRONT_RIGHT) = SPEAKER_FRONT_RIGHT) then   bXmaMask := bXmaMask or XMA_SPEAKER_RIGHT;
    if ((dwStandardMask and SPEAKER_FRONT_CENTER) = SPEAKER_FRONT_CENTER) then  bXmaMask := bXmaMask or XMA_SPEAKER_CENTER;
    if ((dwStandardMask and SPEAKER_LOW_FREQUENCY) = SPEAKER_LOW_FREQUENCY) then  bXmaMask := bXmaMask or XMA_SPEAKER_LFE;
    if ((dwStandardMask and SPEAKER_SIDE_LEFT) = SPEAKER_SIDE_LEFT) then    bXmaMask := bXmaMask or XMA_SPEAKER_LEFT_SURROUND;
    if ((dwStandardMask and SPEAKER_SIDE_RIGHT) = SPEAKER_SIDE_RIGHT) then    bXmaMask := bXmaMask or XMA_SPEAKER_RIGHT_SURROUND;
    if ((dwStandardMask and SPEAKER_BACK_LEFT) = SPEAKER_BACK_LEFT) then    bXmaMask := bXmaMask or XMA_SPEAKER_LEFT_BACK;
    if ((dwStandardMask and SPEAKER_BACK_RIGHT) = SPEAKER_BACK_RIGHT) then    bXmaMask := bXmaMask or XMA_SPEAKER_RIGHT_BACK;

    Result := bXmaMask;
end;



function XMASWAP2BYTES(n: word): word;
begin
    Result := ((((n) shr 8) or (((n) and $ff) shl 8)));
end;



function XMASWAP4BYTES(n: DWORD): DWORD;
begin
    Result := (((n) shr 24 or (n) shl 24 or ((n) and $ff00) shl 8 or ((n) and $ff0000) shr 8));
end;

// LocalizeXma2Format: Modifies a XMA2WAVEFORMATEX structure in place to comply
// with the current platform's byte-ordering rules (little- or big-endian).

function LocalizeXma2Format({__inout}  pXma2Format: PXMA2WAVEFORMATEX): HRESULT; inline;
begin

    if (pXma2Format^.wfx.wFormatTag = WAVE_FORMAT_XMA2) then
    begin
        Result := S_OK;

    end
    else if (XMASWAP2BYTES(pXma2Format^.wfx.wFormatTag) = WAVE_FORMAT_XMA2) then
    begin
        pXma2Format^.wfx.wFormatTag := XMASWAP2BYTES(pXma2Format^.wfx.wFormatTag);
        pXma2Format^.wfx.nChannels := XMASWAP2BYTES(pXma2Format^.wfx.nChannels);
        pXma2Format^.wfx.nSamplesPerSec := XMASWAP4BYTES(pXma2Format^.wfx.nSamplesPerSec);
        pXma2Format^.wfx.nAvgBytesPerSec := XMASWAP4BYTES(pXma2Format^.wfx.nAvgBytesPerSec);
        pXma2Format^.wfx.nBlockAlign := XMASWAP2BYTES(pXma2Format^.wfx.nBlockAlign);
        pXma2Format^.wfx.wBitsPerSample := XMASWAP2BYTES(pXma2Format^.wfx.wBitsPerSample);
        pXma2Format^.wfx.cbSize := XMASWAP2BYTES(pXma2Format^.wfx.cbSize);
        pXma2Format^.NumStreams := XMASWAP2BYTES(pXma2Format^.NumStreams);
        pXma2Format^.ChannelMask := XMASWAP4BYTES(pXma2Format^.ChannelMask);
        pXma2Format^.SamplesEncoded := XMASWAP4BYTES(pXma2Format^.SamplesEncoded);
        pXma2Format^.BytesPerBlock := XMASWAP4BYTES(pXma2Format^.BytesPerBlock);
        pXma2Format^.PlayBegin := XMASWAP4BYTES(pXma2Format^.PlayBegin);
        pXma2Format^.PlayLength := XMASWAP4BYTES(pXma2Format^.PlayLength);
        pXma2Format^.LoopBegin := XMASWAP4BYTES(pXma2Format^.LoopBegin);
        pXma2Format^.LoopLength := XMASWAP4BYTES(pXma2Format^.LoopLength);
        pXma2Format^.BlockCount := XMASWAP2BYTES(pXma2Format^.BlockCount);
        Result := S_OK;
    end
    else
    begin
        Result := E_FAIL; // Not a recognizable XMA2 format
    end;
end;


end.
