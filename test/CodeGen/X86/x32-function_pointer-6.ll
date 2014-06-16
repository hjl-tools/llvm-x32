; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O2 -fast-isel | FileCheck %s

%struct.XXXX = type opaque
%struct.htab = type { i8*, i8* (i32)* }

@stdxxx = external global %struct.XXXX*

define void @foo(%struct.htab* nocapture %h) nounwind {
entry:
  br label %while.body.i

while.body.i:                                     ; preds = %while.body.i, %entry
  %high.02.i = phi i32 [ 2, %entry ], [ %high.0.add.i, %while.body.i ]
  %low.01.i = phi i32 [ 0, %entry ], [ %add2.low.0.i, %while.body.i ]
  %sub.i = sub i32 %high.02.i, %low.01.i
  %div.i = lshr i32 %sub.i, 1
  %add.i = add i32 %div.i, %low.01.i
  %cmp1.i = icmp eq i32 %add.i, 0
  %add2.i = add i32 %add.i, 1
  %add2.low.0.i = select i1 %cmp1.i, i32 %add2.i, i32 %low.01.i
  %high.0.add.i = select i1 %cmp1.i, i32 %high.02.i, i32 %add.i
  %cmp.i = icmp eq i32 %add2.low.0.i, %high.0.add.i
  br i1 %cmp.i, label %while.end.i, label %while.body.i

while.end.i:                                      ; preds = %while.body.i
  %cmp5.i = icmp eq i32 %add2.low.0.i, 0
  br i1 %cmp5.i, label %if.then6.i, label %higher_prime_index.exit

if.then6.i:                                       ; preds = %while.end.i
  %0 = load %struct.XXXX*, %struct.XXXX** @stdxxx, align 4, !tbaa !0
  tail call void @bar(%struct.XXXX* %0) nounwind
  br label %higher_prime_index.exit

higher_prime_index.exit:                          ; preds = %while.end.i, %if.then6.i
  %alloc_f = getelementptr inbounds %struct.htab, %struct.htab* %h, i32 0, i32 1
  %1 = load i8* (i32)*, i8* (i32)** %alloc_f, align 4, !tbaa !0
  %call1 = tail call i8* %1(i32 %add2.low.0.i) nounwind
  %p = getelementptr inbounds %struct.htab, %struct.htab* %h, i32 0, i32 0
; CHECK: movl	4(%e{{[^,]*}}), %e[[REG:.*]]
  store i8* %call1, i8** %p, align 4, !tbaa !0
; CHECK: callq	*%r[[REG]]

  ret void
}

declare void @bar(%struct.XXXX*)

!0 = !{!"any pointer", !1}
!1 = !{!"omnipotent char", !2}
!2 = !{!"Simple C/C++ TBAA"}
