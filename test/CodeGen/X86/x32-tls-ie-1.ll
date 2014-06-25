; RUN: llc < %s -O2 -mtriple=x86_64-linux-gnux32 | FileCheck %s

@external_ie = external thread_local global [30 x i32]

define i32 @foo(i32 %i) nounwind {
entry:
  %arrayidx = getelementptr inbounds [30 x i32], [30 x i32]* @external_ie, i32 0, i32 %i
  %0 = load i32, i32* %arrayidx, align 4
  ret i32 %0
; CHECK-LABEL:   foo:
; CHECK:       movl %fs:0, %eax
; CHECK-NEXT:  rex
; CHECK-NEXT:  addl external_ie@GOTTPOFF(%rip), %eax
; CHECK-NEXT:  movl (%eax,%edi,4), %eax
; CHECK-NEXT:  ret
}

define i32* @bar(i32 %i) nounwind {
entry:
  %arrayidx = getelementptr inbounds [30 x i32], [30 x i32]* @external_ie, i32 0, i32 %i
  ret i32* %arrayidx
; CHECK-LABEL:   bar:
; CHECK:       movl %fs:0, %eax
; CHECK-NEXT:  rex
; CHECK-NEXT:  addl external_ie@GOTTPOFF(%rip), %eax
; CHECK-NEXT:  leal (%rax,%rdi,4), %eax
; CHECK-NEXT:  ret
}
