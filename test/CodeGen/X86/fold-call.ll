; RUN: llc < %s -march=x86 | FileCheck %s
; RUN: llc < %s -march=x86-64 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-gnux32 | FileCheck %s -check-prefix=X32ABI

; CHECK: test1
; CHECK-NOT: mov
; X32ABI: test1
; X32ABI-NOT: mov

declare void @bar()
define void @test1(i32 %i0, i32 %i1, i32 %i2, i32 %i3, i32 %i4, i32 %i5, void()* %arg) nounwind {
	call void @bar()
	call void %arg()
; X32ABI: movl {{[0-9]+}}(%esp), %e[[REG1:.*]]
; X32ABI: callq *%r[[REG1]]
	ret void
}

; PR14739
; CHECK: test2
; CHECK: mov{{.*}} $0, ([[REGISTER:%[a-z]+]])
; CHECK-NOT: jmp{{.*}} *([[REGISTER]])
; X32ABI: test2
; X32ABI: mov{{.*}} $0, ([[REGISTER:%[a-z]+]])
; X32ABI-NOT: jmp{{.*}} *([[REGISTER]])

%struct.X = type { void ()* }
define void @test2(%struct.X* nocapture %x) {
entry:
  %f = getelementptr inbounds %struct.X, %struct.X* %x, i64 0, i32 0
  %0 = load void ()*, void ()** %f
  store void ()* null, void ()** %f
  tail call void %0()
  ret void
}
