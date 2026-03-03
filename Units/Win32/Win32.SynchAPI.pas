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

   Copyright (c) Microsoft Corporation. All rights reserved.
   ApiSet Contract for api-ms-win-core-synch-l1

   This unit consists of the following header files
   File name: synchapi.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit Win32.SynchAPI;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    {$DEFINE _WIN32_WINNT_0x0600}
    {$DEFINE _WIN32_WINNT_0x0400}
    {$DEFINE _WIN32_WINNT_WIN7}

const
    Kernel32_DLL = 'Kernel32.dll';

    // Define the slim R/W lock.
    RTL_SRWLOCK_INIT = 0;

    SRWLOCK_INIT = RTL_SRWLOCK_INIT;


    CREATE_MUTEX_INITIAL_OWNER = $00000001;

    CREATE_EVENT_MANUAL_RESET = $00000001;
    CREATE_EVENT_INITIAL_SET = $00000002;

    CREATE_WAITABLE_TIMER_MANUAL_RESET = $00000001;
    CREATE_WAITABLE_TIMER_HIGH_RESOLUTION = $00000002;

    SYNCHRONIZATION_BARRIER_FLAGS_SPIN_ONLY = $01;
    SYNCHRONIZATION_BARRIER_FLAGS_BLOCK_ONLY = $02;
    SYNCHRONIZATION_BARRIER_FLAGS_NO_DELETE = $04;


    // Run once


    RTL_RUN_ONCE_INIT = 0;   // Static initializer

    INIT_ONCE_STATIC_INIT = RTL_RUN_ONCE_INIT;


    RTL_RUN_ONCE_CHECK_ONLY = $00000001;
    RTL_RUN_ONCE_ASYNC = $00000002;
    RTL_RUN_ONCE_INIT_FAILED = $00000004;

    // Run once flags


    INIT_ONCE_CHECK_ONLY = RTL_RUN_ONCE_CHECK_ONLY;
    INIT_ONCE_ASYNC = RTL_RUN_ONCE_ASYNC;
    INIT_ONCE_INIT_FAILED = RTL_RUN_ONCE_INIT_FAILED;


    // The context stored in the run once structure must leave the following number
    // of low order bits unused.


    RTL_RUN_ONCE_CTX_RESERVED_BITS = 2;

    INIT_ONCE_CTX_RESERVED_BITS = RTL_RUN_ONCE_CTX_RESERVED_BITS;

    RTL_CONDITION_VARIABLE_INIT = 0;
    RTL_CONDITION_VARIABLE_LOCKMODE_SHARED = $1;

    CONDITION_VARIABLE_INIT = RTL_CONDITION_VARIABLE_INIT;

    // Flags for condition variables
    CONDITION_VARIABLE_LOCKMODE_SHARED = RTL_CONDITION_VARIABLE_LOCKMODE_SHARED;


    // Mutant Specific Access Rights

    MUTANT_QUERY_STATE = $0001;

    MUTANT_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or MUTANT_QUERY_STATE);


    SEMAPHORE_MODIFY_STATE = $0002;
    SEMAPHORE_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or $3);


    // Timer Specific Access Rights.


    TIMER_QUERY_STATE = $0001;
    TIMER_MODIFY_STATE = $0002;

    TIMER_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or TIMER_QUERY_STATE or TIMER_MODIFY_STATE);


    TIME_ZONE_ID_UNKNOWN = 0;
    TIME_ZONE_ID_STANDARD = 1;
    TIME_ZONE_ID_DAYLIGHT = 2;

    // Synchronization APIs
    MUTEX_MODIFY_STATE = MUTANT_QUERY_STATE;
    MUTEX_ALL_ACCESS = MUTANT_ALL_ACCESS;

type

    // Define the slim R/W lock.
    TRTL_SRWLOCK = record
        Ptr: PVOID;
    end;
    PRTL_SRWLOCK = ^TRTL_SRWLOCK;

    TSRWLOCK = TRTL_SRWLOCK;
    PSRWLOCK = ^TRTL_SRWLOCK;


    // Define one-time initialization primitive


    TRTL_RUN_ONCE = record
        Ptr: PVOID;
    end;
    PRTL_RUN_ONCE = ^TRTL_RUN_ONCE;


    TINIT_ONCE = TRTL_RUN_ONCE;
    PINIT_ONCE = PRTL_RUN_ONCE;
    LPINIT_ONCE = PRTL_RUN_ONCE;


    // The context stored in the run once structure must leave the following number
    // of low order bits unused.


    PINIT_ONCE_FN = function(
        {_Inout_ } InitOnce: PINIT_ONCE;
        {_Inout_opt_ } Parameter: PVOID;
        {_Outptr_opt_result_maybenull_ } Context: PVOID): WINBOOL; stdcall;


    // Define condition variable
    _RTL_CONDITION_VARIABLE = record
        Ptr: PVOID;
    end;
    TRTL_CONDITION_VARIABLE = _RTL_CONDITION_VARIABLE;
    PRTL_CONDITION_VARIABLE = ^TRTL_CONDITION_VARIABLE;

    TCONDITION_VARIABLE = TRTL_CONDITION_VARIABLE;
    PCONDITION_VARIABLE = ^TCONDITION_VARIABLE;


    // Static initializer for the condition variable


    PTIMERAPCROUTINE = procedure(
        {_In_opt_ } lpArgToCompletionRoutine: LPVOID;
        {_In_     } dwTimerLowValue: DWORD;
        {_In_     } dwTimerHighValue: DWORD); stdcall;


    _RTL_BARRIER = record
        Reserved1: DWORD;
        Reserved2: DWORD;
        Reserved3: array [0..2 - 1] of ULONG_PTR;
        Reserved4: DWORD;
        Reserved5: DWORD;
    end;
    TRTL_BARRIER = _RTL_BARRIER;
    PRTL_BARRIER = ^TRTL_BARRIER;


    TSYNCHRONIZATION_BARRIER = TRTL_BARRIER;
    PSYNCHRONIZATION_BARRIER = PRTL_BARRIER;
    LPSYNCHRONIZATION_BARRIER = PRTL_BARRIER;


    TREASON_CONTEXT = record
        Version: ULONG;
        Flags: DWORD;
        case integer of
            0: (Detailed: record
                    LocalizedReasonModule: HMODULE;
                    LocalizedReasonId: ULONG;
                    ReasonStringCount: ULONG;
                    ReasonStrings: LPWSTR;
                    end;);
            1: (SimpleReasonString: LPWSTR);
    end;
    PREASON_CONTEXT = ^TREASON_CONTEXT;


{$IFDEF  _WIN32_WINNT_0x0600)}

procedure InitializeSRWLock(
{_Out_ } SRWLock : PSRWLOCK
    ) ;stdcall; external Kernel32_DLL;



{ _Releases_exclusive_lock_(*SRWLock)
_Releases_nonreentrant_lock_(*SRWLock)}
procedure ReleaseSRWLockExclusive(
  {_Inout_ }   SRWLock:PSRWLOCK
    ) ;stdcall;  external Kernel32_DLL;





{_Releases_shared_lock_(*SRWLock)
_Releases_nonreentrant_lock_(*SRWLock)}
procedure ReleaseSRWLockShared(
{_Inout_ } SRWLock : PSRWLOCK
    ) ;stdcall;  external Kernel32_DLL;



{_Acquires_exclusive_lock_(*SRWLock)
_Acquires_nonreentrant_lock_(*SRWLock)}
procedure AcquireSRWLockExclusive(
{_Inout_ } SRWLock : PSRWLOCK
    ) ;stdcall; external Kernel32_DLL;



{_Acquires_shared_lock_(*SRWLock)
_Acquires_nonreentrant_lock_(*SRWLock)}
procedure AcquireSRWLockShared(
{_Inout_ } SRWLock : PSRWLOCK
    ) ;stdcall; external Kernel32_DLL;



{_When_(return!=0, _Acquires_exclusive_lock_(*SRWLock))
_When_(return!=0, _Acquires_nonreentrant_lock_(*SRWLock))}
function TryAcquireSRWLockExclusive(
{_Inout_ } SRWLock : PSRWLOCK
    ) :  winbool;stdcall;  external Kernel32_DLL;



{_When_(return!=0, _Acquires_shared_lock_(*SRWLock))
_When_(return!=0, _Acquires_nonreentrant_lock_(*SRWLock))}
function TryAcquireSRWLockShared(
{_Inout_ } SRWLock : PSRWLOCK
    ) :  winbool;stdcall; external Kernel32_DLL;


{$endif}// (_WIN32_WINNT >= 0x0600)

{$IFNDEF _WIN32_WINNT_0x0600}

{_Maybe_raises_SEH_exception_}
procedure InitializeCriticalSection(
{_Out_ } lpCriticalSection : LPCRITICAL_SECTION
    ) stdcall; external Kernel32_DLL;
{$ELSE}

procedure InitializeCriticalSection(
    {_Out_ } lpCriticalSection: LPCRITICAL_SECTION); stdcall; external Kernel32_DLL;

{$ENDIF}// (_WIN32_WINNT < 0x0600)


procedure EnterCriticalSection(
    {_Inout_ } lpCriticalSection: LPCRITICAL_SECTION); stdcall; external Kernel32_DLL;


procedure LeaveCriticalSection(
    {_Inout_ } lpCriticalSection: LPCRITICAL_SECTION); stdcall; external Kernel32_DLL;

{_Must_inspect_result_}
function InitializeCriticalSectionAndSpinCount(
    {_Out_ } lpCriticalSection: LPCRITICAL_SECTION;
    {_In_ } dwSpinCount: DWORD): winbool; stdcall; external Kernel32_DLL;


{$IFDEF  _WIN32_WINNT_0x0600}
function InitializeCriticalSectionEx(
    {_Out_ } lpCriticalSection: LPCRITICAL_SECTION;
    {_In_ } dwSpinCount: DWORD;
    {_In_ } Flags: DWORD): winbool; stdcall; external Kernel32_DLL;

{$ENDIF}// (_WIN32_WINNT >= 0x0600)


function SetCriticalSectionSpinCount(
    {_Inout_ } lpCriticalSection: LPCRITICAL_SECTION;
    {_In_ } dwSpinCount: DWORD): DWORD; stdcall; external Kernel32_DLL;


{$IFDEF _WIN32_WINNT_0x0400}

function TryEnterCriticalSection(
    {_Inout_ } lpCriticalSection: LPCRITICAL_SECTION): winbool; stdcall; external Kernel32_DLL;

{$ENDIF}(* _WIN32_WINNT >= 0x0400 *)


procedure DeleteCriticalSection(
    {_Inout_ } lpCriticalSection: LPCRITICAL_SECTION); stdcall; external Kernel32_DLL;


{$IFDEF _WIN32_WINNT_0x0600}


procedure InitOnceInitialize(
    {_Out_ } InitOnce: PINIT_ONCE); stdcall; external Kernel32_DLL;


function InitOnceExecuteOnce(
    {_Inout_ } InitOnce: PINIT_ONCE;
    {_In_ }InitFn: PINIT_ONCE_FN;
    {_Inout_opt_ } Parameter: PVOID;
    {_Outptr_opt_result_maybenull_ } Context: LPVOID): winbool; stdcall; external Kernel32_DLL;


function InitOnceBeginInitialize(
    {_Inout_ } lpInitOnce: LPINIT_ONCE;
    {_In_ } dwFlags: DWORD;
    {_Out_ } fPending: PWINBOOL;
    {_Outptr_opt_result_maybenull_ } lpContext: LPVOID): winbool; stdcall; external Kernel32_DLL;


function InitOnceComplete(
    {_Inout_ } lpInitOnce: LPINIT_ONCE;
    {_In_ } dwFlags: DWORD;
    {_In_opt_ } lpContext: LPVOID): winbool; stdcall; external Kernel32_DLL;


{$ENDIF}// (_WIN32_WINNT >= 0x0600)

{$IFDEF _WIN32_WINNT_0x0600}

procedure InitializeConditionVariable(
    {_Out_ } ConditionVariable: PCONDITION_VARIABLE); stdcall; external Kernel32_DLL;


procedure WakeConditionVariable(
    {_Inout_ } ConditionVariable: PCONDITION_VARIABLE); stdcall; external Kernel32_DLL;


procedure WakeAllConditionVariable(
    {_Inout_ } ConditionVariable: PCONDITION_VARIABLE); stdcall; external Kernel32_DLL;


function SleepConditionVariableCS(
    {_Inout_ } ConditionVariable: PCONDITION_VARIABLE;
    {_Inout_ } CriticalSection: PCRITICAL_SECTION;
    {_In_ } dwMilliseconds: DWORD): winbool; stdcall; external Kernel32_DLL;


function SleepConditionVariableSRW(
    {_Inout_ } ConditionVariable: PCONDITION_VARIABLE;
    {_Inout_ } SRWLock: PSRWLOCK;
    {_In_ } dwMilliseconds: DWORD;
    {_In_ } Flags: ULONG): winbool; stdcall; external Kernel32_DLL;


{$ENDIF}// (_WIN32_WINNT >= 0x0600)


function SetEvent(
    {_In_ } hEvent: HANDLE): winbool; stdcall; external Kernel32_DLL;


function ResetEvent(
    {_In_ } hEvent: HANDLE): winbool; stdcall; external Kernel32_DLL;


function ReleaseSemaphore(
    {_In_ } hSemaphore: HANDLE;
    {_In_ } lReleaseCount: LONG;
    {_Out_opt_ } lpPreviousCount: LPLONG): winbool; stdcall; external Kernel32_DLL;


function ReleaseMutex(
    {_In_ } hMutex: HANDLE): winbool; stdcall; external Kernel32_DLL;


function WaitForSingleObject(
    {_In_ } hHandle: HANDLE;
    {_In_ } dwMilliseconds: DWORD): DWORD; stdcall; external Kernel32_DLL;


function SleepEx(
    {_In_ } dwMilliseconds: DWORD;
    {_In_ } bAlertable: winbool): DWORD; stdcall; external Kernel32_DLL;


function WaitForSingleObjectEx(
    {_In_ } hHandle: HANDLE;
    {_In_ } dwMilliseconds: DWORD;
    {_In_ } bAlertable: winbool): DWORD; stdcall; external Kernel32_DLL;


function WaitForMultipleObjectsEx(
    {_In_ } nCount: DWORD;
    {_In_reads_(nCount) } lpHandles: PHANDLE;
    {_In_ } bWaitAll: winbool;
    {_In_ } dwMilliseconds: DWORD;
    {_In_ } bAlertable: winbool): DWORD; stdcall; external Kernel32_DLL;


// Synchronization APIs


{_Ret_maybenull_}
function CreateMutexA(
    {_In_opt_ } lpMutexAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } bInitialOwner: winbool;
    {_In_opt_ } lpName: LPCSTR): HANDLE; stdcall; external Kernel32_DLL;


{_Ret_maybenull_}
function CreateMutexW(
    {_In_opt_ } lpMutexAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } bInitialOwner: winbool;
    {_In_opt_ } lpName: LPCWSTR): HANDLE; stdcall; external Kernel32_DLL;


{_Ret_maybenull_}
function OpenMutexW(
    {_In_ } dwDesiredAccess: DWORD;
    {_In_ } bInheritHandle: winbool;
    {_In_ } lpName: LPCWSTR): HANDLE; stdcall; external Kernel32_DLL;


{_Ret_maybenull_}
function CreateEventA(
    {_In_opt_ } lpEventAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } bManualReset: winbool;
    {_In_ } bInitialState: winbool;
    {_In_opt_ } lpName: LPCSTR): HANDLE; stdcall; external Kernel32_DLL;


{_Ret_maybenull_}
function CreateEventW(
    {_In_opt_ } lpEventAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } bManualReset: winbool;
    {_In_ } bInitialState: winbool;
    {_In_opt_ } lpName: LPCWSTR): HANDLE; stdcall; external Kernel32_DLL;


{_Ret_maybenull_}
function OpenEventA(
    {_In_ } dwDesiredAccess: DWORD;
    {_In_ } bInheritHandle: winbool;
    {_In_ } lpName: LPCSTR): HANDLE; stdcall; external Kernel32_DLL;


{_Ret_maybenull_}
function OpenEventW(
    {_In_ } dwDesiredAccess: DWORD;
    {_In_ } bInheritHandle: winbool;
    {_In_ } lpName: LPCWSTR): HANDLE; stdcall; external Kernel32_DLL;


{_Ret_maybenull_}
function OpenSemaphoreW(
    {_In_ } dwDesiredAccess: DWORD;
    {_In_ } bInheritHandle: winbool;
    {_In_ } lpName: LPCWSTR): HANDLE; stdcall; external Kernel32_DLL;


{$IFDEF _WIN32_WINNT_0x0400}


{_Ret_maybenull_}
function OpenWaitableTimerW(
    {_In_ } dwDesiredAccess: DWORD;
    {_In_ } bInheritHandle: winbool;
    {_In_ } lpTimerName: LPCWSTR): HANDLE; stdcall; external Kernel32_DLL;


{$IFDEF _WIN32_WINNT_WIN7}


function SetWaitableTimerEx(
    {_In_ } hTimer: HANDLE;
    {_In_ } lpDueTime: PLARGE_INTEGER;
    {_In_ } lPeriod: LONG;
    {_In_opt_ } pfnCompletionRoutine: PTIMERAPCROUTINE;
    {_In_opt_ } lpArgToCompletionRoutine: LPVOID;
    {_In_opt_ } WakeContext: PREASON_CONTEXT;
    {_In_ } TolerableDelay: ULONG): winbool; stdcall; external Kernel32_DLL;


{$ENDIF}// (_WIN32_WINNT >= _WIN32_WINNT_WIN7)

function SetWaitableTimer(
    {_In_ } hTimer: HANDLE;
    {_In_ } lpDueTime: PLARGE_INTEGER;
    {_In_ } lPeriod: LONG;
    {_In_opt_ } pfnCompletionRoutine: PTIMERAPCROUTINE;
    {_In_opt_ } lpArgToCompletionRoutine: LPVOID;
    {_In_ } fResume: winbool): winbool; stdcall; external Kernel32_DLL;


function CancelWaitableTimer(
    {_In_ } hTimer: HANDLE): winbool; stdcall; external Kernel32_DLL;


{$IFDEF  _WIN32_WINNT_0x0600}

{_Ret_maybenull_}
function CreateMutexExA(
    {_In_opt_ } lpMutexAttributes: LPSECURITY_ATTRIBUTES;
    {_In_opt_ } lpName: LPCSTR;
    {_In_ } dwFlags: DWORD;
    {_In_ } dwDesiredAccess: DWORD): HANDLE; stdcall; external Kernel32_DLL;


{_Ret_maybenull_}
function CreateMutexExW(
    {_In_opt_ } lpMutexAttributes: LPSECURITY_ATTRIBUTES;
    {_In_opt_ } lpName: LPCWSTR;
    {_In_ } dwFlags: DWORD;
    {_In_ } dwDesiredAccess: DWORD): HANDLE; stdcall; external Kernel32_DLL;


{_Ret_maybenull_}
function CreateEventExA(
    {_In_opt_ } lpEventAttributes: LPSECURITY_ATTRIBUTES;
    {_In_opt_ } lpName: LPCSTR;
    {_In_ } dwFlags: DWORD;
    {_In_ } dwDesiredAccess: DWORD): HANDLE; stdcall; external Kernel32_DLL;


{_Ret_maybenull_}
function CreateEventExW(
    {_In_opt_ } lpEventAttributes: LPSECURITY_ATTRIBUTES;
    {_In_opt_ } lpName: LPCWSTR;
    {_In_ } dwFlags: DWORD;
    {_In_ } dwDesiredAccess: DWORD): HANDLE; stdcall; external Kernel32_DLL;


{_Ret_maybenull_}
function CreateSemaphoreExW(
    {_In_opt_ } lpSemaphoreAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } lInitialCount: LONG;
    {_In_ } lMaximumCount: LONG;
    {_In_opt_ } lpName: LPCWSTR;
    {_Reserved_ } dwFlags: DWORD;
    {_In_ } dwDesiredAccess: DWORD): HANDLE; stdcall; external Kernel32_DLL;


{_Ret_maybenull_}
function CreateWaitableTimerExW(
    {_In_opt_ } lpTimerAttributes: LPSECURITY_ATTRIBUTES;
    {_In_opt_ } lpTimerName: LPCWSTR;
    {_In_ } dwFlags: DWORD;
    {_In_ } dwDesiredAccess: DWORD): HANDLE; stdcall; external Kernel32_DLL;


{$ENDIF}// (_WIN32_WINNT >= 0x0600)

{$ENDIF}// (_WIN32_WINNT >= 0x0400) || (_WIN32_WINDOWS > 0x0400)


function EnterSynchronizationBarrier(
    {_Inout_ } lpBarrier: LPSYNCHRONIZATION_BARRIER;
    {_In_ } dwFlags: DWORD): winbool; stdcall; external Kernel32_DLL;


function InitializeSynchronizationBarrier(
    {_Out_ } lpBarrier: LPSYNCHRONIZATION_BARRIER;
    {_In_ } lTotalThreads: LONG;
    {_In_ } lSpinCount: LONG): winbool; stdcall; external Kernel32_DLL;


function DeleteSynchronizationBarrier(
    {_Inout_ } lpBarrier: LPSYNCHRONIZATION_BARRIER): winbool; stdcall; external Kernel32_DLL;


procedure Sleep(
    {_In_ } dwMilliseconds: DWORD); stdcall; external Kernel32_DLL;


function WaitOnAddress(
    {_In_reads_bytes_(AddressSize) } Address: PVOID;
    {_In_reads_bytes_(AddressSize) } CompareAddress: PVOID;
    {_In_ } AddressSize: SIZE_T;
    {_In_opt_ } dwMilliseconds: DWORD): winbool; stdcall; external Kernel32_DLL;


procedure WakeByAddressSingle(
    {_In_ } Address: PVOID); stdcall; external Kernel32_DLL;


procedure WakeByAddressAll(
    {_In_ } Address: PVOID); stdcall; external Kernel32_DLL;


function SignalObjectAndWait(
    {_In_ } hObjectToSignal: HANDLE;
    {_In_ } hObjectToWaitOn: HANDLE;
    {_In_ } dwMilliseconds: DWORD;
    {_In_ } bAlertable: winbool): DWORD; stdcall; external Kernel32_DLL;


function WaitForMultipleObjects(
    {_In_ } nCount: DWORD;
    {_In_reads_(nCount) } lpHandles: PHANDLE;
    {_In_ } bWaitAll: winbool;
    {_In_ } dwMilliseconds: DWORD): DWORD; stdcall; external Kernel32_DLL;


function CreateSemaphoreW(
    {_In_opt_ } lpSemaphoreAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } lInitialCount: LONG;
    {_In_ } lMaximumCount: LONG;
    {_In_opt_ } lpName: LPCWSTR): HANDLE; stdcall; external Kernel32_DLL;


{_Ret_maybenull_}
function CreateWaitableTimerW(
    {_In_opt_ } lpTimerAttributes: LPSECURITY_ATTRIBUTES;
    {_In_ } bManualReset: winbool;
    {_In_opt_ } lpTimerName: LPCWSTR): HANDLE; stdcall; external Kernel32_DLL;


implementation

end.
