{ pkgs
, ... }:

{
#  environment.variables = {
#    GBM_BACKEND = "nvidia-drm";
#    LIBVA_DRIVER_NAME = "nvidia";
#  };

  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
  ];
  programs.atop.atopgpu.enable = true;
  hardware = {
    nvidia = {
      prime = {
        offload = {
          # If this is enabled, then the bus IDs of the NVIDIA and Intel/AMD GPUs have to be specified
          # (hardware.nvidia.prime.nvidiaBusId
          # and hardware.nvidia.prime.intelBusId
          # or hardware.nvidia.prime.amdgpuBusId).
          # I do that in host specific configuration
          enable = true;
          enableOffloadCmd = true;
        };
      };
      nvidiaPersistenced = true; 
      # open = true;
      powerManagement.enable = true;
      modesetting.enable = true;
      nvidiaSettings = true;
    };
    opengl.extraPackages = with pkgs; [nvidia-vaapi-driver];
  };
}
