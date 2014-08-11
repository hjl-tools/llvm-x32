; RUN: llc -O2 -mtriple=x86_64-unknown-linux-gnux32 < %s | FileCheck %s

%struct.Foo = type { i32 }
%struct.StringRef = type { i8*, i32 }

define void @bar(%struct.Foo* nocapture %f, %struct.StringRef* nocapture %Str) nounwind uwtable noinline {
entry:
; CHECK:      movq	(%esi), %r[[REG:.*]]
; CHECK:      movl	%e[[REG]], %edi
; CHECK-NEXT: movl	$255, %esi
; CHECK-NEXT:  # kill: %EDX<def> %EDX<kill> %RDX<kill>
; CHECK-NEXT: jmp	memset

  %0 = bitcast %struct.StringRef* %Str to i64*
  %1 = load i64, i64* %0, align 1
  %sroa.store.elt.i = lshr i64 %1, 32
  %2 = trunc i64 %sroa.store.elt.i to i32
  %Length1.i = getelementptr inbounds %struct.Foo, %struct.Foo* %f, i32 0, i32 0
  %3 = load i32, i32* %Length1.i, align 4, !tbaa !0
  %cmp.i = icmp ugt i32 %2, %3
  br i1 %cmp.i, label %foo.exit, label %if.then.i

if.then.i:                                        ; preds = %entry
  %4 = trunc i64 %1 to i32
  %5 = inttoptr i32 %4 to i8*
  tail call void @llvm.memset.p0i8.i32(i8* %5, i8 -1, i32 %2, i32 1, i1 false) nounwind
  br label %foo.exit

foo.exit:                                         ; preds = %entry, %if.then.i
  ret void
}

declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i32, i1) nounwind

!0 = !{!"int", !1}
!1 = !{!"omnipotent char", !2}
!2 = !{!"Simple C/C++ TBAA"}
