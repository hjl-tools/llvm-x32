; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 -fast-isel | FileCheck %s

define void @bar1(i32 %x) nounwind {
entry:
  %0 = inttoptr i32 %x to void ()*
; CHECK: movl	%edi, %e[[REG:.*]]
  tail call void %0() nounwind
; CHECK: jmpq	*%r[[REG]]
  ret void
}

define i8* @bar2(i32 %x) nounwind {
entry:
  %0 = inttoptr i32 %x to i32 ()*
; CHECK: movl	%edi, %e[[REG:.*]]
  %call = tail call i32 %0() nounwind
; CHECK: callq	*%r[[REG]]
  %1 = inttoptr i32 %call to i8*
; CHECK: movl	%eax, %eax
  ret i8* %1
}
