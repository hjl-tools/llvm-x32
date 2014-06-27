; RUN: llc -fast-isel -march=x86 < %s | FileCheck %s
; RUN: llc -fast-isel -mtriple=x86_64-linux-gnux32 < %s | FileCheck %s
; CHECK: %fs:

define i32 @test1(i32 addrspace(257)* %arg) nounwind {
       %tmp = load i32, i32 addrspace(257)* %arg
       ret i32 %tmp
}
