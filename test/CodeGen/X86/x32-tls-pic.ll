; RUN: llc < %s -march=x86-64 -mtriple=x86_64-linux-gnux32 -relocation-model=pic | FileCheck %s

@i = thread_local global i32 15
@j = internal thread_local global i32 42
@k = internal thread_local global i32 42

define i32 @f1() {
entry:
	%tmp1 = load i32, i32* @i
	ret i32 %tmp1
}

; CHECK-LABEL: f1:
; CHECK:       leaq i@TLSGD(%rip), %rdi
; CHECK-NEXT:  data16
; CHECK-NEXT:  data16
; CHECK-NEXT:  rex64
; CHECK-NEXT:  callq __tls_get_addr@PLT


@i2 = external thread_local global i32

define i32* @f2() {
entry:
	ret i32* @i
}

; CHECK-LABEL: f2:
; CHECK:       leaq i@TLSGD(%rip), %rdi
; CHECK-NEXT:  data16
; CHECK-NEXT:  data16
; CHECK-NEXT:  rex64
; CHECK-NEXT:  callq __tls_get_addr@PLT



define i32 @f3() {
entry:
	%tmp1 = load i32, i32* @i		; <i32> [#uses=1]
	ret i32 %tmp1
}

; CHECK-LABEL: f3:
; CHECK:       leaq i@TLSGD(%rip), %rdi
; CHECK-NEXT:  data16
; CHECK-NEXT:  data16
; CHECK-NEXT:  rex64
; CHECK-NEXT:  callq __tls_get_addr@PLT


define i32* @f4() nounwind {
entry:
	ret i32* @i
}

; CHECK-LABEL: f4:
; CHECK:       leaq i@TLSGD(%rip), %rdi
; CHECK-NEXT:  data16
; CHECK-NEXT:  data16
; CHECK-NEXT:  rex64
; CHECK-NEXT:  callq __tls_get_addr@PLT


define i32 @f5() nounwind {
entry:
	%0 = load i32, i32* @j, align 4
	%1 = load i32, i32* @k, align 4
	%add = add nsw i32 %0, %1
	ret i32 %add
}

; CHECK-LABEL: f5:
; CHECK:       leaq {{[jk]}}@TLSLD(%rip), %rdi
; CHECK-NEXT:  callq	__tls_get_addr@PLT
; CHECK:       movl {{[jk]}}@DTPOFF(%e
; CHECK-NEXT:  addl {{[jk]}}@DTPOFF(%e
