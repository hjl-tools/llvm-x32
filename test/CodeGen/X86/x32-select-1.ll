; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 | FileCheck %s

define void @foo(i32 %is_big_endian, i8* %p, i32* nocapture %size) nounwind {
entry:
  %tobool = icmp ne i32 %is_big_endian, 0
  %cond = select i1 %tobool, i32 (i8*)* @big, i32 (i8*)* @little
  %call = tail call i32 %cond(i8* %p) nounwind
; CHECK: callq	*%r{{[^,]*}}
  store i32 %call, i32* %size, align 4, !tbaa !0
  ret void
}

declare i32 @big(i8*)

declare i32 @little(i8*)

!0 = !{!"int", !1}
!1 = !{!"omnipotent char", !2}
!2 = !{!"Simple C/C++ TBAA"}
