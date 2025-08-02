{ config, pkgs, ... }:

let
    userName = config.userName;
    version = config.homeManagerVersion;
in
{
    home-manager.users.${userName} = {
        home.packages = with pkgs; [
            (
                writeShellApplication {
                    name = "s6.sh";
                    runtimeInputs = [
                        wireplumber
                    ];
                    text = ''
                        wpctl set-volume @DEFAULT_AUDIO_SINK@ 60%


                        # vim: ts=4 sw=4 sts=4 ft=bash et:
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "s8.sh";
                    runtimeInputs = [
                        wireplumber
                    ];
                    text = ''
                        wpctl set-volume @DEFAULT_AUDIO_SINK@ 80%


                        # vim: ts=4 sw=4 sts=4 ft=bash et:
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "setkernel.sh";
                    runtimeInputs = [
                        coreutils
                        curl
                        gnused
                    ];
                    text = ''
                        if (($# != 1)); then
                            exit 1
                        fi

                        OSNIX="$HOME/source/nixos/config/os.nix"
                        KERNEL="linux-$1.tar.xz"

                        cd "$HOME/code/kernel/" || exit 1
                        rm -rf linux-*

                        if (( $(curl -o /dev/null --silent -Iw '%{http_code}' "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/$KERNEL") == 200 )); then
                            curl --remote-name "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/$KERNEL"
                        else
                            if ! curl --remote-name "https://cdn.kernel.org/pub/linux/kernel/v6.x/$KERNEL"; then
                                echo "failed to download kernel archive file for version $1" 1>&2
                                exit 1
                            fi
                        fi

                        chmod a+r "$KERNEL"
                        tar xf "$KERNEL"

                        SHA256=$(curl -s https://cdn.kernel.org/pub/linux/kernel/v6.x/sha256sums.asc | grep -F "linux-$1.tar.xz" | cut -d ' ' -f 1 | tr -d '\s\n')
                        if [[ -z "$SHA256" ]]; then
                            echo "no signature found" 1>&2
                            exit 1
                        fi
                        sed -i -E "/kernelVersion/s/\".+\"/\"$1\"/" "$OSNIX"
                        sed -i -E "/kernelSha256/s/\".+\"/\"$SHA256\"/" "$OSNIX"

                        cd "linux-$1/" || exit 1
                        cp "$HOME/source/nixos/kernel/config" .config


                        # vim: ts=4 sw=4 sts=4 ft=bash et:
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "mountvps.sh";
                    runtimeInputs = [
                        coreutils
                        curl
                        gnused
                        openssh
                    ];
                    text = ''
                        VPS="linode"
                        SSH=$(command -v ssh)
                        TARGETS=("docker" "wireguard" "spider" "transmission")


                        if (($# < 1)) || (($# > 2)); then
                            exit 1
                        fi

                        if (($# == 1)); then
                            TARGET="$1"
                        else
                            TARGET="$2"
                        fi

                        is_unmount=false
                        if (($# == 2)); then
                            if [[ "$1" != "-u" ]]; then
                                echo "unknown option $1"
                                exit 1
                            else
                                is_unmount=true
                            fi
                        fi

                        is_found=false
                        for item in "''${TARGETS[@]}"; do
                            if [[ "$TARGET" == "$item" ]]; then
                                is_found=true
                                break
                            fi
                        done

                        if [[ $is_found != true ]]; then
                            echo "unknown target $TARGET"
                            exit 1
                        fi

                        HEMO=$($SSH -T $VPS pwd)
                        if [[ $TARGET == "transmission" ]]; then
                            $SSH -T $VPS "docker container stop transmission"
                            if [[ $is_unmount == true ]]; then
                                $SSH -T $VPS "umount -f $HEMO/download"
                            else
                                $SSH -T $VPS "mount -t nfs -o vers=4,rsize=1048576,wsize=1048576,hard,fsc,nolock,tcp,async,nocto 10.0.0.2:$HOME/movie/.transmission $HEMO/download"
                            fi
                            $SSH -T $VPS "docker container start transmission"
                        else
                            if [[ $is_unmount == true ]]; then
                                # shellcheck disable=SC2086
                                if [[ -n "$(ssh -T $VPS ls -A $HEMO/$TARGET/)" ]]; then
                                    # shellcheck disable=SC2086
                                    $SSH -T $VPS "umount -f $HEMO/$TARGET"
                                fi
                            else
                                # shellcheck disable=SC2086
                                if [[ -z "$(ssh -T $VPS ls -A $HEMO/$TARGET/)" ]]; then
                                    # shellcheck disable=SC2086
                                    $SSH -T $VPS "mount -t nfs -o vers=4,rsize=1048576,wsize=1048576,hard,fsc,nolock,tcp,async,nocto 10.0.0.2:/export/$TARGET $HEMO/$TARGET"
                                fi
                            fi
                        fi


                        # vim: ts=4 sw=4 sts=4 ft=bash et:
                    '';
                }
            )
        ];

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion = version;
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
