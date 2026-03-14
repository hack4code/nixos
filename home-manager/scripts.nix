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
                    name = "setkernel.sh";
                    runtimeInputs = [
                        coreutils
                        curl
                        gnused
                        gnutar
                        gnugrep
                        nix-direnv
                    ];
                    text = ''
                        function panic {
                            echo "$*" 1>&2
                            exit 1
                        }


                        if (($# != 1)); then
                            panic 'kernel version not found'
                        fi

                        v_major=$(echo "$1" | cut -d '.' -f 1)

                        CURL="${pkgs.curl}/bin/curl"

                        kernel_nix_file="$HOME/source/nixos/config/kernel.nix"
                        kernel_config_file="$HOME/source/nixos/modules/kernel/config"

                        dest="$HOME/code/kernel/"
                        cd "$dest/" || panic "$dest not exist"

                        if [[ -d "$dest/linux-$1" ]]; then
                            exit 0
                        fi

                        if ! [[ -f .envrc ]]; then
                            echo "use flake kernel#default" > .envrc
                            direnv allow
                        fi

                        rm -rf linux*

                        kernel_tuna="linux-$1.tar.gz"
                        kernel_url_tuna="https://mirrors.tuna.tsinghua.edu.cn/kernel/v''${v_major}.x/$kernel_tuna"

                        kernel_github="v$1.tar.gz"
                        kernel_url_github="https://github.com/torvalds/linux/archive/refs/tags/$kernel_github"

                        kernel_cdn="linux-$1.tar.xz"
                        kernel_url_cdn="https://cdn.kernel.org/pub/linux/kernel/v''${v_major}.x/$kernel_cdn"

                        if (( $($CURL -o /dev/null --silent -Iw '%{http_code}' "$kernel_url_tuna") == 200 )); then
                            $CURL -O -L --retry 8 "$kernel_url_tuna"
                            if ! [[ -f $kernel_tuna ]]; then
                                panic "$kernel_tuna not exist"
                            fi

                            tar xzf "$kernel_tuna" && rm -f "$kernel_tuna"

                            kernel_hash=$($CURL -s "https://cdn.kernel.org/pub/linux/kernel/v''${v_major}.x/sha256sums.asc" | grep -F "linux-$1.tar.gz" | cut -d ' ' -f 1 | tr -d '\s\n')
                            if [[ -z "$kernel_hash" ]]; then
                                panic 'no sha256 signature found'
                            fi
                            kernel_url="$kernel_url_tuna"
                        elif (( $($CURL -o /dev/null --silent -Iw '%{http_code}' "$kernel_url_cdn") == 200 )); then
                            $CURL -O -L --retry 8 "$kernel_url_cdn"
                            if ! [[ -f $kernel_cdn ]]; then
                                panic "$kernel_cdn not exist"
                            fi

                            tar xJf "$kernel_cdn" && rm -f "$kernel_cdn"

                            kernel_hash=$($CURL -s "https://cdn.kernel.org/pub/linux/kernel/v''${v_major}.x/sha256sums.asc" | grep -F "linux-$1.tar.xz" | cut -d ' ' -f 1 | tr -d '\s\n')
                            if [[ -z "$kernel_hash" ]]; then
                                panic 'no sha256 signature found'
                            fi
                            kernel_url="$kernel_url_cdn"
                        elif (( $($CURL -o /dev/null --silent -Iw '%{http_code}' "$kernel_url_github") == 200 )); then
                            $CURL -O -L --retry 8 --proxy socks5h://10.0.0.1:1080 "$kernel_url_github"
                            if ! [[ -f $kernel_github ]]; then
                                panic "$kernel_github not exist"
                            fi

                            tar xzf "$kernel_github" && rm -f "$kernel_github"

                            kernel_url="$kernel_url_github"
                            kernel_hash=$(nix hash path "linux-$1")
                        else
                            panic "kernel $1 not found"
                        fi

                        sed -i -E "/kernelVersion/s/\".+\"/\"$1\"/" "$kernel_nix_file"
                        sed -i -E "/kernelHash/s/\".+\"/\"$kernel_hash\"/" "$kernel_nix_file"
                        sed -i -E "/kernelUrl/s;\".+\";\"$kernel_url\";" "$kernel_nix_file"

                        cd "linux-$1/" || panic "linux-$1/ not exist"
                        cp "$kernel_config_file" .config
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
                        SSH="${pkgs.openssh}/bin/ssh"
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
                        SSH="${pkgs.openssh}/bin/ssh"


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
                    name = "dnstmp.sh";
                    runtimeInputs = [
                        coreutils
                        gnused
                        systemd
                    ];
                    text = ''
                        function panic {
                            echo "$*" 1>&2
                            exit 1
                        }

                        temp='/tmp/dnscrypt-proxy'
                        config="$HOME/source/nixos/extra/vps/dnscrypt-proxy.toml"
                        proxy="$(nix-instantiate --eval-only --expr '(import <nixpkgs> {}).dnscrypt-proxy.outPath' | sed 's/"//g')/bin/dnscrypt-proxy"
                        log='/tmp/dnscrypt-proxy.log'

                        [[ -x "$proxy" ]] || panic "$proxy not found"
                        [[ -f $config ]] || panic "$config not found"
                        [[ -d $temp ]] || mkdir -p $temp

                        cp "$config" "$temp/"
                        sudo systemctl stop dnscrypt-proxy.service
                        nohup sudo "$proxy" -config "$temp/dnscrypt-proxy.toml" -child &>"$log" &
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "post.sh";
                    runtimeInputs = [
                        curl
                    ];
                    text =
                    let
                        curl = "${pkgs.curl}/bin/curl";
                    in
                    ''
                        function panic {
                            echo "$*" 1>&2
                            exit 1
                        }


                        if (($# < 1)); then
                            panic 'no file found'
                        fi

                        ${curl} -F "\"file=@$1\"" https://0x0.st
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
                    text =
                    let
                        curl = "${pkgs.curl}/bin/curl";
                        cmatrix = "${pkgs.cmatrix}/bin/cmatrix";
                    in
                    ''
                        COLORS=(green red blue yellow cyan magenta)
                        N=$((RANDOM % ''${#COLORS[@]}))

                        ${cmatrix} -a -C "''${COLORS[$N]}"
                        # ${curl} -s -o /dev/null -X GET 'http://127.0.0.1:8080/system/idle'
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "testmsg";
                    runtimeInputs = [
                        curl
                    ];
                    text =
                    let
                        curl = "${pkgs.curl}/bin/curl";
                    in
                    ''
                        ${curl} -X POST --header "Content-Type: application/json" --data '{"message": "test", "icon": "notification-active"}' http://127.0.0.1:8080/notify
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "nu";
                    runtimeInputs = [
                        gnumake
                    ];
                    text =
                    let
                        make = "${pkgs.gnumake}/bin/make";
                    in
                    ''
                        cd "$HOME/source/nixos/"
                        ${make} update
                        cd -
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "ns";
                    runtimeInputs = [
                        gnumake
                    ];
                    text =
                    let
                        make = "${pkgs.gnumake}/bin/make";
                    in
                    ''
                        cd "$HOME/source/nixos/"
                        ${make} switch
                        cd -
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "nr";
                    text = ''
                        nix-store --verify --check-contents --repair
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "nl";
                    text = ''
                        nixos-rebuild list-generations
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "ng";
                    text = ''
                        nix-collect-garbage -d
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "nd";
                    runtimeInputs = [
                        coreutils
                        jq
                    ];
                    text = ''
                        if (($# == 1)); then
                            sudo nix-env --delete-generations "$1" --profile /nix/var/nix/profiles/system
                            exit
                        fi

                        if (($# == 2)); then
                            # shellcheck disable=SC2046
                            sudo nix-env --delete-generations $(seq "$1" "$2" | tr '\n' ' ' | sed -E 's/\s+$//') --profile /nix/var/nix/profiles/system
                            exit
                        fi

                        N=$(nixos-rebuild list-generations --json | jq 'length')
                        if ((N < 3)); then
                            exit
                        fi

                        BEGIN=$(nixos-rebuild list-generations --json | jq -r '.[].generation' | sort -n | head -n 1)
                        END=$(nixos-rebuild list-generations --json | jq -r '.[].generation' | sort -n | head -n -2 | tail -n 1)
                        if ((BEGIN == END)); then
                            sudo nix-env --delete-generations "$BEGIN" --profile /nix/var/nix/profiles/system
                        else
                            sudo nix-env --delete-generations $(seq --separator=' ' "$BEGIN" "$END") --profile /nix/var/nix/profiles/system
                        fi
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "pp";
                    text = ''
                        function panic {
                            echo "$*" 1>&2
                            exit 1
                        }


                        if (($# != 1)); then
                            panic "need package name"
                        fi

                        nix-instantiate --quiet --eval-only --expr "(import <nixpkgs> {}).$1.outPath" | sed 's/"//g'
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "sp";
                    text = ''
                        function panic {
                            echo "$*" 1>&2
                            exit 1
                        }


                        if (($# != 1)); then
                            panic "need package name"
                        fi

                        nix search --quiet --offline nixpkgs "$1" 2>/dev/null
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "bp";
                    text = ''
                        function panic {
                            echo "$*" 1>&2
                            exit 1
                        }


                        if (($# != 1)); then
                            panic 'need bin name'
                        fi

                        if ! [[ -h "$(command -v "$1")" ]]; then
                            panic 'not a link'
                        fi

                        readlink "$(command -v "$1")" | cut -d / -f 4 | cut -d - -f 2
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "color.sh";
                    runtimeInputs = [
                        coreutils
                        ncurses
                    ];
                    text =
                    let
                        tput = "${pkgs.ncurses}/bin/tput";
                    in
                    ''
                        function panic {
                            echo "$*" 1>&2
                            exit 1
                        }


                        if (($# != 1)); then
                            panic "please give the color value!"
                        fi

                        ${tput} setaf "$1"
                        echo "Hello World!"
                    '';
                }
            )
            (
                writeShellApplication {
                    name = "open_url_from_kitty.sh";
                    runtimeInputs = [
                        coreutils
                        curl
                        firefox
                        gawk
                        gnugrep
                        swayimg
                    ];
                    text =
                    let
                        awk = "${pkgs.gawk}/bin/awk";
                        curl = "${pkgs.curl}/bin/curl";
                        grep = "${pkgs.gnugrep}/bin/grep";
                        swayimg = "${pkgs.swayimg}/bin/swayimg";
                        firefox = "${pkgs.firefox}/bin/firefox";
                    in
                    ''
                        function panic {
                            echo "$*" 1>&2
                            exit 1
                        }


                        function get_extention {
                            local file_name
                            file_name=$(basename -- "$1")
                            echo "''${file_name##*.}" | tr -d '\s\t\n' | tr '[:upper:]' '[:lower:]'
                        }

                        function is_image {
                            local ext
                            local image_ext=("jpg" "bmp" "png" "jpeg" "gif" "webp")

                            ext="$(get_extention "$1")"
                            if echo "''${image_ext[@]}" | ${grep} -q -F -w "$ext"; then
                                return 0
                            fi

                            if ${curl} -Ils "$1" | ${awk} 'BEGIN{IGNORECASE=1}/content-type/ {print $2}' | ${grep} -q -i -F image; then
                                return 0
                            fi

                            return 1
                        }


                        if (($# != 1)); then
                            panic "please give the url!"
                        fi

                        if is_image "$1"; then
                            ${swayimg} "exec://${curl} -s -o - \"$1\""
                        else
                            ${firefox} --new-tab "$1"
                        fi
                    '';
                }
            )
        ];
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
