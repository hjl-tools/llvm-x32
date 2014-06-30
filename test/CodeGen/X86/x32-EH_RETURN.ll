; Check that eh_return & unwind_init were properly lowered
; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -verify-machineinstrs | FileCheck %s

; CHECK: test
; CHECK: pushq %rbp
; CHECK: movl %esp, %ebp
; CHECK: popq %rbp
; CHECK: movl %ecx, %esp
; CHECK: retq # eh_return, addr: %ecx
define i8* @test(i32 %a, i8* %b)  {
entry:
  call void @llvm.eh.unwind.init()
  %foo   = alloca i32
  call void @llvm.eh.return.i32(i32 %a, i8* %b)
  unreachable
}

declare void @llvm.eh.return.i32(i32, i8*)
declare void @llvm.eh.unwind.init()

@b = common global i32 0, align 4
@a = common global i32 0, align 4

; PR14750
; This function contains a normal return as well as eh_return.
; CHECK: _Unwind_Resume_or_Rethrow
define i32 @_Unwind_Resume_or_Rethrow() nounwind uwtable ssp {
entry:
  %0 = load i32, i32* @b, align 4
  %tobool = icmp eq i32 %0, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %call = tail call i32 (...) @_Unwind_ForcedUnwind_Phase2() nounwind
  store i32 %call, i32* @a, align 4
  %tobool1 = icmp eq i32 %call, 0
  br i1 %tobool1, label %cond.end, label %cond.true

cond.true:                                        ; preds = %if.end
  tail call void @abort() noreturn nounwind
  unreachable

cond.end:                                         ; preds = %if.end
  tail call void @llvm.eh.return.i32(i32 0, i8* null)
  unreachable
}

declare i32 @_Unwind_ForcedUnwind_Phase2(...)
declare void @abort() noreturn
