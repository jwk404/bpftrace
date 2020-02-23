; ModuleID = 'bpftrace'
source_filename = "bpftrace"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf-pc-linux"

; Function Attrs: nounwind
declare i64 @llvm.bpf.pseudo(i64, i64) #0

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

define i64 @"kprobe:f"(i8*) local_unnamed_addr section "s_kprobe:f_1" {
entry:
  %"@y_val" = alloca i64, align 8
  %"@y_key" = alloca i64, align 8
  %"@x_val" = alloca i64, align 8
  %"@x_key" = alloca i64, align 8
  %1 = getelementptr i8, i8* %0, i64 112
  %arg0 = load volatile i64, i8* %1, align 8
  %2 = bitcast i64* %"@x_key" to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* nonnull %2)
  store i64 0, i64* %"@x_key", align 8
  %3 = bitcast i64* %"@x_val" to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* nonnull %3)
  store i64 %arg0, i64* %"@x_val", align 8
  %pseudo = tail call i64 @llvm.bpf.pseudo(i64 1, i64 1)
  %update_elem = call i64 inttoptr (i64 2 to i64 (i64, i64*, i64*, i64)*)(i64 %pseudo, i64* nonnull %"@x_key", i64* nonnull %"@x_val", i64 0)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* nonnull %2)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* nonnull %3)
  %4 = getelementptr i8, i8* %0, i64 96
  %arg2 = load volatile i64, i8* %4, align 8
  %5 = bitcast i64* %"@y_key" to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* nonnull %5)
  store i64 0, i64* %"@y_key", align 8
  %6 = bitcast i64* %"@y_val" to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* nonnull %6)
  store i64 %arg2, i64* %"@y_val", align 8
  %pseudo1 = call i64 @llvm.bpf.pseudo(i64 1, i64 2)
  %update_elem2 = call i64 inttoptr (i64 2 to i64 (i64, i64*, i64*, i64)*)(i64 %pseudo1, i64* nonnull %"@y_key", i64* nonnull %"@y_val", i64 0)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* nonnull %5)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* nonnull %6)
  ret i64 0
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

attributes #0 = { nounwind }
attributes #1 = { argmemonly nounwind }
