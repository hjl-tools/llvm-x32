; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -fast-isel -O2 | FileCheck %s

define i8* @bar() nounwind {
entry:
  %call = tail call i32 @foo() nounwind
; CHECK: callq	foo
  %0 = inttoptr i32 %call to i8*
; CHECK: movl	%eax, %eax
  ret i8* %0
}

declare i32 @foo()
