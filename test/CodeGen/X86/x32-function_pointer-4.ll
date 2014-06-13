; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -fast-isel -O2 | FileCheck %s

define void @bar1(i64 %h.coerce) nounwind {
entry:
  %0 = trunc i64 %h.coerce to i32
  %1 = inttoptr i32 %0 to i8*
; CHECK: movl	%edi, %edi
  tail call void @xxx1(i8* %1) nounwind
; CHECK: jmp	xxx1
  ret void
}

declare void @xxx1(i8*) nounwind

define i8* @bar2(i64 %h.coerce) nounwind {
entry:
  %0 = trunc i64 %h.coerce to i32
  %1 = inttoptr i32 %0 to i8*
; CHECK: movl	%edi, %edi
  %call = tail call i64 @xxx2(i8* %1) nounwind
; CHECK: callq	xxx2
  %2 = trunc i64 %call to i32
  %3 = inttoptr i32 %2 to i8*
; CHECK: movl	%eax, %eax
  ret i8* %3
}

declare i64 @xxx2(i8*) nounwind

define void @bar3(void ()* nocapture %foo) nounwind {
entry:
  tail call void %foo() nounwind
; CHECK: jmpq	*%{{rdi|rax}}
  ret void
}

define i8* @bar4(i8* ()* nocapture %foo) nounwind {
entry:
  %call = tail call i8* %foo() nounwind
; CHECK: jmpq	*%{{rdi|rax}}
  ret i8* %call
}

define void @bar5() nounwind uwtable {
entry:
  %call = tail call void ()* () @xxx3() nounwind
; CHECK: callq	xxx3
  tail call void %call() nounwind
; CHECK: jmpq	*%rax
  ret void
}

declare void ()* @xxx3()
