{
  boot.kernelParams = [
    "log_buf_len=4M"
    "amd_iommu=off"
    "amdgpu.lockup_timeout=5000,10000,10000,5000"
    "amdgpu.gttsize=8128"
    "amdgpu.sched_hw_submission=4"
    "audit=0"
    "libata.noacpi=1"
  ];
}
