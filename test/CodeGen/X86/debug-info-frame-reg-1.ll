; RUN: llc < %s -filetype=obj | llvm-dwarfdump -debug-dump=info - | FileCheck %s
; Test dwarf frame register
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
define i32 @foo(i32 %i) #0 !dbg !4 {
entry:
  %i.addr = alloca i32, align 4
  store i32 %i, i32* %i.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i.addr, metadata !15, metadata !16), !dbg !17
  %0 = load i32, i32* %i.addr, align 4, !dbg !18
  ret i32 %0, !dbg !19
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind uwtable
define i32 @main() #0 !dbg !9 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval
  call void @llvm.dbg.declare(metadata i32* %i, metadata !20, metadata !16), !dbg !21
  store i32 20, i32* %i, align 4, !dbg !21
  %0 = load i32, i32* %i, align 4, !dbg !22
  %call = call i32 @foo(i32 %0), !dbg !23
  ret i32 %call, !dbg !24
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!12, !13}
!llvm.ident = !{!14}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, producer: "clang version 3.7.0", isOptimized: false, emissionKind: 1, file: !1, enums: !2, retainedTypes: !2, globals: !2, imports: !2)
!1 = !DIFile(filename: "x.c", directory: "")
!2 = !{}
!4 = distinct !DISubprogram(name: "foo", line: 2, isLocal: false, isDefinition: true, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 3, file: !1, scope: !5, type: !6, variables: !2)
!5 = !DIFile(filename: "x.c", directory: "")
!6 = !DISubroutineType(types: !7)
!7 = !{!8, !8}
!8 = !DIBasicType(tag: DW_TAG_base_type, name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!9 = distinct !DISubprogram(name: "main", line: 8, isLocal: false, isDefinition: true, isOptimized: false, unit: !0, scopeLine: 9, file: !1, scope: !5, type: !10, variables: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!8}
!12 = !{i32 2, !"Dwarf Version", i32 4}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{!"clang version 3.7.0"}
!15 = !DILocalVariable(name: "i", line: 2, arg: 1, scope: !4, file: !5, type: !8)
!16 = !DIExpression()
!17 = !DILocation(line: 2, column: 10, scope: !4)
!18 = !DILocation(line: 4, column: 10, scope: !4)
!19 = !DILocation(line: 4, column: 3, scope: !4)
!20 = !DILocalVariable(name: "i", line: 10, scope: !9, file: !5, type: !8)
!21 = !DILocation(line: 10, column: 7, scope: !9)
!22 = !DILocation(line: 11, column: 15, scope: !9)
!23 = !DILocation(line: 11, column: 10, scope: !9)
!24 = !DILocation(line: 11, column: 3, scope: !9)
