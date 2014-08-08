; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 -fast-isel -no-x86-call-frame-opt | FileCheck %s --check-prefix=FAST

%struct.Type = type { [8 x i32] }

define void @foo(%struct.Type* noalias nocapture sret %agg.result, %struct.Type* byval align 8 %C) nounwind uwtable {
entry:
; CHECK:      mov{{l|q}} %{{r|e}}di, %{{r|e}}[[REG0:.*]]
; CHECK-NEXT: movq	[[OFF0:[0-9]*]](%esp), %[[REG1:.*]]
; CHECK-NEXT: movq	%[[REG1]], [[OFF1:[0-9]*]](%esp)
; CHECK:      callq	bar
; CHECK-NEXT: movq	[[OFF0]](%esp), %[[REG1]]
; CHECK-NEXT: movq	%[[REG1]], [[OFF1]](%e[[REG0]])
; CHECK:      movl	%e[[REG0]], %eax

; FAST:      mov{{l|q}} %{{r|e}}di, %{{r|e}}[[REG0:.*]]
; FAST-NEXT: leal	[[OFF0:[0-9]*]](%rsp), %ebp
; FAST-NEXT: movq	(%ebp), %[[REG1:.*]]
; FAST-NEXT: movq	%[[REG1]], (%esp)
; FAST:      callq	bar
; FAST-NEXT: movq	(%ebp), %[[REG1]]
; FAST-NEXT: movq	%[[REG1]], (%e[[REG0]])
; FAST:      movl	%e[[REG0]], %eax
  tail call void @bar(%struct.Type* byval align 8 %C) nounwind
  %0 = bitcast %struct.Type* %agg.result to i8*
  %1 = bitcast %struct.Type* %C to i8*
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %0, i8* %1, i32 32, i32 4, i1 false)
  ret void
}

declare void @bar(%struct.Type* byval align 8)

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i32, i1) nounwind
