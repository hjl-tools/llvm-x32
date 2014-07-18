; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 | FileCheck %s

define void @bar3(void ()* nocapture %foo) nounwind {
entry:
; CHECK-NOT: movl	%edi
  tail call void %foo() nounwind
; CHECK: jmpq	*%rdi
  ret void
}

define i8* @bar4(i8* ()* nocapture %foo) nounwind {
entry:
; CHECK-NOT: movl	%edi
  %call = tail call i8* %foo() nounwind
; CHECK: jmpq	*%rdi
  ret i8* %call
}
