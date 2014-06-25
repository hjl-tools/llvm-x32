; RUN: llc < %s -march=x86-64 -mtriple=x86_64-linux-gnux32 | FileCheck %s
; RUN: llc < %s -march=x86-64 -mtriple=x86_64-linux-gnux32 -fast-isel | FileCheck %s
; RUN: llc < %s -march=x86-64 -mtriple=x86_64-linux-gnux32 -relocation-model=pic | FileCheck -check-prefix=PIC %s
; RUN: llc < %s -march=x86-64 -mtriple=x86_64-linux-gnux32 -relocation-model=pic -fast-isel | FileCheck -check-prefix=PIC %s

@external_gd = external thread_local global i32
@internal_gd = internal thread_local global i32 42

@external_ld = external thread_local(localdynamic) global i32
@internal_ld = internal thread_local(localdynamic) global i32 42

@external_ie = external thread_local(initialexec) global i32
@internal_ie = internal thread_local(initialexec) global i32 42

@external_le = external thread_local(localexec) global i32
@internal_le = internal thread_local(localexec) global i32 42

; ----- no model specified -----

define i32* @f1() {
entry:
  ret i32* @external_gd

  ; Non-PIC code can use initial-exec, PIC code has to use general dynamic.
  ; CHECK-LABEL:   f1:
  ; CHECK:       movl %fs:0, %eax
  ; CHECK-NEXT:  rex
  ; CHECK-NEXT:  addl external_gd@GOTTPOFF(%rip), %eax
  ; PIC-LABEL:    f1:
  ; PIC:       leaq external_gd@TLSGD(%rip), %rdi
  ; PIC-NEXT:  data16
  ; PIC-NEXT:  data16
  ; PIC-NEXT:  rex64
  ; PIC-NEXT:  callq __tls_get_addr@PLT
  ; PIC-NOT:   movl %eax, %eax
}

define i32* @f2() {
entry:
  ret i32* @internal_gd

  ; Non-PIC code can use local exec, PIC code can use local dynamic.
  ; CHECK-LABEL:   f2:
  ; CHECK:       movl %fs:0, %eax
  ; CHECK-NEXT:  leal internal_gd@TPOFF(%rax), %eax
  ; PIC-LABEL:   f2:
  ; PIC:       leaq internal_gd@TLSLD(%rip), %rdi
  ; PIC-NEXT:  callq __tls_get_addr@PLT
  ; PIC-NOT:   movl %eax, %eax
  ; PIC-NEXT:  # kill: %EAX<def> %EAX<kill> %RAX<def>
  ; PIC-NEXT:  leal internal_gd@DTPOFF(%rax), %eax
}


; ----- localdynamic specified -----

define i32* @f3() {
entry:
  ret i32* @external_ld

  ; Non-PIC code can use initial exec, PIC code use local dynamic as specified.
  ; CHECK-LABEL:   f3:
  ; CHECK:       movl %fs:0, %eax
  ; CHECK-NEXT:  rex
  ; CHECK-NEXT:  addl external_ld@GOTTPOFF(%rip), %eax
  ; PIC-LABEL:   f3:
  ; PIC:       leaq external_ld@TLSLD(%rip), %rdi
  ; PIC-NEXT:  callq __tls_get_addr@PLT
  ; PIC-NOT:   movl %eax, %eax
  ; PIC-NEXT:  # kill: %EAX<def> %EAX<kill> %RAX<def>
  ; PIC-NEXT:  leal external_ld@DTPOFF(%rax), %eax
}

define i32* @f4() {
entry:
  ret i32* @internal_ld

  ; Non-PIC code can use local exec, PIC code can use local dynamic.
  ; CHECK-LABEL:   f4:
  ; CHECK:       movl %fs:0, %eax
  ; CHECK-NEXT:  leal internal_ld@TPOFF(%rax), %eax
  ; PIC-LABEL:   f4:
  ; PIC:       leaq internal_ld@TLSLD(%rip), %rdi
  ; PIC-NEXT:  callq __tls_get_addr@PLT
  ; PIC-NOT:   movl %eax, %eax
  ; PIC-NEXT:  # kill: %EAX<def> %EAX<kill> %RAX<def>
  ; PIC-NEXT:  leal internal_ld@DTPOFF(%rax), %eax
}


; ----- initialexec specified -----

define i32* @f5() {
entry:
  ret i32* @external_ie

  ; Non-PIC and PIC code will use initial exec as specified.
  ; CHECK-LABEL:   f5:
  ; CHECK:       movl %fs:0, %eax
  ; CHECK-NEXT:  rex
  ; CHECK-NEXT:  addl external_ie@GOTTPOFF(%rip), %eax
  ; PIC-LABEL:   f5:
  ; PIC:       movl %fs:0, %eax
  ; PIC-NEXT:  rex
  ; PIC-NEXT:  addl external_ie@GOTTPOFF(%rip), %eax
}

define i32* @f6() {
entry:
  ret i32* @internal_ie

  ; Non-PIC code can use local exec, PIC code use initial exec as specified.
  ; CHECK-LABEL:   f6:
  ; CHECK:       movl %fs:0, %eax
  ; CHECK-NEXT:  leal internal_ie@TPOFF(%rax), %eax
  ; PIC-LABEL:   f6:
  ; PIC:       movl %fs:0, %eax
  ; PIC-NEXT:  rex
  ; PIC-NEXT:  addl internal_ie@GOTTPOFF(%rip), %eax
}

define i32 @PR22083() {
entry:
  ret i32 ptrtoint (i32* @external_ie to i32)
  ; CHECK-LABEL: PR22083:
  ; CHECK:       movl %fs:0, %eax
  ; CHECK-NEXT:  rex
  ; CHECK-NEXT:  addl    external_ie@GOTTPOFF(%rip), %eax
  ; PIC-LABEL: PR22083:
  ; PIC:        movl %fs:0, %eax
  ; PIC-NEXT:   rex
  ; PIC-NEXT:   addl    external_ie@GOTTPOFF(%rip), %eax
}


; ----- localexec specified -----

define i32* @f7() {
entry:
  ret i32* @external_le

  ; Non-PIC and PIC code will use local exec as specified.
  ; CHECK-LABEL:   f7:
  ; CHECK:       movl %fs:0, %eax
  ; CHECK-NEXT:  leal external_le@TPOFF(%rax), %eax
  ; PIC-LABEL:   f7:
  ; PIC:       movl %fs:0, %eax
  ; PIC-NEXT:  leal external_le@TPOFF(%rax), %eax
}

define i32* @f8() {
entry:
  ret i32* @internal_le

  ; Non-PIC and PIC code will use local exec as specified.
  ; CHECK-LABEL:   f8:
  ; CHECK:       movl %fs:0, %eax
  ; CHECK-NEXT:  leal internal_le@TPOFF(%rax), %eax
  ; PIC-LABEL:   f8:
  ; PIC:       movl %fs:0, %eax
  ; PIC-NEXT:  leal internal_le@TPOFF(%rax), %eax
}
