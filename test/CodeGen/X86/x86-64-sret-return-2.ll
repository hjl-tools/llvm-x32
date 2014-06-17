; RUN: llc -mtriple=x86_64-apple-darwin8 < %s | FileCheck %s
; RUN: llc -mtriple=x86_64-pc-linux < %s | FileCheck %s
; RUN: llc -mtriple=x86_64-pc-linux-gnux32 -O0 < %s | FileCheck -check-prefix=X32ABI %s

; This used to crash due to topological sorting issues in selection DAG.
define void @foo(i32* sret %agg.result, i32, i32, i32, i32, i32, void (i32)* %pred) {
entry:
  call void %pred(i32 undef)
  ret void

; CHECK-LABEL: foo:
; CHECK: callq
; CHECK: movq {{.*}}, %rax
; CHECK: ret
; X32ABI-LABEL: foo:
; X32ABI: callq
; X32ABI: movl {{.*}}, %eax
; X32ABI: ret
}
