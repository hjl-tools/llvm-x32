; RUN: llc < %s -mcpu=generic -mtriple=x86_64-linux | FileCheck %s
; RUN: llc < %s -mcpu=generic -mtriple=x86_64-linux-gnux32 | FileCheck %s -check-prefix=X32ABI
; CHECK-LABEL: f0:
; CHECK: subq
; CHECK: addq
; X32ABI-LABEL: f0:
; X32ABI: subl
; X32ABI: addl

define x86_fp80 @f0(float %f) nounwind readnone noredzone {
entry:
	%0 = fpext float %f to x86_fp80		; <x86_fp80> [#uses=1]
	ret x86_fp80 %0
}
