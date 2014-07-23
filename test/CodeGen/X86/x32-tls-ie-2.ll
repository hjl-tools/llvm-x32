; RUN: llc < %s -O2 -mtriple=x86_64-linux-gnux32 -verify-machineinstrs | FileCheck %s

@i32 = external thread_local global i32

define i32 @bar() nounwind {
entry:
  %0 = load i32, i32* @i32
  ret i32 %0
; CHECK-LABEL:   bar:
; X32FIXME: We should generate:
; X32FIXME:  movq i32@GOTTPOFF(%rip), %rax
; X32FIXME-NEXT:  movl %fs:(%rax), %eax
; X32FIXME-NEXT:  ret
; CHECK-NOT:  movl i32@GOTTPOFF(%rip), %eax
; CHECK-NOT:  movl %fs:(%eax), %eax
}
