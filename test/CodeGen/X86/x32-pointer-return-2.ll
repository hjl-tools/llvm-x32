; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 | FileCheck %s

define void @bar5() nounwind uwtable {
entry:
  %call = tail call void ()* () @xxx3() nounwind
; CHECK: callq	xxx3
  tail call void %call() nounwind
; CHECK-NOT: movl	%eax
; CHECK: jmpq	*%rax
  ret void
}

declare void ()* @xxx3()
