{ config, pkgs, ... }:

let
    userName = config.userName;
    vpsName = config.vpsName;
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
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "setkernel.sh";
                    runtimeInputs = [
                        axel
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
                        if ! [[ -d "$HOME/code/kernel/linux-$1" ]]; then
                            rm -rf linux*

                            if (( $(curl -o /dev/null --silent -Iw '%{http_code}' "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/$KERNEL") == 200 )); then
                                axel -n 8 "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/$KERNEL"
                            else
                                if ! axel -n 8 "https://cdn.kernel.org/pub/linux/kernel/v6.x/$KERNEL"; then
                                    echo "failed to download kernel archive file for version $1" 1>&2
                                    exit 1
                                fi
                            fi

                            tar xf "$KERNEL" && rm -f "$KERNEL"
                        fi

                        SHA256=$(curl -s https://cdn.kernel.org/pub/linux/kernel/v6.x/sha256sums.asc | grep -F "linux-$1.tar.xz" | cut -d ' ' -f 1 | tr -d '\s\n')
                        if [[ -z "$SHA256" ]]; then
                            echo "no signature found" 1>&2
                            exit 1
                        fi
                        sed -i -E "/kernelVersion/s/\".+\"/\"$1\"/" "$OSNIX"
                        sed -i -E "/kernelSha256/s/\".+\"/\"$SHA256\"/" "$OSNIX"

                        cd "linux-$1/" || exit 1
                        cp "$HOME/source/nixos/modules/kernel/config" .config
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "mountvps.sh";
                    runtimeInputs = [
                        coreutils
                        gnused
                        openssh
                    ];
                    text = ''
                        VPS="${vpsName}"
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
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "vps.sh";
                    runtimeInputs = [
                        linode-cli
                        openssh
                    ];
                    text = ''
                        VPS="${vpsName}"
                        SSH=$(command -v ssh)


                        function vps_id {
                            linode-cli --suppress-warnings linodes list --json | jq -r '.[].id' | head --lines 1
                        }

                        function vps_df {
                            $SSH -T "$VPS" "df -h -l -t ext4 --output=source,size,used,avail,pcent"
                        }

                        function vps_download {
                            $SSH -T "$VPS" 'cd ~/download/complete/; du --human-readable --all --max-depth 1' | sed 's:\./::' | awk '{ if (! (($2==".") && (NR<=2))) print $0; }'
                        }

                        function vps_transfer {
                            linode-cli --suppress-warnings account transfer --json | jq -r '.[] | (.used | tostring) + "G/" + (.quota | tostring) + "G"'
                        }

                        function vps_reboot {
                            local VPS_ID

                            VPS_ID=$(linode-cli --suppress-warnings linodes list --json | jq -r '.[].id' | head --lines 1)
                            if [[ -n "$VPS_ID" ]]; then
                                linode-cli --suppress-warnings linodes reboot "$VPS_ID"
                            fi
                        }


                        case "$1" in
                            reboot|rb)
                                vps_reboot
                                ;;

                            df)
                                vps_df
                                ;;

                            download|dl)
                                vps_download
                                ;;

                            id)
                                vps_id
                                ;;

                            transfer|tr)
                                vps_transfer
                                ;;

                            *)
                                ;;
                       esac
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "dnstemp.sh";
                    runtimeInputs = [
                        coreutils
                        gnused
                        systemd
                    ];
                    text = ''
                        TEMP="/tmp/dnscrypt-proxy"
                        CONFIG="$HOME/source/vps/dnscrypt-proxy.toml"
                        PROXY="$(nix-instantiate --eval-only --expr '(import <nixpkgs> {}).dnscrypt-proxy.outPath' | sed 's/"//g')/bin/dnscrypt-proxy"
                        [[ -x "$PROXY" ]] || exit 1
                        [[ -f "$CONFIG" ]] || exit 1
                        [[ -d "$TEMP" ]] || mkdir -p $TEMP

                        cp "$CONFIG" "$TEMP/"
                        sudo systemctl stop dnscrypt-proxy.service
                        sudo "$PROXY" -config "$TEMP/dnscrypt-proxy.toml" -child &>/dev/null &
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "post.sh";
                    runtimeInputs = [
                        curl
                    ];
                    text = ''
                        if (($# < 1)); then
                            exit 1;
                        fi
                        curl -F "file=@$1" https://0x0.st
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "matrix.sh";
                    runtimeInputs = [
                        cmatrix
                        curl
                    ];
                    text = ''
                        COLORS=(green red blue yellow cyan magenta)
                        N=$((RANDOM % ''${#COLORS[@]}))

                        cmatrix -a -C "''${COLORS[$N]}"
                        # curl -s -o /dev/null -X GET 'http://127.0.0.1:8080/system/idle'
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "testmsg.sh";
                    runtimeInputs = [
                        curl
                    ];
                    text = ''
                        curl -X POST --header "Content-Type: application/json" --data '{"message": "test"}' http://127.0.0.1:8080/notify
                    '';
                }
            )
        ];
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
