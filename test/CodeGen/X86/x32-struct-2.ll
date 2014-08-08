; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 -fast-isel | FileCheck %s --check-prefix=FAST

%struct.Type = type { [8 x i32] }

define void @foo(%struct.Type* noalias sret %agg.result) nounwind uwtable {
entry:
; CHECK:      mov{{l|q}} %{{r|e}}di, %{{r|e}}[[REG0:.*]]
; CHECK-NEXT: callq	bar
; CHECK-NEXT: movl	%e[[REG0]], %eax

; FAST:      mov{{l|q}} %{{r|e}}di, %{{r|e}}[[REG0:.*]]
; FAST:      callq	bar
; FAST-NEXT: movl	%e[[REG0]], %eax

  tail call void @bar(%struct.Type* sret %agg.result) nounwind
  ret void
}

declare void @bar(%struct.Type* sret)
