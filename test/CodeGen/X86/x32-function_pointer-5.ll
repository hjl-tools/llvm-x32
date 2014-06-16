; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 -fast-isel | FileCheck %s

%struct.htab = type { i8*, i8* (i32)* }

define void @foo(%struct.htab* nocapture %h) nounwind {
entry:
  %alloc_f = getelementptr inbounds %struct.htab, %struct.htab* %h, i32 0, i32 1
  %0 = load i8* (i32)*, i8* (i32)** %alloc_f, align 4, !tbaa !0
; CHECK: movl	4(%e{{[^,]*}}), %e[[REG:.*]]
  %call = tail call i8* %0(i32 4) nounwind
; CHECK: callq	*%r[[REG]]
  %p = getelementptr inbounds %struct.htab, %struct.htab* %h, i32 0, i32 0
  store i8* %call, i8** %p, align 4, !tbaa !0
  ret void
}

!0 = !{!"any pointer", !1}
!1 = !{!"omnipotent char", !2}
!2 = !{!"Simple C/C++ TBAA"}
