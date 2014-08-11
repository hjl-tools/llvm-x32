; RUN: llc -O2 -mtriple=x86_64-unknown-linux-gnux32 < %s | FileCheck %s

%struct.Foo = type { i8*, i8*, i8* }
%struct.StringRef = type { i8*, i32 }

define void @bar(%struct.Foo* nocapture %f, %struct.StringRef* nocapture %Str) nounwind uwtable {
entry:
; CHECK:      movq	(%esi), %r[[REG:.*]]
; CHECK:      movl	%e{{[^,]*}}, %edi
; CHECK-NEXT: movl	%e[[REG]], %esi
; CHECK-NEXT:  # kill: %EDX<def> %EDX<kill> %RDX<kill>
; CHECK-NEXT: jmp	memmove

  %0 = bitcast %struct.StringRef* %Str to i64*
  %1 = load i64, i64* %0, align 1
  %sroa.store.elt.i = lshr i64 %1, 32
  %2 = trunc i64 %sroa.store.elt.i to i32
  %OutBufEnd.i = getelementptr inbounds %struct.Foo, %struct.Foo* %f, i32 0, i32 1
  %3 = load i8*, i8** %OutBufEnd.i, align 4, !tbaa !0
  %OutBufCur.i = getelementptr inbounds %struct.Foo, %struct.Foo* %f, i32 0, i32 2
  %4 = load i8*, i8** %OutBufCur.i, align 4, !tbaa !0
  %sub.ptr.lhs.cast.i = ptrtoint i8* %3 to i32
  %sub.ptr.rhs.cast.i = ptrtoint i8* %4 to i32
  %sub.ptr.sub.i = sub i32 %sub.ptr.lhs.cast.i, %sub.ptr.rhs.cast.i
  %cmp.i = icmp ugt i32 %2, %sub.ptr.sub.i
  br i1 %cmp.i, label %foo.exit, label %if.then.i

if.then.i:                                        ; preds = %entry
  %5 = trunc i64 %1 to i32
  %6 = inttoptr i32 %5 to i8*
  tail call void @llvm.memmove.p0i8.p0i8.i32(i8* %4, i8* %6, i32 %2, i32 1, i1 false) nounwind
  br label %foo.exit

foo.exit:                                         ; preds = %entry, %if.then.i
  ret void
}

declare void @llvm.memmove.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i32, i1) nounwind

!0 = !{!"any pointer", !1}
!1 = !{!"omnipotent char", !2}
!2 = !{!"Simple C/C++ TBAA"}
