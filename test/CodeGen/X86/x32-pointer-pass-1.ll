; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -fast-isel -O2 | FileCheck %s

define i32 @bar(i64 %h.coerce) nounwind uwtable {
entry:
  %0 = trunc i64 %h.coerce to i32
  %1 = inttoptr i32 %0 to i32*
; CHECK: movl	%edi, %edi
  tail call void @xxx(i32* %1) nounwind
  ret i32 0
}

declare void @xxx(i32*)
