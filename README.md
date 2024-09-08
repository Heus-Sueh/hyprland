# hyprland &nbsp; [![build-ublue](https://github.com/heus-sueh/hyprland/actions/workflows/build.yml/badge.svg)](https://github.com/heus-sueh/hyprland-blue/actions/workflows/build.yml)

This repository uses the [BlueBuild](https://blue-build.org/) template and creates an opinionated image for the Hyprland Window Manager.
![Hyprland](https://take-me-to.space/YTTwG8KV.png)

> [!CAUTION]
Experimental image, not yet fully ready for daily use; bugs still need to be fixed, and some files need to be added.

## What was changed?
- Set a nice SDDM
- Set a nice Waybar
- Set a nice Rofi
- Add a reasonable suite of tools that are needed to have a working desktop with a wayland compositor 
- Creates an opinionated configuration for Hyprland and tools to work out of the box

## Customization

If you want to add your own customizations on top of this images, you are advised strongly against forking. Instead, create a repo for your own image by using the [BlueBuild template](https://github.com/blue-build/template), then change your `base-image` to this image. This will allow you to apply your customizations to hyprland in a concise and maintainable way, without the need to constantly sync with upstream. 

## Installation

### Available Images

- hyprland
- hyprland-dx
- hyprland-nvidia
- hyprland-dx-nvidia


`dx` images contain developer packages and tools, here are some of the packages includeds: `vscode`, `direnv`, `gh` and `virt-manager` (for virtual machines).
If you want to see the complete list, see this [file](https://github.com/Heus-Sueh/hyprland/blob/main/recipes/modules/developer.yml).

### To rebase an existing atomic Fedora installation to the latest build:

> [!IMPORTANT]
> The **only** supported tag is `latest`.

> [!IMPORTANT]
> The two reboots described below are not optional. During installation, the initial boot into hyprland will provision the required sddm user. This is a one time step, all subsequent boots will succeed.

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/heus-sueh/$IMAGE_NAME:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/heus-sueh/$IMAGE_NAME:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

### Post-install

#### Nvidia
If you are using an nvidia image, run this after installation:

```
ujust configure-nvidia
> Set needed kernel arguments
```

#### Nvidia optimus laptop
If you are using an nvidia image on an optimus laptop, run this after installation:

```
ujust configure-nvidia-optimus
```

## ISO

If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.


```bash
cosign verify --key cosign.pub ghcr.io/heus-sueh/hyprland
```
