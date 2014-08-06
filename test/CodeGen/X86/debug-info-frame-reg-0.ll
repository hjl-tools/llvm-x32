; RUN: llc < %s -filetype=obj | llvm-dwarfdump -debug-dump=info - | FileCheck %s
; Test dwarf frame register
; CHECK: DW_TAG_formal_parameter
; CHECK-NEXT:   DW_AT_location
; CHECK-NEXT:   DW_AT_name
; CHECK-NEXT:   DW_AT_decl_file
; CHECK-NEXT:   DW_AT_decl_line
; CHECK-NEXT:   DW_AT_type{{.*}}{[[TYPE:.*]]}
; CHECK: DW_TAG_formal_parameter
; CHECK-NEXT:   DW_AT_location
; CHECK-NEXT:   DW_AT_name
; CHECK-NEXT:   DW_AT_decl_file
; CHECK-NEXT:   DW_AT_decl_line
; CHECK-NEXT:   DW_AT_type{{.*}}{[[TYPE:.*]]}
; CHECK: DW_TAG_formal_parameter
; CHECK-NEXT:   DW_AT_location
; CHECK-NEXT:   DW_AT_name
; CHECK-NEXT:   DW_AT_decl_file
; CHECK-NEXT:   DW_AT_decl_line
; CHECK-NEXT:   DW_AT_type{{.*}}{[[TYPE:.*]]}
; CHECK: DW_TAG_formal_parameter
; CHECK-NEXT:   DW_AT_location
; CHECK-NEXT:   DW_AT_name
; CHECK-NEXT:   DW_AT_decl_file
; CHECK-NEXT:   DW_AT_decl_line
; CHECK-NEXT:   DW_AT_type{{.*}}{[[TYPE:.*]]}
; CHECK: DW_TAG_formal_parameter
; CHECK-NEXT:   DW_AT_location
; CHECK-NEXT:   DW_AT_name
; CHECK-NEXT:   DW_AT_decl_file
; CHECK-NEXT:   DW_AT_decl_line
; CHECK-NEXT:   DW_AT_type{{.*}}{[[TYPE:.*]]}
; CHECK: DW_TAG_formal_parameter
; CHECK-NEXT:   DW_AT_location
; CHECK-NEXT:   DW_AT_name
; CHECK-NEXT:   DW_AT_decl_file
; CHECK-NEXT:   DW_AT_decl_line
; CHECK-NEXT:   DW_AT_type{{.*}}{[[TYPE:.*]]}
; CHECK: DW_TAG_formal_parameter
; CHECK-NEXT:   DW_AT_location
; CHECK-NEXT:   DW_AT_name
; CHECK-NEXT:   DW_AT_decl_file
; CHECK-NEXT:   DW_AT_decl_line
; CHECK-NEXT:   DW_AT_type{{.*}}{[[TYPE:.*]]}
; CHECK: [[TYPE]]:
; CHECK-NEXT: DW_AT_name {{.*}} "int"

target datalayout = "e-m:e-p:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnux32"

; Function Attrs: nounwind uwtable
define i32 @foo(i32 %i0, i32 %i1, i32 %i2, i32 %i3, i32 %i4, i32 %i5, i32 %i6) #0 !dbg !4 {
entry:
  %i0.addr = alloca i32, align 4
  %i1.addr = alloca i32, align 4
  %i2.addr = alloca i32, align 4
  %i3.addr = alloca i32, align 4
  %i4.addr = alloca i32, align 4
  %i5.addr = alloca i32, align 4
  %i6.addr = alloca i32, align 4
  store i32 %i0, i32* %i0.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i0.addr, metadata !12, metadata !13), !dbg !14
  store i32 %i1, i32* %i1.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i1.addr, metadata !15, metadata !13), !dbg !16
  store i32 %i2, i32* %i2.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i2.addr, metadata !17, metadata !13), !dbg !18
  store i32 %i3, i32* %i3.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i3.addr, metadata !19, metadata !13), !dbg !20
  store i32 %i4, i32* %i4.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i4.addr, metadata !21, metadata !13), !dbg !22
  store i32 %i5, i32* %i5.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i5.addr, metadata !23, metadata !13), !dbg !24
  store i32 %i6, i32* %i6.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i6.addr, metadata !25, metadata !13), !dbg !26
  %0 = load i32, i32* %i6.addr, align 4, !dbg !27
  ret i32 %0, !dbg !28
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!9, !10}
!llvm.ident = !{!11}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, producer: "clang version 3.7.0", isOptimized: false, emissionKind: 1, file: !1, enums: !2, retainedTypes: !2, globals: !2, imports: !2)
!1 = !DIFile(filename: "y.c", directory: "")
!2 = !{}
!4 = distinct !DISubprogram(name: "foo", line: 2, isLocal: false, isDefinition: true, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 3, file: !1, scope: !5, type: !6, variables: !2)
!5 = !DIFile(filename: "y.c", directory: "")
!6 = !DISubroutineType(types: !7)
!7 = !{!8, !8, !8, !8, !8, !8, !8, !8}
!8 = !DIBasicType(tag: DW_TAG_base_type, name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!9 = !{i32 2, !"Dwarf Version", i32 4}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{!"clang version 3.7.0"}
!12 = !DILocalVariable(name: "i0", line: 2, arg: 1, scope: !4, file: !5, type: !8)
!13 = !DIExpression()
!14 = !DILocation(line: 2, column: 10, scope: !4)
!15 = !DILocalVariable(name: "i1", line: 2, arg: 2, scope: !4, file: !5, type: !8)
!16 = !DILocation(line: 2, column: 18, scope: !4)
!17 = !DILocalVariable(name: "i2", line: 2, arg: 3, scope: !4, file: !5, type: !8)
!18 = !DILocation(line: 2, column: 26, scope: !4)
!19 = !DILocalVariable(name: "i3", line: 2, arg: 4, scope: !4, file: !5, type: !8)
!20 = !DILocation(line: 2, column: 34, scope: !4)
!21 = !DILocalVariable(name: "i4", line: 2, arg: 5, scope: !4, file: !5, type: !8)
!22 = !DILocation(line: 2, column: 42, scope: !4)
!23 = !DILocalVariable(name: "i5", line: 2, arg: 6, scope: !4, file: !5, type: !8)
!24 = !DILocation(line: 2, column: 50, scope: !4)
!25 = !DILocalVariable(name: "i6", line: 2, arg: 7, scope: !4, file: !5, type: !8)
!26 = !DILocation(line: 2, column: 58, scope: !4)
!27 = !DILocation(line: 4, column: 10, scope: !4)
!28 = !DILocation(line: 4, column: 3, scope: !4)
